String file = "data.csv";

ArrayList<Node> nodeList;
float k = 0.1;

void setup() {
    size(1200, 800);
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





/* Calculate total energy of the whole node system */
float systemEnergy() {
	float universeEnergy = 0;
	for(int i = 0; i < nodeList.size(); i++) {
		universeEnergy += nodeList.get(i).kinEnergy();
	}
	return universeEnergy;
}
