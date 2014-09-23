import java.util.Comparator; 
import java.util.Collections;

class Node {
  private int ID;
  private int val;
  private ArrayList<Node> children;
  boolean visited = false;
  private Rectangle rect;
  
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
    for (Node child : this.children) {
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
  
  ArrayList<Node> getChildren() {
    return this.children; 
  }
  
  
  void sortTree() {
    if (this.isLeaf()) {
      return; 
    }
    this.sortChildren();  
    for (Node child : this.children) {
      child.sortTree(); 
    }
  }
  
  void sortChildren() {
    Collections.sort(this.children, new Comparator<Node>() {
        @Override
        public int compare(Node x, Node y) {
          return (x.getValue() > y.getValue() ? -1 : (x.getValue() == y.getValue() ? 0 : 1)); 
        }
    }); 
  } 

  /* for debugging, delete before turning in.  */   
 void printTree() {
    println("Node Id: " + this.ID + "\nNode Value: " + this.val);  
    if (this.isLeaf()) {
      return;
    }
    for(Node child : this.children) {  
      child.printTree(); 
    }
  }
}
