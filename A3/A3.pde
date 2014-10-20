String file = "data.csv";
PGraphics pickbuffer = null;
float current_time;
float DAMPENING = 0.8; //to .8

ArrayList<Node> nodeList;
float TIME_STEP = .001;
float k = 0.5;
float LOWEST_ENERGY = 2.5;
boolean equilibrium;

float COULOMB = 500;

int currentSelectedId = -1;
boolean hasBeenSelected = false;

void setup() {
    size(800, 800);
    background(255);
    frame.setResizable(true);
    current_time = TIME_STEP;
    frameRate(20);
    equilibrium = false;

	Parser parser = new Parser(file);
    nodeList = parser.parse();

   for(int i = 0; i < nodeList.size(); i++) {

        PVector netRepulsion = allRepulsionForces(nodeList.get(i), i);
        PVector netSpring = nodeList.get(i).totalSpringForces(k);

        /* Update velocities & accelerations */
        PVector allForces = PVector.mult(PVector.add(netSpring, netRepulsion), DAMPENING);
        nodeList.get(i).updatePosition(current_time, allForces);
    }
        
}

void draw()  {
    current_time += TIME_STEP;
    pickbuffer = createGraphics(width, height);
    background(255);
    

    /* Calculation loops */
    if (!equilibrium) {
        for(int i = 0; i < nodeList.size(); i++) {

            PVector netRepulsion = allRepulsionForces(nodeList.get(i), i);
            PVector netSpring = nodeList.get(i).totalSpringForces(k);
            //float netSpring = 0;

            /* Update velocities & accelerations */
            //PVector allForces = PVector.mult(PVector.add(netSpring, netRepulsion), DAMPENING);
            PVector allForces = PVector.add(netSpring, netRepulsion);
            nodeList.get(i).updatePosition(current_time, allForces);
        }
    } else {
        println("LOW");

    }


    /* Now Render */
    drawPickBuffer();
   /* if (keyPressed) {
        image(pickbuffer, 0, 0);
    }*/

    for(Node n: nodeList)  {
        n.drawRelations();
    }

    for(Node n: nodeList) {
        if (n.isClickedOn) {
            n.setPos(mouseX, mouseY);
        }

        if (n.isect(pickbuffer)) {
            n.setHighlighted(); 
        } else {
            n.unsetHighlighted();
        }
        n.drawPosition(); 
    }

    systemEnergy();

}

PVector allRepulsionForces(Node center, int index) {
    /* PVector sumForces = PVector(0, 0);
     *      sumForces.add(coulomb_repulsion(center, nodeList.get(i)))
     */
    PVector sumForces = new PVector(0f,0f);
    for(int i = 0; i < nodeList.size(); i++) {
        if(i == index) continue;
        sumForces.add(coulomb_repulsion(center, nodeList.get(i)));
        //println("sumForce: " + sumForces);
    }
    return sumForces;
}

PVector coulomb_repulsion(Node n, Node other) {
    float distance = PVector.dist(n.position, other.position);
    if (distance < 1) {
        distance = 1;
    } 
    float magnitude = COULOMB / distance;

    PVector thisForce = PVector.sub(n.position, other.position);
    thisForce.normalize();
    thisForce.mult(magnitude);
    
    return thisForce;
}

void drawPickBuffer() {
    pickbuffer.beginDraw();

    for(Node n: nodeList) {
        n.renderISect(pickbuffer);
    }

    pickbuffer.endDraw();
}

void mousePressed() {
    for (Node n : nodeList) {
        if (n.isect(pickbuffer)) {
            n.isClickedOn = true;
            equilibrium = false;
        }
    }
}

void mouseReleased() {
    for (Node n : nodeList) {
        n.isClickedOn = false;
    }
}




/* Calculate total energy of the whole node system */
float systemEnergy() {
	float universeEnergy = 0;
	for(int i = 0; i < nodeList.size(); i++) {
		universeEnergy += nodeList.get(i).kinEnergy();
	}
    println("universeEnergy " + universeEnergy);
    if(universeEnergy < LOWEST_ENERGY) equilibrium = true;
    if(universeEnergy > LOWEST_ENERGY) equilibrium = false;
	return universeEnergy;
}
