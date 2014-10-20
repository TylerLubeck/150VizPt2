import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class A3 extends PApplet {

String file = "data.csv";
PGraphics pickbuffer = null;
float current_time;
float DAMPENING = 0.8f; //to .8

ArrayList<Node> nodeList;
float TIME_STEP = .15f;
float k = 0.5f;
float LOWEST_ENERGY = .5f;
boolean equilibrium;

float COULOMB = 500;

int currentSelectedId = -1;
boolean hasBeenSelected = false;

public void setup() {
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

public void draw()  {
    current_time += TIME_STEP;
    pickbuffer = createGraphics(width, height);
    background(255);
    

    /* Calculation loops */
    if (!equilibrium) {
        for(int i = 0; i < nodeList.size(); i++) {

            PVector netRepulsion = allRepulsionForces(nodeList.get(i), i);
            PVector netSpring = nodeList.get(i).totalSpringForces(k);

            /* Update velocities & accelerations */
            PVector allForces = PVector.add(netSpring, netRepulsion);
            nodeList.get(i).updatePosition(TIME_STEP, allForces);
        }
    } else {
        println("LOW");

    }


    /* Now Render */
    drawPickBuffer();

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

public PVector allRepulsionForces(Node center, int index) {
    PVector sumForces = new PVector(0f,0f);
    for(int i = 0; i < nodeList.size(); i++) {
        if(i == index) continue;
        sumForces.add(coulomb_repulsion(center, nodeList.get(i)));
    }
    return sumForces;
}

public PVector coulomb_repulsion(Node n, Node other) {
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

public void drawPickBuffer() {
    pickbuffer.beginDraw();

    for(Node n: nodeList) {
        n.renderISect(pickbuffer);
    }

    pickbuffer.endDraw();
}

public void mousePressed() {
    for (Node n : nodeList) {
        if (n.isect(pickbuffer)) {
            n.isClickedOn = true;
            equilibrium = false;
        }
    }
}

public void mouseReleased() {
    for (Node n : nodeList) {
        n.isClickedOn = false;
    }
}




/* Calculate total energy of the whole node system */
public float systemEnergy() {
	float universeEnergy = 0;
	for(int i = 0; i < nodeList.size(); i++) {
		universeEnergy += nodeList.get(i).kinEnergy();
	}
    println("universeEnergy " + universeEnergy);
    if(universeEnergy < LOWEST_ENERGY) equilibrium = true;
    if(universeEnergy > LOWEST_ENERGY) equilibrium = false;
	return universeEnergy;
}
class Node {
    final float RADIUS_FACTOR = 3;
	int id, mass;
	ArrayList<Node> neighbors;
	ArrayList<Spring> springs;
    float radius;
    float r, g, b;
    boolean isClickedOn;
    PVector netVel;
    PVector position;
    int COLOR_HIGHLIGHT = color(27, 166, 166);
    int COLOR_DEFAULT = color(27, 112, 166);
    int fillColor;
    int COLOR_STROKE = color(52, 92, 166);

	Node() {
        this(-1, -1);
	}


	Node(int id) {
        this(id, -1);
	}


	Node(int id, int mass) {
		this.id = id;
        this.mass = mass;
        this.r = red(id); this.g = green(id); this.b = blue(id);
        
        float _X = random(0, width - this.radius);
        float _Y = random(0, height - this.radius);
        this.position = new PVector(_X, _Y);
        
        this.fillColor = COLOR_DEFAULT;

        this.isClickedOn = false;
        this.radius = RADIUS_FACTOR * this.mass;

        neighbors = new ArrayList<Node>();
        springs = new ArrayList<Spring>();
		
        this.netVel = new PVector(0f, 0f);
        
        setPos(this.position);
        drawPosition();
	}

    public void setPos(PVector pos) {
        setPos(pos.x, pos.y);
    }

    public void setPos(float newX, float newY) {

        /* Bound the circles */
        newX = newX < this.radius ? this.radius : newX;
        newX = newX > width - this.radius ? width - this.radius : newX;

        newY = newY < this.radius ? this.radius : newY;
        newY = newY > height - this.radius ? height - this.radius : newY;
        /*******/

        this.position.set(newX, newY);
    }


    public void updatePosition(float currTime, PVector force) {
        PVector acceleration = PVector.div(force, this.mass);
        
        /* v = vo + a * t */
        acceleration.mult(currTime);
        netVel.add(acceleration);
        netVel.mult(DAMPENING);
        
        /* s = so + vt + .5 a t^2 */
        PVector at = PVector.mult(acceleration, .5f * currTime);
        PVector vt = PVector.mult(netVel, currTime);

        PVector newPos = PVector.add(this.position, vt);
        newPos.add(at);

        setPos(newPos);
        
    }

    public PVector totalSpringForces(float k_hooke) {
        PVector totalForces = new PVector(0f, 0f);
        for(int i = 0; i < this.springs.size(); i++) {
            Node neighbor = this.neighbors.get(i);
            Spring spring = this.springs.get(i);
            PVector thisForce = PVector.sub(this.position, neighbor.position);

            float currLength = dist(this.position.x, this.position.y, 
                                    neighbor.position.x, neighbor.position.y);
            currLength *= -1;

            float magnitude = currLength - spring.springL;
            magnitude *= k_hooke;


            thisForce.normalize();
            thisForce.mult(magnitude);
            
            // Get length of spring - goal length
            totalForces.add(thisForce);
        }
        return totalForces;
    }


    public void drawPosition() {
        fill(this.fillColor);
        stroke(COLOR_STROKE);
        ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
        fill(this.fillColor);
        stroke(COLOR_STROKE);
    }

    public void drawRelations() {
    	for(int i = 0; i < neighbors.size(); i++) {
    		line(position.x, position.y, neighbors.get(i).position.x, neighbors.get(i).position.y);
    	}
    }

    public void renderISect(PGraphics pg) {
        pg.fill(this.r, this.g, this.b);
        pg.stroke(this.r, this.g, this.b);
        pg.strokeWeight(5);
        pg.ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
    }

    public void renderSelected() {
        strokeWeight(1);
        stroke(this.r, this.g, this.b);
        fill(this.r, this.g, this.b, 128);
        ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
    }

    public boolean isect(PGraphics img)  {
        if (img.get(mouseX, mouseY) == color(this.r, this.g, this.b)) {
            return true;
        }
        return false;
    }

    public float kinEnergy() {
    	return (.5f * this.mass * netVel.mag());
    }


    public void setHighlighted() {
        this.fillColor = COLOR_HIGHLIGHT;
    }

    public void unsetHighlighted() {
        this.fillColor = COLOR_DEFAULT;
    }
}
class Parser {
    ArrayList<Node> nodes;
	
	Parser(String fileName) {
        this.nodes = new ArrayList<Node>();
		String tempData[];
		Node tempNode;
		Spring tempSpring;
		String data[] = loadStrings(fileName);
		int numNodes = Integer.parseInt(trim(data[0]));
  		int numRltns = Integer.parseInt(trim(data[numNodes+1]));
  		for(int i = 1; i <= numNodes; ++i) {
  			tempData = splitTokens(data[i], ",");
  			tempNode = new Node(Integer.parseInt(trim(tempData[0])), Integer.parseInt(trim(tempData[1])));
  			nodes.add(tempNode);
  		}
  		for (int i = numNodes + 2; i < numNodes + 2 + numRltns; ++i) {
  			tempData = splitTokens(data[i], ",");
  			tempSpring = new Spring(Double.parseDouble(trim(tempData[2])));
  			makeConnection(Integer.parseInt(trim(tempData[0])), Integer.parseInt(trim(tempData[1])), tempSpring);
  		}
	}

    public ArrayList<Node> parse() {
        return this.nodes;
    }

	public void makeConnection(int id1, int id2, Spring spring) {
		int index1 = -1;
		int index2 = -1;
		for (int i = 0; i < nodes.size(); ++i) {
			if (nodes.get(i).id == id1)
				index1 = i;
			else if (nodes.get(i).id == id2)
				index2 = i;
		}
		if (index1 == -1 || index2 == -1) {
			println("ERROR IN PARSING");
        }
		nodes.get(index1).neighbors.add(nodes.get(index2));
		nodes.get(index1).springs.add(spring);
		nodes.get(index2).neighbors.add(nodes.get(index1));
		nodes.get(index2).springs.add(spring);
	}
}
class Spring {
	float springL;
    float currLength;

	Spring(double sprL) {
        this.springL = (float)sprL;
	}

    /*
	PVector getForce(float k, PVector curr_dir) {
		PVector temp = PVector.sub(this.springL, curr_dir);
		temp.mult(k);
		return temp;
	}
    */

    /*
    float getLength() {
        return dist(left.position.x, left.position.y, 
                    right.position.x, right.position.y);
    }
    */
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "A3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
