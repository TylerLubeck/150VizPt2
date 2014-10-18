import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Stack; 
import java.util.Comparator; 
import java.util.Collections; 
import java.util.Map; 
import java.util.Set; 
import java.util.HashSet; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class A1 extends PApplet {


int cHeight;
int cWidth; 
int short_side; 
Sides currentSide;
Canvas mainCanvas;
Node root; 
Stack<Node> rootStack;
Node currentRoot;
public void setup() {
  size(400, 500); 
  /* TODO:
   * In order to zoom out properly, consider doing this:
   * When left click, record the ID of the element clicked on.
   * When right click, if there is an ID recorded, just draw that one
  */
  frame.setResizable(true);  
  Parser p = new Parser("hierarchy2.shf"); 
  root = p.parse();
  currentRoot = root;
  rootStack = new Stack<Node>();
}

public void squarify(Node x, Canvas c){
  if(x.children == null){
      return;
    }else{
    float va_ratio = c.mWidth * c.mHeight / x.getValue();
    
    for(int i=0; i<x.children.size(); i++){
      c.addSquare(x.children.get(i), va_ratio);
    }
    c.render();
    for(int i=0; i<x.children.size(); i++){
      Rectangle childRect = c.getRectByID(x.children.get(i).getID());
      Canvas childCanvas = new Canvas(childRect);
      squarify(x.children.get(i),childCanvas);
      childCanvas.render();
    }
  }
}

public int getSelectedId(float x, float y) {
  for (Row r : mainCanvas.rows) {
    for (Rectangle re : r.rects) {
      if (re.isWithin(x, y)) {
        return re.getID();
      }
    }
  }
  return -1;
}

public void draw() {
  mainCanvas = new Canvas(0,0,width,height);
  squarify(currentRoot, mainCanvas);
}

public void zoomIn(float x, float y){
  int id = getSelectedId(x, y);
  if (id == -1) {
    return;
  }
  Node n = root.getNodeById(id);
  if (n == null) {
    return;
  }
  rootStack.push(currentRoot);
  currentRoot = n;
}

public void zoomOut(){
  if(!rootStack.empty()) {
      currentRoot = rootStack.pop();
  }
}

public void mouseClicked() {
  if (mouseButton == LEFT) {
    zoomIn(mouseX, mouseY);
  } else if(mouseButton == RIGHT) {
    zoomOut();
  }
}
class Canvas{
  private float posX, posY, mWidth, mHeight;
  //rs is for remaining space dimensions
  private float rs_posX, rs_posY, rs_mWidth, rs_mHeight;
  private Sides fixedSide;
  private float fixedLength;
  private ArrayList<Row> rows;

  
  Canvas(float posX, float posY, float w, float h){
    this.posX = posX;
    this.posY = posY;
    this.mWidth = w;
    this.mHeight = h;
    //The remaining space is equal to the current canvas space
    this.rs_posX = this.posX;
    this.rs_posY = this.posY;
    this.rs_mWidth = this.mWidth;
    this.rs_mHeight = this.mHeight;
    this.rows = new ArrayList(0);
    calculateShorterSide();
  }
  
  Canvas(Rectangle rect){
    this(rect.posX+5,rect.posY+5,rect.mWidth-5,rect.mHeight-5);
  }
  
  public void Print(){
  }
  
  public void calculateShorterSide(){
    if(this.rs_mWidth < this.rs_mHeight){
      this.fixedSide = Sides.WIDTH;
      this.fixedLength = this.rs_mWidth;
    } else{
      this.fixedSide = Sides.HEIGHT;
      this.fixedLength = this.rs_mHeight;
    }
  }
  
  public void rsChangedByNewRow(){
    int numRows = this.rows.size();
    Row row = this.rows.get(numRows-1);
    //CASTING EVERYTHING TO INT, BE WEARY
    if(row.fixedSide == Sides.HEIGHT){
      this.rs_posX = row.posX + row.mWidth;
      this.rs_mWidth -= row.mWidth;
    } else{
      this.rs_posY = row.posY + row.mHeight;
      this.rs_mHeight -= row.mHeight;
    }
    calculateShorterSide();
  }
  
  public void rsChangedByCurrentRow(Sides s, float oW, float oH){
    int numRows = this.rows.size();
    Row row = this.rows.get(numRows-1);
    //CASTING EVERYTHING TO INT, BE WEARY
    if(row.fixedSide == Sides.HEIGHT){
      this.rs_posX = row.posX + row.mWidth; 
      this.rs_mWidth = this.rs_mWidth + oW - row.mWidth;
    } else{
      this.rs_posY = row.posY + row.mHeight;
      this.rs_mHeight = this.rs_mHeight + oH - row.mHeight;
    }
    calculateShorterSide();
  }
  
  public void render(){
    for (Row row : this.rows){
      row.render();
    } 
  }
  
  //Adds a Node by adjusting the current configuration to obtain the best aspect ratio
  public void addSquare(Node square, float va_ratio){
    //if no rows, add a row 
    if(this.rows.size() == 0){
      Row firstRow = new Row(square,this.rs_posX, this.rs_posY,
                             this.fixedLength, this.fixedSide,va_ratio);
      this.rows.add(firstRow);
      this.rsChangedByNewRow();
    } else{
      //attempt adding a node to the last row
      int size = this.rows.size();
      Row copyRow = this.rows.get(size-1);
      Sides oldRowSide = copyRow.fixedSide;
      float oldRowWidth = copyRow.mWidth;
      float oldRowHeight = copyRow.mHeight;
      boolean rowStretched = this.rows.get(size-1).addRect(square);
      if(!rowStretched){
        Row newRow = new Row(square, this.rs_posX, this.rs_posY,
                             this.fixedLength, this.fixedSide,va_ratio);
        this.rows.add(newRow);
        this.rsChangedByNewRow();
      } else{
        this.rsChangedByCurrentRow(oldRowSide,oldRowWidth,oldRowHeight);
      }
    }
  }
  
  public Rectangle getRectByID(int ID){
    for(Row row : this.rows){
      for(Rectangle rect : row.rects){
        if(rect.getID() == ID){
          return rect;
        }
      }
    }
    return null;
  }
  
}
 


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
  public boolean isLeaf() {
    return this.children == null; 
  }
  
  public void addChild(Node child) {
    if (this.children == null) {
      this.children = new ArrayList<Node>(); 
    }
    this.children.add(child);
  }
  
  public void sumTheChildren() {
    this.val = sumTheChildrenHelper();
  }
  
  public int sumTheChildrenHelper() {
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
  public boolean supportsZoom() {
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
  
  public boolean isWithin(int x, int y) {
    //This is for drawing
    return false; 
  }
  
  public int getValue() {
    return this.val; 
  }
  
  public int getID() {
    return this.ID; 
  }
  
  public ArrayList<Node> getChildren() {
    return this.children; 
  }
  
  
  public void sortTree() {
    if (this.isLeaf()) {
      return; 
    }
    this.sortChildren();  
    for (Node child : this.children) {
      child.sortTree(); 
    }
  }
  
  public void sortChildren() {
    Collections.sort(this.children, new Comparator<Node>() {
        @Override
        public int compare(Node x, Node y) {
          return (x.getValue() > y.getValue() ? -1 : (x.getValue() == y.getValue() ? 0 : 1)); 
        }
    }); 
  } 
  
  public Node getNodeById(int id) {
    if (this.children != null) {
      for (Node child : this.children) {
        if (child.ID == id) {
          return child; 
        }  
        child.getNodeById(id);   
      }
    }
   return null;  
  }

  /* for debugging, delete before turning in.  */   
 public void printTree() {
    println("Node Id: " + this.ID + "\nNode Value: " + this.val);  
    if (this.isLeaf()) {
      return;
    }
    for(Node child : this.children) {  
      child.printTree(); 
    }
  }
}




class Parser {
  private String fileName;  //Stores the file name, just in case.
  private String[] lines;   //Stores all of the lines in the input file
  private int numLeaves;    //Stores the count of leaves in the input file
  private int numRelations; //Stores the count of relations in the input file
  private HashMap<Integer, Integer> idToValMap; //Stores a map of (leaf id) -> (leaf value).
  private HashMap<Integer, ArrayList<Integer>> parentToChildMap; //Stores a map of (parent leaf id) -> (child leaf value)
  private int rootNodeID;
  private Node rootNode;

  Parser(String fileName) {
    this.fileName = fileName;
    //Read the lines from the file
    this.lines = loadStrings(this.fileName);

    //Create the blank HashMaps
    this.idToValMap = new HashMap<Integer, Integer>();
    this.parentToChildMap = new HashMap<Integer, ArrayList<Integer>>();
    this.rootNode = null;

    //The format spec tells us where in the file to find these values. Grab them and store them.
    this.numLeaves = Integer.parseInt(this.lines[0]);
    this.numRelations = Integer.parseInt(this.lines[this.numLeaves + 1]);

    //Using the information gathered, parse for leaves and relations
    this.parseLeaves();
    this.parseRelations();
  }

  // Goes through the input file and grabs the (id, value) tuples.
  // Puts them in the (leaf id) -> (leaf value) HashMap
  public void parseLeaves() {
    String line = "";
    String[] parts = {};
    int val = 0;
    for (int i=1; i <= (this.numLeaves); i++) {
      line = this.lines[i];
      parts = split(line, ' ');
      val += PApplet.parseInt(parts[1]);
      this.idToValMap.put(PApplet.parseInt(parts[0]), PApplet.parseInt(parts[1]));
    }
    
  }

  // Goes through the input file and grabs the (parent id, child id) tuples.
  // Puts them in the (parent leaf id) -> (child leaf id) HashMap
  public void parseRelations() {
    
    int startIndex = this.numLeaves + 2;
    int endIndex = startIndex + this.numRelations;
    Set<Integer> rootSet = new HashSet<Integer>();
    Set<Integer> childSet = new HashSet<Integer>();
    String line = "";
    String[] parts = {};
    ArrayList<Integer> childRelations = null;
    for (int i = startIndex; i < endIndex; i ++) {
      line = this.lines[i];
      parts = split(line, ' ');
      rootSet.add(PApplet.parseInt(parts[0]));
      childSet.add(PApplet.parseInt(parts[1]));
      childRelations = this.parentToChildMap.get(PApplet.parseInt(parts[0]));
      if ( childRelations == null) {
        childRelations = new ArrayList<Integer>();
      }
      childRelations.add(PApplet.parseInt(parts[1]));
      this.parentToChildMap.put(PApplet.parseInt(parts[0]), childRelations);
    }
    
    
    this.rootNodeID = rootSet.toArray(new Integer[rootSet.size()])[0];
  }

  public int getNumberOfRelations() {
    return this.numRelations;
  }

  public int getNumberOfLeaves() {
    return this.numLeaves;
  }

  public HashMap<Integer, Integer> getLeavesMap() {
    return this.idToValMap;
  }

  public HashMap<Integer, ArrayList<Integer>> getRelationsMap() {
    return this.parentToChildMap;
  }

  public String getFileName() {
    return this.fileName;
  }

  public Node parse() {
    if (this.rootNode != null) {
      return this.rootNode;
    }
    
    this.rootNode = buildRoot(this.rootNodeID);
    rootNode.sortTree();  
    return this.rootNode;
  }
  
  public Node buildRoot(int ID) {
    ArrayList<Integer> children = this.parentToChildMap.get(ID);
    if (children == null) {
      int val = this.idToValMap.get(ID);
      return new Node(ID, val);
    }
    
    Node thisBranch = new Node(ID); //TODO: Add Parent info
    
    for (int childID : children) {
      thisBranch.addChild(buildRoot(childID)); 
    }
    
    thisBranch.sumTheChildren();
    return thisBranch;
  }
  

}

class Rectangle{
  private float posX, posY;
  private float mHeight, mWidth;
  private int iD;
  
  Rectangle( float posX, float posY, float w, float h, int iD ){
    this.posX = posX;
    this.posY = posY;
    this.mHeight = h;
    this.mWidth = w;
    this.iD = iD;     
  }
  
  public boolean isWithin(float x, float y) {
    return x > this.posX && x < this.posX + this.mWidth
        && y > this.posY && y < this.posY + this.mHeight;
  }

  public void render(){
    if(mouseX > this.posX && mouseX < this.posX + this.mWidth
        && mouseY > this.posY && mouseY < this.posY + this.mHeight) {
      fill(112, 128, 144);
    } else {
      fill(255);
    }
    stroke(0); 
    strokeWeight(4);  
    rect(this.posX, this.posY, this.mWidth, this.mHeight);
    fill(255, 0, 0); 
    textSize(10); //<-- Need to calculate in a smart way 
    textAlign(CENTER, CENTER);
    text(Integer.toString(this.iD), this.posX, this.posY, this.mWidth, this.mHeight);
    //textWidth(CENTER,CENTER); 
  }
  
  public float getArea() {
    return this.mWidth * this.mHeight; 
  }
  
  public int getID() {
    return this.iD; 
  }
  
  public float getWidth() {
    return this.mWidth; 
  }
  
  public float getAspectRatio() {
    return max(this.mWidth/this.mHeight, this.mHeight/this.mWidth); 
  }
  
  public float getHeight() {
    return this.mHeight; 
  }
  
  public float getPosX() {
    return this.posX; 
  }
  
  public float getPosY() {
    return this.posY; 
  }
  public void setHeight(float h) {
    this.mHeight = h;
  }
  
  public void setWidth(float w) {
    this.mWidth = w;
  }
  
  public void setPosX(float x) {
    this.posX = x;
  }
  
  public void setPosY(float y) {
    this.posY = y; 
  }


}
class Row {
  private float posX, posY;
  private float mHeight, mWidth; 
  private ArrayList<Rectangle> rects; 
  private float VA_Ratio; 
  private Sides fixedSide; 
  private float short_side; 
  
  Row(Node n, float x, float y, float short_side, Sides side, float va_ratio) {
    this.short_side = short_side; 
    this.fixedSide = side;
    this.VA_Ratio = va_ratio; 
    this.posX = x;
    this.posY = y; 
    addFirstRect(n);
  }
  
  public void addFirstRect(Node n) {
    float area = (float)n.getValue() * this.VA_Ratio;
    float h, w;  
    if (this.fixedSide == Sides.HEIGHT) { 
      h = this.short_side;
      w = area/h; 
    } else {
      w = this.short_side;
      h = area/w; 
    }
    
    this.mHeight = h;
    this.mWidth = w; 
    
    this.rects = new ArrayList<Rectangle>();
    Rectangle rect = new Rectangle(this.posX, this.posY, w, h, n.getID());
    this.rects.add(rect);
    n.rect = rect;
  }
  /* Adds a rectangle if the aspect ratio is optimum. Otherwise, returns false; */ 
  public boolean addRect(Node node) {
    float area = (float)node.getValue() * this.VA_Ratio;
    return resizeRects(area, node); 
  }
  
  /* given a new rectangle, attempt to fit the rectangle on the given row. 
  returns false if the aspect ratio is not optimum */ 
  public boolean resizeRects(float nodeArea, Node node) {
    float h, w; 
    float totalArea = (float)this.sumAreas() + nodeArea; 
    float new_side = totalArea / this.short_side;
    
    if (this.fixedSide == Sides.HEIGHT) { 
        h = (node.getValue() * this.VA_Ratio) / new_side; 
        w = new_side; 
    } else {
        w = (node.getValue() * this.VA_Ratio) / new_side;  
        h = new_side;
    }
    
    float asp_ratio = max(h/w, w/h); 
    if(asp_ratio < this.rects.get(this.rects.size() - 1).getAspectRatio()) {
      Rectangle rect = new Rectangle(0, 0, w, h, node.getID());
      this.rects.add(rect); // FIX THIS ID IS NOT CORRECT
      node.rect = rect;
      ArrayList<Rectangle> resizedRects = new ArrayList<Rectangle>(); 
      Rectangle first = this.rects.get(0);
           
      if (this.fixedSide == Sides.HEIGHT) {
        first.setHeight(first.getArea() / new_side); 
        first.setWidth(new_side); 
        first.setPosX(this.posX); 
        first.setPosY(this.posY);    
      } else {
        first.setWidth(first.getArea() / new_side); 
        first.setHeight(new_side); 
        first.setPosY(this.posY); 
        first.setPosX(this.posX); 
      }
      resizedRects.add(first); 
    
      float x, y;  
      for (int i = 1; i < this.rects.size(); i++) {
        if (this.fixedSide == Sides.HEIGHT) {
          h = rects.get(i).getArea() / new_side;
          w = new_side;
          y = resizedRects.get(i - 1).getPosY() + rects.get(i - 1).getHeight();
          x = this.posX; 
          this.mWidth = w;
          this.mHeight = h;
          this.posY = (int)y; 
        } else {
          w = rects.get(i).getArea() / new_side;
          h = new_side;
          x = resizedRects.get(i - 1).getPosX() + rects.get(i - 1).getWidth();
          y = this.posY; 
          this.mWidth = w;
          this.mHeight = h;
          this.posX = (int)x; 
        }
        resizedRects.add(new Rectangle(x, y, w, h, this.rects.get(i).getID())); 
      }
      this.rects = resizedRects; 
      return true;     
    } 
       
    return false; 
  }
  

  public int sumAreas() {
    int sum = 0; 
    for (Rectangle r : this.rects) {
      sum += r.getArea(); 
    }
    return sum;
  }
  
  public void render() {
    for (Rectangle r : this.rects) {
      r.render(); 
    }
  }
  
  public float getPosX() {
    return this.posX; 
  }
  
  public float getPosY() {
    return this.posY;
  }
  
  public float getArea() {
    return (this.mWidth * this.mHeight);
  }
  
  public Sides getShorterSide() {
    return this.fixedSide; 
  }
  
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "A1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
