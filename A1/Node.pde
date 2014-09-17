class Node {
  private int ID;
  private int val;
  private ArrayList<Node> children;
  
  Node() {
    this(-1, -1);
  }
  
  Node(int ID) {
    this(ID, -1); 
  }
  
  Node(int ID, int val) {
    this.ID = ID;
    this.val = val;
    this.children = null;
  }
  
  
  
  //TODO: Literally all of these.
  //TODO: Don't forget this. Very important.
  boolean isLeaf() {
    return this.children == null; 
  }
  
  void addChild(Node child) {
    if (this.children == null) {
      this.children = new ArrayList<Node>(); 
    }
    this.children.add(child);
  }
  
  void sumTheChildren() {
    this.val = sumTheChildrenHelper();
  }
  
  int sumTheChildrenHelper() {
    int sum = 0;
    for(Node child : this.children) {
       if (child.isLeaf() ) {
         sum += child.getValue();
       } else {
         sum += child.sumTheChildrenHelper();
       }
    }
    return sum;
  }
  
  boolean isParentOf(int childID) {
    return false; 
  }
  
  boolean supportsZoom() {
    return false; 
  }
  
  boolean isWithin(int x, int y) {
    return false; 
  }
  
  int getRootId(int childId) {
    return -1; 
  }
  
  int getValue() {
    return this.val; 
  }
  
  int getID() {
    return this.ID; 
  }
}
