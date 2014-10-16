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
float DAMPENING = 0.1f;

ArrayList<Node> nodeList;
float TIME_STEP = .0001f;
float k = -0.01f;

// float COULOMB = 8.9875517873681764 * (pow(10, 9));
float COULOMB = 250;

int currentSelectedId = -1;
boolean hasBeenSelected = false;

public void setup() {
    size(400, 400);
    background(255);
    frame.setResizable(true);
    current_time = 0;

	Parser parser = new Parser(file);
    nodeList = parser.parse();
        
}

public void draw()  {
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
        nodeList.get(i).updatePosition(current_time, allForces);
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

public float allRepulsionForces(Node center, int index) {
    float sumForces = 0;
    for(int i = 0; i < nodeList.size(); i++) {
        if(i == index) continue;
        sumForces += coulomb_repulsion(center, nodeList.get(i));
        //println("sumForce: " + sumForces);
    }
    return sumForces;
}

public float coulomb_repulsion(Node n, Node other) {
    float distance = dist(n.curX, n.curY, other.curX, other.curY);
    return COULOMB/distance;
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
	return universeEnergy;
}
class Node {
    final float RADIUS_FACTOR = 4;
	int id, mass;
	ArrayList<Node> neighbors;
	ArrayList<Spring> springs;
	float curX, curY, curSpeed, curDirection;
    float radius;
    float r, g, b;
    boolean isClickedOn;
    float netVel;
    float velX, velY;
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
        this.r = red(id);
        this.g = green(id);
        this.b = blue(id);
		this.mass = mass;
        this.netVel = 0;
        this.velX = 0;
        this.velY = 0;
        this.radius = RADIUS_FACTOR * this.mass;
        this.isClickedOn = false;
		neighbors = new ArrayList<Node>();
		springs = new ArrayList<Spring>();
		curSpeed = curDirection = 0.0f;
        this.curX = random(0, width - this.radius);
        this.curY = random(0, height - this.radius);
        this.highlightColor = color(255, 0, 0);
        this.defaultColor = color(0, 255, 0);
        this.fillColor = this.defaultColor;
        drawPosition();
	}

    public void setPos(float newX, float newY) {

        newX = newX < this.radius ? this.radius : newX;
        newX = newX > width - this.radius ? width - this.radius : newX;

        newY = newY < this.radius ? this.radius : newY;
        newY = newY > height - this.radius ? height - this.radius : newY;

        this.curX = newX;
        this.curY = newY;
    }


    /* PROBABLY FUCKIN UP IN HERRRRRR, splitting into x & y */
    public void updatePosition(float currTime, float force) {
        float acceleration = force / this.mass;
        /* v = vo + a * t */
        netVel = netVel + acceleration * currTime;
        float velX_ = netVel * cos(PI/4);
        float velY_ = netVel * sin(PI/4);
        float posX = this.curX + velX_ * currTime + 
                     .5f * (acceleration * cos(PI/4)) * sq(currTime);
        float posY = this.curY + velY_ * currTime + 
                     .5f * (acceleration * sin(PI/4)) * sq(currTime);

        setPos(posX, posY);
    }

    public float totalSpringForces(float k_hooke) {
        float totalForce = 0;
        for(int i = 0; i < springs.size(); i++) { /* Cause neighbors and springs indices line up */
            float distance = dist(curX, curY, neighbors.get(i).curX, neighbors.get(i).curY);
            /* calculate total forces exerted by attached springs */
            totalForce += springs.get(i).getForce(k_hooke, distance);
        }
        return totalForce;
    }


    public void drawPosition() {
        fill(this.fillColor);
        stroke(this.fillColor);
        ellipse(this.curX, this.curY, 2 * this.radius, 2 * this.radius);
        fill(this.defaultColor);
        stroke(this.defaultColor);
    }

    public void drawRelations() {
    	for(int i = 0; i < neighbors.size(); i++) {
    		line(curX, curY, neighbors.get(i).curX, neighbors.get(i).curY);
    	}
    }

    public void renderISect(PGraphics pg) {
        pg.fill(this.r, this.g, this.b);
        pg.stroke(this.r, this.g, this.b);
        pg.strokeWeight(5);
        pg.ellipse(this.curX, this.curY, 2 * this.radius, 2 * this.radius);
    }

    public void renderSelected() {
        strokeWeight(1);
        stroke(this.r, this.g, this.b);
        fill(this.r, this.g, this.b, 128);
        ellipse(this.curX, this.curY, 2 * this.radius, 2 * this.radius);
    }

    public boolean isect(PGraphics img)  {
        if (img.get(mouseX, mouseY) == color(this.r, this.g, this.b)) {
            return true;
        }
        return false;
    }

    public float kinEnergy() {
    	float totesVel = sqrt(pow(this.velX, 2) + pow(this.velY, 2));
    	return (.5f * this.mass * totesVel);
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
	double springL;

	Spring(double sprL) {
		this.springL = sprL;
	}

	public double getForce(float k, float cur_length) {
		return (this.springL - cur_length) * k;
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
