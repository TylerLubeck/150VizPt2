class Parser {

    /*
     * List of Nodes
     * Each Node:
     *      ArrayList of Names
     *      2D Array Names.size() x Names.size() // new class for this
     *          each intersection has a number representing strength
     *
     */


    Parser(String filename) {
        String lines[] = loadStrings(filename);
        int num_nodes = Integer.parseInt(trim(lines[0]));
        int curr_line = 1;
        int id, num_names, num_conn;
        String tempData[];
        ArrayList<String> names;
        RelationshipNode tempNode;
        for(int i = 0; i < num_nodes; i++) {
            names = new ArrayList<String>();
            tempData = splitTokens(lines[curr_line], ",");
            curr_line++;
            id = Integer.parseInt(trim(tempData[0]));
            num_names = Integer.parseInt(trim(tempData[1]));
            num_conn = Integer.parseInt(trim(tempData[2]));
            for (int j = 0; j < num_names; ++j) {
                names.add(trim(lines[curr_line]));
                curr_line++;
            }  
            tempNode = new RelationshipNode(id, names);
            for (int j = 0; j < num_conn; ++j) {
                tempData = splitTokens(lines[curr_line], ",");
                curr_line++;
                tempNode.setLink(trim(tempData[0]), trim(tempData[1]), Integer.parseInt(trim(tempData[2])));
            }
            nodes.add(tempNode);
        }
        String name1, name2;
        int node1, node2;
        Connection tempConn;
        for (; curr_line < lines.length; ++curr_line) {
            tempData = splitTokens(lines[curr_line], ",");
            name1 = trim(tempData[0]);
            node1 = Integer.parseInt(trim(tempData[1]));
            name2 = trim(tempData[2]);
            node2 = Integer.parseInt(trim(tempData[3]));
            tempConn = new Connection(name1, node1, name2, node2);
            connections.add(tempConn);
        }
    }
}
