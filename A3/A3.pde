String file = "data.csv";
PGraphics pickbuffer = null;

ArrayList<Node> nodeList;
float k = 0.1;

void setup() {
    size(1200, 800);
    background(255);

	//nodeList = new ArrayList<Node>();
	Parser parser = new Parser(file);
    nodeList = parser.parse();

    for(Node n: nodeList) {
        println(n.id + ": " + n.mass);
    }
        
}
