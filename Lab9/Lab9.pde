import java.util.Collections;

String file = "data1.csv";

ArrayList<RelationshipNode> nodes;
ArrayList<Connection> connections;

void setup() {
    nodes = new ArrayList<RelationshipNode>();
    connections = new ArrayList<Connection>();
    Parser parser = new Parser(file);
    println("nodes");
    for (RelationshipNode node : nodes)
      node.print();
    println("connections");
    for (Connection con : connections)
      con.print();
}
