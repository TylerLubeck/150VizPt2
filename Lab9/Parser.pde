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
        ArrayList<RelationshipNode> nodes;
        String lines[] = loadStrings(filename);
        int num_nodes = Integer.parseInt(lines[0]);
        int curr_line = 1;

        for(int i = 0; i < num_nodes; i++) {
              
        }
    }
}
