String file = "data.csv";

ArrayList<Node> nodes;

void setup() {
        size(1200, 800);
	nodes = new ArrayList<Node>();
	Parser parser = new Parser(file);
        
}
