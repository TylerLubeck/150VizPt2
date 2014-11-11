class RelationshipNode {
    ArrayList<String> names;
    int [][] links; 
    int id;
    float centerX, centerY;
    
    RelationshipNode(int _id, ArrayList<String> _names) {
         this.id = _id;
         this.names = _names;
         println(names);
//         Collections.sort(this.names);
         links = new int[this.names.size()][this.names.size()];
    }
    
    void setLink(String name1, String name2, int strength) {
         links[names.indexOf(name1)][names.indexOf(name2)] = strength;
         links[names.indexOf(name2)][names.indexOf(name1)] = strength;
    }
    
    void print() {
         println(id);
         for (String name : this.names) 
           println(name);
         println(links);
    }
}
