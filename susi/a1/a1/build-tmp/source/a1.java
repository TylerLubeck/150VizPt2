import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.ArrayList; 
import java.util.Collections; 
import java.util.Comparator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class a1 extends PApplet {


String csvSOE = "soe-funding.csv";
//String shfData = "hierarchy.shf";
String shfData = "hierarchy2.shf";
//String shfData = "hierarchy3.shf";
SqTreeMap sqtreemap;
String toolTip = "";

/**
 * Finds nodes with IDs id0 and id1 in the list of nodes, making
 * Node(id1) the child of Node(id0)
 **/
public void linkNodes(String id0, String id1, ArrayList<Node> nodes) {
  
  int i0 = nodes.indexOf(new Node(id0));
  int i1 = nodes.indexOf(new Node(id1));
  if (i0 < 0) {
    nodes.add(new Node(id0));
    i0 = nodes.indexOf(new Node(id0));
  }
  if (i1 < 0) {
    nodes.add(new Node(id1));
    i1 = nodes.indexOf(new Node(id1));
  }
 
  //println(i0,i1);
  /* Find n0 and n1, adding n1 to n0's list of children: */
  Node n0 = nodes.get(i0);
  Node n1 = nodes.get(i1);
  n0.children.add(n1);
  n1.parent = n0;

}

/** Recursively determines the root node of a tree */
public Node findRoot(Node n) {
  if (n.parent == null)
    return n;
  return findRoot(n.parent);
}

/**
 * Parses the given SHF file, populating a SqTreeMap object and
 * storing it in the sqtreemap global variable
 **/
public void parseSHF(String fn) {
    
  /* Loop variables */
  String tmp[];
  int size;
  String id0,id1;
  String id;

  String data[] = loadStrings(fn);
  int num_nodes = Integer.parseInt(trim(data[0]));
  int num_rltns = Integer.parseInt(trim(data[num_nodes+1]));
  ArrayList<Node> nodes = new ArrayList<Node>();
  
  /* Create leaf nodes from SHF */
  for (int i = 1; i <= num_nodes; i++) {
    tmp = splitTokens(data[i]);
    //println(tmp);
    id = trim(tmp[0]);
    size = Integer.parseInt(trim(tmp[1]));
    nodes.add(new Node(id,size));
  }

  /* Add parent-child relationships to nodes */
  for (int i = num_nodes + 2; i < num_nodes + 2 + num_rltns; i++) {
    tmp = splitTokens(data[i]);
    id0 = trim(tmp[0]);
    id1 = trim(tmp[1]);
    linkNodes(id0,id1,nodes);
    //println(id0,",",id1);
  }

  sqtreemap = new SqTreeMap(findRoot(nodes.get(0)));
  sqtreemap.root.updateValueSum();
  sqtreemap.root.sortChildren();

}

/**
 * Zooms in / out on the cell which was clicked.
 *   left click == zoom in
 *   right click == zoom out
 **/
public void mouseClicked() {
  if (mouseButton  == LEFT)
    sqtreemap.zoomIn();
  else if (mouseButton == RIGHT && sqtreemap.curr_root.parent != null)
    sqtreemap.curr_root = sqtreemap.curr_root.parent;
}

public void setup() {
  parseSHF(shfData);
  size(600,400);
  frame.setResizable(true);
}

public void draw() {
  background(255,255,255);
  if (width > 50 && height > 50)
    sqtreemap.draw(0,0,width,height);
}





class Node implements Comparable {
  
  Node parent;
  ArrayList<Node> children;
  int level;
  int valueSum;
  String id; /* Unique node identifier (from parsed file) */
  int c; /* The color of the node when drawn on canvas */
  float x, y, w, h;

  Node(String id, int size) {
    this.parent = null;
    this.children = new ArrayList<Node>();
    this.level = 0;
    this.valueSum = size;
    this.id = id; 
    this.c = 0;
  }
  
  public void updatePosition(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

 
  /** Gets a list of c.valueSum for c in this.children **/
  public ArrayList<Integer> getValueSums() {
    ArrayList<Integer> ret = new ArrayList<Integer>();
    for (int i = 0; i < children.size(); i++)
      ret.add(children.get(i).valueSum);
    return ret;
  }

  /** Gets a list of c.id for c in this.children **/
  public ArrayList<String> getIDs() {
    ArrayList<String> ret = new ArrayList<String>();
    for (int i = 0; i < children.size(); i++)
      ret.add(children.get(i).id);
    return ret;
  }

  public int updateValueSum() {
    for (int i = 0; i < children.size(); i++) {
      valueSum += children.get(i).updateValueSum();
    }
    return valueSum;
  }

  /** 
   * Pre-condition: updateValueSum() was already called
   **/
  public void sortChildren() {
    for (int i = 0; i < children.size(); i++) {
      children.get(i).sortChildren();
    }
    Collections.sort(children);
    //for (int i = 0; i < children.size(); i++) {
    //  print(children.get(i).valueSum,", ");
    //}
    //println();
  }

  public void sortChildrenAlphabetical() {
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

class Canvas {
  float x0, y0; // Upper-left corner of canvas
  float w, h; // Width and height of canvas
  float VA_ratio; // (total_value / canvas_area)
  Canvas(float x0, float y0, float w, float h) {
    this.x0 = x0;
    this.y0 = y0;
    this.w = w;
    this.h = h;
  }

  public Canvas clone() {
    Canvas c = new Canvas(x0,y0,w,h);
    c.VA_ratio = VA_ratio;
    return c;
  }

}

class TreeMap {

  Node root;

  TreeMap() {
    this.root = null;
  }

  public void printMe() {
    this.root.printMe();
  }

}

class SqTreeMap extends TreeMap implements Cloneable,Drawable {
  int[] colors = {
    //color(100, 100, 200), color(0, 255, 0), color(255, 0, 0), color(0, 255, 255), color(255, 0, 255)};
    color(0, 0, 255), color(0, 255, 0), color(255, 0, 0), color(0, 255, 255), color(255, 0, 255)};
  int highlight = color(255, 255, 0);

  /* Location of the SqTreeMap on the main canvas */
  //  Canvas canvas;
  Node curr_root; // zoom-level root

  /* Squarified TreeMap subdivision algorithm goes here */
  public void draw(float x0, float y0, float w, float h) {
    Canvas canvas = new Canvas(x0, y0, w, h);
    canvas.VA_ratio = (canvas.w * canvas.h) / this.curr_root.valueSum ;
    if (curr_root.children.size() != 0)
      rec_draw((ArrayList<Node>)(curr_root.children).clone(), canvas, this.curr_root.valueSum);
    else {
      ArrayList temp = new ArrayList();
      temp.add(curr_root);
      drawRow(temp, canvas, true, this.curr_root.valueSum, w);
    }
  }

  public void rec_draw(ArrayList<Node> children, Canvas c, float area) {
    
    int cIndex = 0; 
    ArrayList<Node> row = new ArrayList<Node>();
    boolean rowVertical = (c.h < c.w);
    float rowLength = c.h < c.w ? c.h : c.w;
    float rowArea = 0, rowWidth = 0;
    float currentRatio = 0;
    float tempRatio;
    for (int i = 0; i < children.size (); i++) {
      if (children.get(i).c == 0) {
        children.get(i).c = colors[cIndex];
        cIndex = ++cIndex%colors.length;
      }
    }
    while (children.size () > 0) {
      row.add(children.get(0));
      tempRatio = worstRatio(row, (rowArea + children.get(0).valueSum * c.VA_ratio) / rowLength, c.VA_ratio);
      if (tempRatio >= currentRatio) {
        rowArea += children.get(0).valueSum * c.VA_ratio;
        rowWidth = rowArea / rowLength;
        children.remove(0);
        currentRatio = tempRatio;
      } else {
        row.remove(children.get(0));
        break;
      }
    } 
    drawRow(row, c, rowVertical, rowArea, rowWidth);
    if (! children.isEmpty()) {
      Canvas newC;
      if (rowVertical) {
        newC = new Canvas((c.x0 + rowWidth), c.y0, (c.w - rowWidth), c.h);
      } else {
        newC = new Canvas(c.x0, (c.y0 + rowWidth), c.w, (c.h - rowWidth));
      }
      newC.VA_ratio = (newC.w * newC.h) / (area - rowArea/c.VA_ratio);
      //println("Recursing on non-empty children...:");
      //children.get(0).printMe();
      //if (!(children.size() == 1 && children.get(0).children.size() == 1 && children.get(0) == children.get(0).children.get(0))) {
      rec_draw((ArrayList<Node>)children, newC, (area - rowArea/c.VA_ratio));
      //}
    }
    Canvas tempC;
    float tempArea = 0;
    for (int i= 0; i < row.size (); i++) {
      if (row.get(i).children.size() != 0) {
        if (rowVertical) {
          tempC = new Canvas(c.x0 + 3, c.y0 + (tempArea / rowWidth) + 3, rowWidth - 6, row.get(i).valueSum * c.VA_ratio / rowWidth -6);
        } else {
          tempC = new Canvas(c.x0 + (tempArea / rowWidth) + 3, c.y0 + 3, row.get(i).valueSum * c.VA_ratio / rowWidth -6, rowWidth-6);
        }

        tempC.VA_ratio = (tempC.w * tempC.h) / row.get(i).valueSum;
        ArrayList<Node> childrenclone = (ArrayList<Node>)row.get(i).children.clone();
        //println("Recursing on row.get(i).children.clone():",childrenclone);
        rec_draw(childrenclone, tempC, row.get(i).valueSum);
      }
      tempArea += row.get(i).valueSum * c.VA_ratio;
    }
  }
  
  public void framerect(float x, float y, float w, float h) {
    float f = 0.000f*width;
    rect(x + f, y + f, w - 2*f, h - 2*f);
  } 

  public void drawRow(ArrayList<Node> row, Canvas c, boolean rowVertical, float rowArea, float rowWidth) {
    float tempArea = 0;
    for (int i = 0; i < row.size (); i++) {
      if (row.get(i).children.size() == 0) {
        textAlign(CENTER, CENTER);
        textSize(15);
        if (rowVertical) {
          fill((intersect(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).valueSum * c.VA_ratio/ rowWidth)))? highlight : row.get(i).c); 
          framerect(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).valueSum * c.VA_ratio/ rowWidth));
          row.get(i).updatePosition(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).valueSum * c.VA_ratio/ rowWidth));
          fill(0);
          text(row.get(i).id, (c.x0 + rowWidth/2), c.y0 + tempArea / rowWidth + (row.get(i).valueSum * c.VA_ratio/ rowWidth)/2);
        } else {
          fill((intersect((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).valueSum * c.VA_ratio / rowWidth), rowWidth))? highlight : row.get(i).c);
          framerect((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).valueSum * c.VA_ratio / rowWidth), rowWidth);
          row.get(i).updatePosition((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).valueSum * c.VA_ratio / rowWidth), rowWidth);
          fill(0);
          text(row.get(i).id, (c.x0 + tempArea / rowWidth) + ((row.get(i).valueSum * c.VA_ratio / rowWidth) / 2), c.y0 + rowWidth/2);
        } 
      }
      else {
        strokeWeight(2);
        fill(255);
        if (rowVertical) {
          framerect(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).valueSum * c.VA_ratio/ rowWidth));
          row.get(i).updatePosition(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).valueSum * c.VA_ratio/ rowWidth));
        }
        else {
          framerect((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).valueSum * c.VA_ratio / rowWidth), rowWidth);
          row.get(i).updatePosition((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).valueSum * c.VA_ratio / rowWidth), rowWidth);
        }
        strokeWeight(1);
      }
      tempArea += row.get(i).valueSum * c.VA_ratio;
    }
  }
  
  public boolean intersect(float x0, float y0, float w, float h) {
    return (mouseX >= x0 && mouseX <= (x0 + w) && mouseY >= y0 && mouseY <= (y0 +h));
  }

  public float worstRatio(ArrayList<Node> row, float rowLength, float ratio) {
    float currentRatio = min((row.get(0).valueSum * ratio / rowLength), rowLength) / 
    max((row.get(0).valueSum * ratio / rowLength), rowLength);
    float tempRatio;
    for (int i=1; i < row.size (); i++) {
      tempRatio = min((row.get(i).valueSum *ratio/ rowLength), rowLength) / 
      max((row.get(i).valueSum*ratio / rowLength), rowLength); 
      if (tempRatio < currentRatio) {
        currentRatio = tempRatio;
      }
    }
    return abs(currentRatio);
  }

  /**
   * Finds the node in this.root.children which contains the point (mouseX,mouseY)
   **/
  public boolean zoomIn() {
    for (int i = 0; i< curr_root.children.size(); ++i) {
       if(intersect(curr_root.children.get(i).x, curr_root.children.get(i).y, curr_root.children.get(i).w, curr_root.children.get(i).h)) {
         curr_root = curr_root.children.get(i);
         return true;
       }
    }
    return false;
  }

  SqTreeMap(Node root) {
    this.root = root;
    this.curr_root = root;
  }
}


public interface Drawable {
  public void draw(float x0, float y0, float w, float h);
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "a1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
