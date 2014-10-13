class Node {
	int id, mass;
	ArrayList<Node> neighbors;
	ArrayList<Spring> springs;
	float curX, curY, curSpeed, curDirection;

	Node() {
		this.id = -1;
		this.mass = -1;
		neighbors = new ArrayList<Node>();
		springs = new ArrayList<Spring>();
		curX = curY = curSpeed = curDirection = 0.0;
	}


	Node(int id) {
		this.id = id;
		this.mass = -1;
		neighbors = new ArrayList<Node>();
		springs = new ArrayList<Spring>();
		curX = curY = curSpeed = curDirection = 0.0;
	}


	Node(int id, int mass) {
		this.id = id;
		this.mass = mass;
		neighbors = new ArrayList<Node>();
		springs = new ArrayList<Spring>();
		curX = curY = curSpeed = curDirection = 0.0;
	}
}
