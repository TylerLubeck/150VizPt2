import java.util.Collections;
PGraphics pickbuffer = null;
float DAMPENING = 0.8; //to .8

float TIME_STEP = .9;
float k = 0.1; // from 0.5
float LOWEST_ENERGY = 0.5;
float CENTER_PULL = 1.0;

float COULOMB = 15000; // from 500

int currentSelectedId = -1;
boolean hasBeenSelected = false;

class ForceView {

    float leftX, leftY;
    float w, h;
    boolean equilibrium;
    ArrayList<Edge> edgeList;
    ArrayList<fNode> ipList;
    ArrayList<fNode> fNodeList;
    
    ForceView() {
        this.equilibrium = false;
        this.ipList = new ArrayList<fNode>();
        this.edgeList = new ArrayList<Edge>();
        this.fNodeList = new ArrayList<fNode>();
        makeConnections();
    }


    void makeConnections() {
        boolean found = false;
        for (Node n : nodes) {
            for(Edge e : this.edgeList) {
                if((n.sIP.equals(e.ip1) || n.sIP.equals(e.ip2)) &&
                   (n.dIP.equals(e.ip1) || n.dIP.equals(e.ip2))) {
                        //println("FOUND DUPLICATE");
                        e.nIDs.add(n.id);
                        found = true;
                }
            }
            if (! found)  {
                Edge e = new Edge(n.sIP, n.dIP, n.id);
                this.edgeList.add(e);
            }

            found = false;
        }
        //*
        for(Edge e : this.edgeList) {
           println(e); 
        }
        //*/
    }

    void setDims(float _leftX, float _leftY, float _w, float _h) {
        this.leftX = _leftX;
        this.leftY = _leftY;
        this.w = _w;
        this.h = _h;
    }

    void setup() {
        //Parser parser = new Parser(file);
        //ipList = parser.parse();
        //Collections.sort(ipList);

        calcAndUpdate();
    }

    void display(float _leftX, float _leftY, float _w, float _h)  {
        setDims(_leftX, _leftY, _w, _h);
        pickbuffer = createGraphics((int)this.w, (int)this.h);


        /* Calculation loops */
        if (!equilibrium) {
            calcAndUpdate();
        } 
        else {
            pullTowardsCenter();
        }

        /* Now Render */
        drawPickBuffer();

        for(fNode n: ipList) {
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

        for(fNode n: ipList)  {
            n.drawRelations();
        }


        String energyLabel = str(systemEnergy());
        text(energyLabel, this.w - textWidth(energyLabel) - 2, this.h - 10);

    }

    void calcAndUpdate() {
        for(int i = 0; i < ipList.size(); i++) {

            PVector netRepulsion = allRepulsionForces(ipList.get(i), i);
            PVector netSpring = ipList.get(i).totalEdgeForces(k);

            /* Update velocities & accelerations */
            PVector allForces = PVector.mult(PVector.add(netSpring, netRepulsion), DAMPENING);
            ipList.get(i).updatePosition(TIME_STEP, allForces);
        }
    }

    void pullTowardsCenter() {
        for (fNode n: ipList) {
            float X = this.w / 2 - n.position.x;
            float Y = this.h / 2 - n.position.y;

            PVector pull = new PVector(X, Y);
            pull.normalize();
            pull.mult(CENTER_PULL);
            n.updatePosition(TIME_STEP, pull);
        }
    }

    PVector allRepulsionForces(fNode center, int index) {
        PVector sumForces = new PVector(0f,0f);
        for(int i = 0; i < ipList.size(); i++) {
            if(i == index) continue;
            sumForces.add(coulomb_repulsion(center, ipList.get(i)));
        }
        return sumForces;
    }

    PVector coulomb_repulsion(fNode n, fNode other) {
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

        for(fNode n: ipList) {
            n.renderISect(pickbuffer);
        }

        pickbuffer.endDraw();
    }

    void mousePressed() {
        for (fNode n : ipList) {
            if (n.isect(pickbuffer)) {
                n.isClickedOn = true;
                equilibrium = false;
            }
        }
    }

    void mouseReleased() {
        for (fNode n : ipList) {
            n.isClickedOn = false;
        }
        calcAndUpdate();
    }

    /* Calculate total energy of the whole node system */
    float systemEnergy() {
        float universeEnergy = 0;
        for(int i = 0; i < ipList.size(); i++) {
            universeEnergy += ipList.get(i).kinEnergy();
        }
        if(universeEnergy < LOWEST_ENERGY) equilibrium = true;
        if(universeEnergy > LOWEST_ENERGY) equilibrium = false;
        return universeEnergy;
    }

}
