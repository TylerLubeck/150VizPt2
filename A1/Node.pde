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

  /* This just means that there is more than one level below this
   * node. So, does this node's children have children?
   */
  boolean supportsZoom() {
    if (this.isLeaf()) {
     return false; 
    }
    boolean childrenHaveChildren = false;
    for (Node child : self.children) {
      if (! child.isLeaf()) {
        childrenHaveChildren = true;
      } 
    }
    return childrenHaveChildren;
  }
  
  boolean isWithin(int x, int y) {
    //This is for drawing
    return false; 
  }
  
  int getValue() {
    return this.val; 
  }
  
  int getID() {
    return this.ID; 
  }
}
