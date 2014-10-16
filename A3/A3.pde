String file = "data.csv";
PGraphics pickbuffer = null;
float current_time;
float DAMPENING = 0.1;

ArrayList<Node> nodeList;
float TIME_STEP = .01;
float k = -0.01;

// float COULOMB = 8.9875517873681764 * (pow(10, 9));
float COULOMB = 250;

int currentSelectedId = -1;
boolean hasBeenSelected = false;

void setup() {
    size(400, 400);
    background(255);
    frame.setResizable(true);
    current_time = 0;

	Parser parser = new Parser(file);
    nodeList = parser.parse();
        
}

void draw()  {
    current_time += TIME_STEP;
    pickbuffer = createGraphics(width, height);
    background(255);
    /* Calculation loops */
    for(int i = 0; i < nodeList.size(); i++) {
        /* per node */
        float netRepulsion = allRepulsionForces(nodeList.get(i), i);
        float netSpring = nodeList.get(i).totalSpringForces(k);
        //float netSpring = 0;

        /* Update velocities & accelerations */
        float allForces = (netRepulsion + netSpring) - DAMPENING;
        nodeList.get(i).updatePosition(TIME_STEP, allForces);
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

float allRepulsionForces(Node center, int index) {
    float sumForces = 0;
    for(int i = 0; i < nodeList.size(); i++) {
        if(i == index) continue;
        sumForces += coulomb_repulsion(center, nodeList.get(i));
        //println("sumForce: " + sumForces);
    }
    return sumForces;
}

float coulomb_repulsion(Node n, Node other) {
    float distance = dist(n.curX, n.curY, other.curX, other.curY);
    return COULOMB/distance;
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
	return universeEnergy;
}
