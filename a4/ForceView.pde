import java.util.Collections;
PGraphics pickbuffer = null;
float DAMPENING = 0.8 ; //to .8

float TIME_STEP = .9;
float k = 0.1; // from 0.5
float LOWEST_ENERGY = 0.5;
float CENTER_PULL = 0;

float COULOMB = 15000; // from 500

int currentSelectedId = -1;
boolean hasBeenSelected = false;

class ForceView {

    float leftX, leftY;
    float w, h;
    boolean equilibrium;
    ArrayList<Edge> edgeList;
    ArrayList<fNode> fNodeList;
    int minEdges, maxEdges;
    
    ForceView() {

        this.equilibrium = false;
        this.edgeList = new ArrayList<Edge>();
        this.fNodeList = fNodes;
        minEdges = Integer.MAX_VALUE;
        maxEdges= Integer.MIN_VALUE;
        makeConnections();
        setNeighbors();

        for(Edge e : this.edgeList) {
            println(e);
        }
    }

    fNode findNode(String ip) {
        for (fNode fn : this.fNodeList) {
            if (fn.myIP.equals(ip)) {
                return fn;
            }
        }

        println("Could not find Node, probs gonna crash now");
        return null;
    }

    void makeConnections() {
        boolean found = false;
        for (Node n : nodes) {
            for(Edge e : this.edgeList) {
                if((n.sIP.equals(e.ip1) || n.sIP.equals(e.ip2)) &&
                   (n.dIP.equals(e.ip1) || n.dIP.equals(e.ip2))) {
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
        int num_nodes = 0;
        for(Edge e : this.edgeList) {
            num_nodes = e.nIDs.size();
            if (num_nodes < this.minEdges) {
                this.minEdges = num_nodes;
            }
            if (num_nodes > this.maxEdges) {
                this.maxEdges = num_nodes;
            }
        }
    }

    void setNeighbors()  {
        for(Edge e : this.edgeList) {
            fNode par1 = findNode(e.ip1);
            fNode par2 = findNode(e.ip2);
            par1.neighbors.add(par2);
            par2.neighbors.add(par1);
            e.setLength(minEdges, maxEdges);
            par1.edges.add(e);
        }
    }

    void setDims(float _leftX, float _leftY, float _w, float _h) {
        this.leftX = _leftX;
        this.leftY = _leftY;
        this.w = _w;
        this.h = _h;
    }

    void setup() {
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

        hover();

        for (Edge e : this.edgeList) {
            fNode nOne = findNode(e.ip1);
            fNode nTwo = findNode(e.ip2);
            pushStyle();
            strokeWeight(e.edgeWeight);
            boolean highlight = false;
            for(int i : e.nIDs) {
                if(selected_nodes.contains(i)) {
                    highlight = true;
                }
            }
            if(highlight) {
                stroke(pointHighLight);
            }
            line(nOne.position.x, nOne.position.y, nTwo.position.x, nTwo.position.y);
            popStyle();
        }



        String energyLabel = str(systemEnergy());
        text(energyLabel, this.w - textWidth(energyLabel) - 2, this.h - 10);

    }
    void hover() {
        for(fNode n: fNodeList) {
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

    void calcAndUpdate() {
        for(int i = 0; i < fNodeList.size(); i++) {

            PVector netRepulsion = allRepulsionForces(fNodeList.get(i), i);
            PVector netSpring = fNodeList.get(i).totalEdgeForces(k);

            /* Update velocities & accelerations */
            PVector allForces = PVector.mult(PVector.add(netSpring, netRepulsion), DAMPENING);
            fNodeList.get(i).updatePosition(TIME_STEP, allForces);
        }
    }

    void pullTowardsCenter() {
        for (fNode n: fNodeList) {
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
        for(int i = 0; i < fNodeList.size(); i++) {
            if(i == index) continue;
            sumForces.add(coulomb_repulsion(center, fNodeList.get(i)));
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

        for(fNode n: fNodeList) {
            n.renderISect(pickbuffer);
        }

        pickbuffer.endDraw();
    }


    /* Calculate total energy of the whole node system */
    float systemEnergy() {
        float universeEnergy = 0;
        for(int i = 0; i < fNodeList.size(); i++) {
            universeEnergy += fNodeList.get(i).kinEnergy();
        }
        if(universeEnergy < LOWEST_ENERGY) equilibrium = true;
        if(universeEnergy > LOWEST_ENERGY) equilibrium = false;
        return universeEnergy;
    }

}
