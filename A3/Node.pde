class Node {
    final float RADIUS_FACTOR = 4;
	int id, mass;
	ArrayList<Node> neighbors;
	ArrayList<Spring> springs;
	float curX, curY, curSpeed, curDirection;
    float radius;

	Node() {
        this(-1, -1);
	}


	Node(int id) {
        this(id, -1);
	}


	Node(int id, int mass) {
		this.id = id;
		this.mass = mass;
        this.radius = RADIUS_FACTOR * this.mass;
		neighbors = new ArrayList<Node>();
		springs = new ArrayList<Spring>();
		curSpeed = curDirection = 0.0;
        this.curX = random(0, width - this.radius);
        this.curY = random(0, height - this.radius);
        drawPosition(this.curX, this.curY);
	}

    void drawPosition(float x, float y) {
        this.curX = x;
        this.curY = y;
        ellipse(this.curX, this.curY, 2 * this.radius, 2 * this.radius);
    }

}
