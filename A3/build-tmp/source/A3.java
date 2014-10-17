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
float DAMPENING = 0.9f;

ArrayList<Node> nodeList;
float TIME_STEP = .01f;
float k = 0.01f;
float LOWEST_ENERGY = 0.5f;

// float COULOMB = 8.9875517873681764 * (pow(10, 9));
float COULOMB = 250;

int currentSelectedId = -1;
boolean hasBeenSelected = false;

public void setup() {
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

public void draw()  {
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

public PVector allRepulsionForces(Node center, int index) {
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

public PVector coulomb_repulsion(Node n, Node other) {
    PVector repulse = new PVector(COULOMB / (n.position.x - other.position.x), COULOMB / (n.position.y - other.position.y));
    return repulse;
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
	return universeEnergy;
}
class Node {
    final float RADIUS_FACTOR = 4;
	int id, mass;
	ArrayList<Node> neighbors;
	ArrayList<Spring> springs;
    float radius;
    float r, g, b;
    boolean isClickedOn;
    PVector netVel;
    PVector position;
    int highlightColor;
    int defaultColor;
    int fillColor;

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
        
        this.highlightColor = color(255, 0, 0);
        this.defaultColor = color(0, 255, 0);
        this.fillColor = this.defaultColor;

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

        newX = newX < this.radius ? this.radius : newX;
        newX = newX > width - this.radius ? width - this.radius : newX;

        newY = newY < this.radius ? this.radius : newY;
        newY = newY > height - this.radius ? height - this.radius : newY;

        this.position.set(newX, newY);
    }


    public void updatePosition(float currTime, PVector force) {
        PVector acceleration = PVector.div(force, this.mass);
        //println("acceleration: " + acceleration);
        /* v = vo + a * t */
        netVel.add(acceleration);
        netVel.mult(currTime);

        float velX_ = netVel.x;
        float velY_ = netVel.y;
        /* s = so + vt + .5 a t^2 */
        float posX = this.position.x + velX_ * currTime + 
                     .5f * (acceleration.x) * sq(currTime);
        float posY = this.position.y + velY_ * currTime + 
                     .5f * (acceleration.y) * sq(currTime);


        setPos(posX, posY);
    }

    public PVector totalSpringForces(float k_hooke) {
        PVector totalForce = new PVector(0f,0f);
        for(int i = 0; i < springs.size(); i++) { /* Cause neighbors and springs indices line up */
            PVector dir = new PVector(this.position.x - neighbors.get(i).position.x, 
                                      this.position.y - neighbors.get(i).position.y);
            /* calculate total forces exerted by attached springs */
            totalForce.add(springs.get(i).getForce(k_hooke, dir));
        }
        println("SPRING FORCE: " + totalForce);
        totalForce.mult(-1f);
        return totalForce;
        //return new PVector(0f, 0f);
    }


    public void drawPosition() {
        fill(this.fillColor);
        stroke(this.fillColor);
        ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
        fill(this.defaultColor);
        stroke(this.defaultColor);
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
        this.fillColor = this.highlightColor;
    }

    public void unsetHighlighted() {
        this.fillColor = this.defaultColor;
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
	PVector springL;

	Spring(double sprL) {
		this.springL = new PVector(1f, 1f);
		this.springL.mult((float)sprL);
	}

	public PVector getForce(float k, PVector curr_dir) {
		PVector temp = PVector.sub(this.springL, curr_dir);
		temp.mult(k);
		return temp;

	}
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
