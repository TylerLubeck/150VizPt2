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
    /* Draw all those relations right quick */
    for(int i = 0; i < nodeList.size(); i++) {
    	nodeList.get(i).drawRelations();
    }

    for(Node n: nodeList) {
        println(n.id + ": " + n.mass);
    }
        
}
