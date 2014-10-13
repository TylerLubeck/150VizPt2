String file = "data.csv";

ArrayList<Node> nodes;
float k = 3.5;

void setup() {
        size(1200, 800);
	nodes = new ArrayList<Node>();
	Parser parser = new Parser(file);
        
}
