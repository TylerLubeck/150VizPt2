import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

class Node implements Comparable {
  
  Node parent;
  ArrayList<Node> children;
  int level;
  int valueSum;
  String id; /* Unique node identifier (from parsed file) */
  color c; /* The color of the node when drawn on canvas */
  float x, y, w, h;

  Node(String id, int size) {
    this.parent = null;
    this.children = new ArrayList<Node>();
    this.level = 0;
    this.valueSum = size;
    this.id = id; 
    this.c = 0;
  }
  
  void updatePosition(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

 
  /** Gets a list of c.valueSum for c in this.children **/
  ArrayList<Integer> getValueSums() {
    ArrayList<Integer> ret = new ArrayList<Integer>();
    for (int i = 0; i < children.size(); i++)
      ret.add(children.get(i).valueSum);
    return ret;
  }

  /** Gets a list of c.id for c in this.children **/
  ArrayList<String> getIDs() {
    ArrayList<String> ret = new ArrayList<String>();
    for (int i = 0; i < children.size(); i++)
      ret.add(children.get(i).id);
    return ret;
  }

  int updateValueSum() {
    for (int i = 0; i < children.size(); i++) {
      valueSum += children.get(i).updateValueSum();
    }
    return valueSum;
  }

  /** 
   * Pre-condition: updateValueSum() was already called
   **/
  void sortChildren() {
    for (int i = 0; i < children.size(); i++) {
      children.get(i).sortChildren();
    }
    Collections.sort(children);
    //for (int i = 0; i < children.size(); i++) {
    //  print(children.get(i).valueSum,", ");
    //}
    //println();
  }

  void sortChildrenAlphabetical() {
    for (int i = 0; i < children.size(); i++) {
      children.get(i).sortChildrenAlphabetical();
    }
    Collections.sort(children, new Comparator<Node>(){
      public int compare(Node n1, Node n2) {
        return n1.id.compareTo(n2.id);
      }
    });
  }

  Node(String id) { this(id,0); }

  /* Override equals() to allow for comparison with ID */
  @Override
  public boolean equals(Object obj) {
    //System.out.println("equals: "+obj+","+this);
    return ((obj instanceof Node) && (((Node)obj).id.equals(this.id)));
  }

  public int compareTo(Object e2) {
    return ((Node)e2).valueSum - this.valueSum;
  }

  // Code taken from:
  // https://stackoverflow.com/questions/4965335/how-to-print-binary-tree-diagram
  // This is debugging code, thus the copy-and-paste laziness
  private void printMe() { printMe("", true); }
  private void printMe(String prefix, boolean isTail) {
        println(prefix + (isTail ? "'-- " : "|-- ") + id + " (",valueSum,")");
    for (int i = 0; i < children.size() - 1; i++) {
      children.get(i).printMe(prefix + (isTail ? "    " : "|   "), false);
    }   
    if (children.size() > 0) {
      children.get(children.size() - 1).printMe(prefix + (isTail ?"    " : "|   "), true);
    }   
  }
}
