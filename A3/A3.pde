String file = "data.csv";
PGraphics pickbuffer = null;
float current_time;
float DAMPENING = 0.9;

ArrayList<Node> nodeList;
float TIME_STEP = .01;
float k = 0.01;
float LOWEST_ENERGY = 0.5;

// float COULOMB = 8.9875517873681764 * (pow(10, 9));
float COULOMB = 250;

int currentSelectedId = -1;
boolean hasBeenSelected = false;

void setup() {
    size(800, 800);
    background(255);
    frame.setResizable(true);
    current_time = TIME_STEP;

	Parser parser = new Parser(file);
    nodeList = parser.parse();

   for(int i = 0; i < nodeList.size(); i++) {

        PVector netRepulsion = allRepulsionForces(nodeList.get(i), i);
        PVector netSpring = nodeList.get(i).totalSpringForces(k);
        //float netSpring = 0;

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

    if (systemEnergy() > LOWEST_ENERGY) {
        for(int i = 0; i < nodeList.size(); i++) {

            PVector netRepulsion = allRepulsionForces(nodeList.get(i), i);
            PVector netSpring = nodeList.get(i).totalSpringForces(k);
            //float netSpring = 0;

            /* Update velocities & accelerations */
            PVector allForces = PVector.mult(PVector.add(netSpring, netRepulsion), DAMPENING);
            nodeList.get(i).updatePosition(current_time, allForces);
        }
    } else {
        println("LOW");

    }


    /* Now Render */
    drawPickBuffer();
    if (keyPressed) {
        image(pickbuffer, 0, 0);
    }

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
    PVector repulse = new PVector(COULOMB / (n.position.x - other.position.x), COULOMB / (n.position.y - other.position.y));
    return repulse;
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
	return universeEnergy;
}
