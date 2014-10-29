ArrayList<Node> nodes;
void setup() {
    Parser parser = new Parser("data_aggregate.csv");
    nodes = parser.parse();
    for (Node n : nodes) {
        println(n);
    }

}

void loop() {

}
