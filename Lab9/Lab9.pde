import java.util.Collections;

static int SQUARE_SIZE = 15;
static int DEFAULT_SPRING = 10;
float DAMPENING = 0.8; //to .8
float TIME_STEP = 3;
float k = 0.1; // from 0.5
float LOWEST_ENERGY = 0.5;
float CENTER_PULL = 0;
boolean equilibrium;
String file = "data1.csv";


float COULOMB = 5000; // from 500

ArrayList<RelationshipNode> nodes;
ArrayList<Connection> connections;

void setup() {
    size(1600, 800);
    background(255);
    nodes = new ArrayList<RelationshipNode>();
    connections = new ArrayList<Connection>();
    Parser parser = new Parser(file);
    equilibrium = false;
    
    calcAndUpdate();
}

void draw() {
    background(255);
    if (!equilibrium) {
        calcAndUpdate();
    } 
    // else {
    //     pullTowardsCenter();
    // }
    
    for (RelationshipNode node : nodes) {
         if (node.isClickedOn) {
            node.setPos(mouseX, mouseY); 
         }
         node.drawPosition();
    } 
    drawConnections();
}

void drawConnections() {
    int index1 = -1, index2 = -1;
    PVector start, end;
    for (int i = 0; i < connections.size(); ++i) {
        for (int j = 0; j < nodes.size(); ++j) {
                if (nodes.get(j).id == connections.get(i).rNode1)
                    index1 = j;
                else if (nodes.get(j).id == connections.get(i).rNode2)
                    index2 = j;
        }
        start = nodes.get(index1).getNameLocation(nodes.get(index2).position, connections.get(i).name1);
        end = nodes.get(index2).getNameLocation(nodes.get(index1).position, connections.get(i).name2);    
        line(start.x, start.y, end.x, end.y);
    }
}

void calcAndUpdate() {
    for(int i = 0; i < nodes.size(); i++) {

        PVector netRepulsion = allRepulsionForces(nodes.get(i), i);
        PVector netSpring = nodes.get(i).totalSpringForces(k);

        /* Update velocities & accelerations */
        PVector allForces = PVector.mult(PVector.add(netSpring, netRepulsion), DAMPENING);
        nodes.get(i).updatePosition(TIME_STEP, allForces);
    }
}

void pullTowardsCenter() {
    for (RelationshipNode n: nodes) {
        float X = width / 2 - n.position.x;
        float Y = height / 2 - n.position.y;

        PVector pull = new PVector(X, Y);
        pull.normalize();
        pull.mult(CENTER_PULL);
        n.updatePosition(TIME_STEP, pull);
    }
}

PVector allRepulsionForces(RelationshipNode center, int index) {
    PVector sumForces = new PVector(0f,0f);
    for(int i = 0; i < nodes.size(); i++) {
        if(i == index) continue;
        sumForces.add(coulomb_repulsion(center, nodes.get(i)));
    }
    return sumForces;
}

PVector coulomb_repulsion(RelationshipNode n, RelationshipNode other) {
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


/* Calculate total energy of the whole node system */
float systemEnergy() {
  float universeEnergy = 0;
  for(int i = 0; i < nodes.size(); i++) {
    universeEnergy += nodes.get(i).kinEnergy();
  }
    if(universeEnergy < LOWEST_ENERGY) equilibrium = true;
    if(universeEnergy > LOWEST_ENERGY) equilibrium = false;
    return universeEnergy;
}

void mousePressed() {
    for (RelationshipNode n : nodes) {
        if (n.intersects()) {
            n.isClickedOn = true;
            equilibrium = false;
        }
    }
}

void mouseReleased() {
    for (RelationshipNode n : nodes) {
        n.isClickedOn = false;
    }
    calcAndUpdate();
}
