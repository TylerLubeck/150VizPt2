class Node {
    final float RADIUS_FACTOR = 4;
	int id, mass;
	ArrayList<Node> neighbors;
	ArrayList<Spring> springs;
	float curX, curY, curSpeed, curDirection;
    float radius;
    float r, g, b;
    boolean isClickedOn;
    float velX, velY;

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
        this.radius = RADIUS_FACTOR * this.mass;
        this.isClickedOn = false;
		neighbors = new ArrayList<Node>();
		springs = new ArrayList<Spring>();
		curSpeed = curDirection = 0.0;
        this.curX = random(0, width - this.radius);
        this.curY = random(0, height - this.radius);
        drawPosition(this.curX, this.curY);
	}

    void setPos(float curX, float curY) {
        this.curX = curX;
        this.curY = curY;
    }

    void drawPosition() {
        drawPosition(this.curX, this.curY);
    }
    
    void drawPosition(float x, float y) {
        this.curX = x;
        this.curY = y;
        ellipse(this.curX, this.curY, 2 * this.radius, 2 * this.radius);
    }

    void drawRelations() {
    	for(int i = 0; i < neighbors.size(); i++) {
    		line(curX, curY, neighbors.get(i).curX, neighbors.get(i).curY);
    	}
    }

    void renderISect(PGraphics pg) {
        pg.fill(this.r, this.g, this.b);
        pg.stroke(this.r, this.g, this.b);
        pg.strokeWeight(5);
        pg.ellipse(this.curX, this.curY, 2 * this.radius, 2 * this.radius);
    }

    void renderSelected() {
        strokeWeight(1);
        stroke(this.r, this.g, this.b);
        fill(this.r, this.g, this.b, 128);
        ellipse(this.curX, this.curY, 2 * this.radius, 2 * this.radius);
    }

    boolean isect(PGraphics img)  {
        if (img.get(mouseX, mouseY) == color(this.r, this.g, this.b)) {
            return true;
        }
        return false;
    }

    float kinEnergy() {
    	float totesVel = sqrt(pow(this.velX, 2) + pow(this.velY, 2));
    	return (.5 * this.mass * totesVel);
    }

}
