class Connection {
    String name1, name2;
    int rNode1, rNode2;
    
    Connection(String _name1, int _rNode1, String _name2, int _rNode2) {
        this.name1 = _name1;
        this.rNode1 = _rNode1;
        this.name2 = _name2;
        this.rNode2 = _rNode2;
    }
    
    void print() {
      println(name1 + " " + rNode1 + " " + name2 + " " + rNode2);
    }
}
