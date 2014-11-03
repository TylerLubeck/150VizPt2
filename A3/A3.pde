import java.util.Collections;
String file = "data.csv";
PGraphics pickbuffer = null;
float DAMPENING = 0.8; //to .8

ArrayList<Node> nodeList;
float TIME_STEP = .9;
float k = 0.1; // from 0.5
float LOWEST_ENERGY = 0.5;
float CENTER_PULL = 1.0;
boolean equilibrium;

float COULOMB = 15000; // from 500

int currentSelectedId = -1;
boolean hasBeenSelected = false;

void setup() {
    PFont f = loadFont("AdobeKaitiStd-Regular-16.vlw");
    textFont(f, 16);
    size(800, 800);
    background(255);
    frame.setResizable(true);
    //frameRate(20);
    equilibrium = false;

    Parser parser = new Parser(file);
    nodeList = parser.parse();
    Collections.sort(nodeList);

    calcAndUpdate();

}

void draw()  {
    pickbuffer = createGraphics(width, height);
    background(255);
    

    /* Calculation loops */
    if (!equilibrium) {
        calcAndUpdate();
    } 
    else {
        pullTowardsCenter();
    }

    /* Now Render */
    drawPickBuffer();

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
    
    for(Node n: nodeList)  {
        n.drawRelations();
    }


    String energyLabel = str(systemEnergy());
    text(energyLabel, width - textWidth(energyLabel) - 2, height - 10);

}

void calcAndUpdate() {
    for(int i = 0; i < nodeList.size(); i++) {

        PVector netRepulsion = allRepulsionForces(nodeList.get(i), i);
        PVector netSpring = nodeList.get(i).totalSpringForces(k);

        /* Update velocities & accelerations */
        PVector allForces = PVector.mult(PVector.add(netSpring, netRepulsion), DAMPENING);
        nodeList.get(i).updatePosition(TIME_STEP, allForces);
    }
}

void pullTowardsCenter() {
    for (Node n: nodeList) {
        float X = width / 2 - n.position.x;
        float Y = height / 2 - n.position.y;

        PVector pull = new PVector(X, Y);
        pull.normalize();
        pull.mult(CENTER_PULL);
        n.updatePosition(TIME_STEP, pull);
    }
}

PVector allRepulsionForces(Node center, int index) {
    PVector sumForces = new PVector(0f,0f);
    for(int i = 0; i < nodeList.size(); i++) {
        if(i == index) continue;
        sumForces.add(coulomb_repulsion(center, nodeList.get(i)));
    }
    return sumForces;
}

PVector coulomb_repulsion(Node n, Node other) {
    float distance = PVector.dist(n.position, other.position);
    if (distance < 1) {
        distance = 1;
    } 
    float magnitude = COULOMB / (distance * distance);

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
    calcAndUpdate();
}

/* Calculate total energy of the whole node system */
float systemEnergy() {
	float universeEnergy = 0;
	for(int i = 0; i < nodeList.size(); i++) {
		universeEnergy += nodeList.get(i).kinEnergy();
	}
    if(universeEnergy < LOWEST_ENERGY) equilibrium = true;
    if(universeEnergy > LOWEST_ENERGY) equilibrium = false;
    return universeEnergy;
}
