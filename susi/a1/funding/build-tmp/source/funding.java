import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.ArrayList; 
import java.util.Collections; 
import java.util.Comparator; 
import java.util.Collections; 
import java.util.Collections; 
import java.util.Collections; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class funding extends PApplet {


String csvSOE = "soe-funding.csv";
SqTreeMap[] tmaps = new SqTreeMap[6]; // The 6 possible tree maps to display
BarGraph[] bgraphs = new BarGraph[6]; // The 6 possible bar braphs to display
String[] cats = new String[3];    // The 3 sortable category titles
String toolTip;
int WHICH_BGRAPH = 5; // Which bar braph to display currently

public Node getNextNode(Node r, String c) {
  Node newNode = new Node(c,0);
  int index = r.children.indexOf(newNode);
  if (index < 0) {
    r.children.add(newNode);
    newNode.parent = r;
    index = r.children.indexOf(newNode);
  }
  return r.children.get(index);
}

/**
 * 
 * c1 := sort by this category first
 * c2 := sort by this category second
 * c3 := sort by this category third
 **/
public void insertNode(String c1, String c2, String c3, int value, TreeMap t, int i) {
  Node r = t.root;
  r = getNextNode(r,c1);
  r = getNextNode(r,c2);
  r = getNextNode(r,c3);
  String name = Integer.toString(i); //"#"+Integer.toString(r.children.size());
  Node temp = new Node(name, value);
  temp.parent = r;
  r.children.add(temp);
}

/**
 * Parses the given CSV file, populating a SqTreeMap object
 * for each of the (six) possible orderings of the variables.
 **/
public void parseCSV(String fn) {
  
  String data[] = loadStrings(fn);
  int num_leaf = data.length - 1;
  
  String tmp[] = splitTokens(data[0],",");
  cats[0] = tmp[0]; cats[1] = tmp[1]; cats[2] = tmp[2];

  for (int i = 0; i < 6; i++) {
    tmaps[i] = new SqTreeMap(new Node("root",0));
  }

  int v;
  String d[];
  for (int i = 1; i < num_leaf; i++) {
    d = splitTokens(data[i],",");
    v = Integer.parseInt(d[3]);
    insertNode(d[0], d[1], d[2], v, tmaps[0], i);
    insertNode(d[0], d[2], d[1], v, tmaps[1], i);
    insertNode(d[1], d[0], d[2], v, tmaps[2], i);
    insertNode(d[1], d[2], d[0], v, tmaps[3], i);
    insertNode(d[2], d[0], d[1], v, tmaps[4], i);
    insertNode(d[2], d[1], d[0], v, tmaps[5], i);
  }

  for (int i = 0; i < 6; i++) {
    tmaps[i].root.updateValueSum();
    tmaps[i].root.sortChildrenAlphabetical();
    
    ArrayList<String> xData = tmaps[i].root.getIDs();
    ArrayList<Integer> yData = tmaps[i].root.getValueSums();
    bgraphs[i] = new BarGraph(xData, yData);
    bgraphs[i].items = new ArrayList<Drawable>();
    for (int j = 0; j < tmaps[i].root.children.size(); j++) {
      bgraphs[i].items.add((Drawable)new SqTreeMap(tmaps[i].root.children.get(j)));
    }
    
    tmaps[i].root.sortChildren();
  }

}

//float golden_ratio = 1.61803398875;

public void setup() {
  parseCSV(csvSOE);
  size(1200,800); //ceil(1200*golden_ratio));
  frame.setResizable(true);

  ArrayList categories = new ArrayList<String>();
  categories.add(cats[0]);
  categories.add(cats[1]);
  categories.add(cats[2]);
  categories.add("Total");

  switchButton = new SwitchButton(categories, 100.00f, 100.00f);

//  tmaps[2].printMe();
}

public void draw() {
  //tmaps[2].draw(0,0,width,height);
  toolTip = "";
  background(255,255,255);
  //println(WHICH_BGRAPH);
  if (switchButton.buttonOrder.get(0) == cats[0] && switchButton.buttonOrder.get(1) == cats[1] && switchButton.buttonOrder.get(2) == cats[2])
    WHICH_BGRAPH = 0;
  if (switchButton.buttonOrder.get(0) == cats[0] && switchButton.buttonOrder.get(2) == cats[1] && switchButton.buttonOrder.get(1) == cats[2])
    WHICH_BGRAPH = 1;
  if (switchButton.buttonOrder.get(1) == cats[0] && switchButton.buttonOrder.get(0) == cats[1] && switchButton.buttonOrder.get(2) == cats[2])
    WHICH_BGRAPH = 2;
  if (switchButton.buttonOrder.get(1) == cats[0] && switchButton.buttonOrder.get(2) == cats[1] && switchButton.buttonOrder.get(0) == cats[2])
    WHICH_BGRAPH = 4;
  if (switchButton.buttonOrder.get(2) == cats[0] && switchButton.buttonOrder.get(0) == cats[1] && switchButton.buttonOrder.get(1) == cats[2])
    WHICH_BGRAPH = 3;
  if (switchButton.buttonOrder.get(2) == cats[0] && switchButton.buttonOrder.get(1) == cats[1] && switchButton.buttonOrder.get(0) == cats[2])
    WHICH_BGRAPH = 5;
  bgraphs[WHICH_BGRAPH].draw(255);
  if (! toolTip.equals("")) {
      textSize(15);
      textLeading(17);
      textAlign(LEFT);
      float textW = textWidth(toolTip);
      fill(255);
      rect(mouseX, mouseY-55, textW*1.1f, 55);
      fill(0);
      text(toolTip, mouseX+ textW*0.05f, mouseY-38);
      textAlign(CENTER, BOTTOM);
    }
  
  switchButton.draw();
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
    color(100, 100, 200), color(0, 255, 0), color(255, 0, 0), color(0, 255, 255), color(255, 0, 255)};
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
      cIndex = floor(random(colors.length));
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
          tempC = new Canvas(c.x0, c.y0 + (tempArea / rowWidth), rowWidth, row.get(i).valueSum * c.VA_ratio / rowWidth);
        } else {
          tempC = new Canvas(c.x0 + (tempArea / rowWidth), c.y0, row.get(i).valueSum * c.VA_ratio / rowWidth, rowWidth);
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
    boolean inter = false;
    for (int i = 0; i < row.size (); i++) {
      if (row.get(i).children.size() == 0) {
        textAlign(CENTER, CENTER);
        textSize(12);
        if (rowVertical) {
          inter = intersect(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).valueSum * c.VA_ratio/ rowWidth));
          fill(inter? highlight : row.get(i).c); 
          if (inter)
            toolTip = (row.get(i).parent.parent.id + "\n" + row.get(i).parent.id + "\n" + row.get(i).valueSum);
          framerect(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).valueSum * c.VA_ratio/ rowWidth));
          row.get(i).updatePosition(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).valueSum * c.VA_ratio/ rowWidth));
          fill(0);
        } else {
          inter = intersect((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).valueSum * c.VA_ratio / rowWidth), rowWidth);
          fill(inter? highlight : row.get(i).c);
          if (inter)
            toolTip = (row.get(i).parent.parent.id + "\n" + row.get(i).parent.id + "\n" + row.get(i).valueSum);
          framerect((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).valueSum * c.VA_ratio / rowWidth), rowWidth);
          row.get(i).updatePosition((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).valueSum * c.VA_ratio / rowWidth), rowWidth);
          fill(0);
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
  public void zoomIn() {
    for (int i = 0; i< curr_root.children.size(); ++i) {
       if(intersect(curr_root.children.get(i).x, curr_root.children.get(i).y, curr_root.children.get(i).w, curr_root.children.get(i).h)) {
         
         curr_root = curr_root.children.get(i);
       }  
    }
  }

  SqTreeMap(Node root) {
    this.root = root;
    this.curr_root = root;
  }
}



class BarGraph extends Graph {
  
  // List of items to be drawn (in place of rects)
  // in order of increasing xData
  ArrayList<Drawable> items;
  boolean draw_tool_tips;

  BarGraph(ArrayList<String> xData, ArrayList<Integer> yData) {
    super(xData, yData);
    this.items = new ArrayList<Drawable>(); // the items to be drawn
    this.draw_tool_tips = false;
  }

  public void draw(int tintVal) {
    super.draw();
    drawBars(tintVal);
  }

  public boolean testToolTip(float upperX, float upperY, float widthB, float heightB, int tintVal) {
    if (mouseX >= upperX && mouseX <= (upperX + widthB) && mouseY >= upperY && mouseY <= (upperY + heightB)) {
//      fill(255,20,0, tintVal);
    fill (0, 20, 255, tintVal);

      return true;
    }
    fill (0, 20, 255, tintVal);
    return false;
  }
  
  public void drawBars(int tintVal){
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    float tickX = width*0.1f + xInterval;
    float halfTick = height*0.01f;
    float upperX, upperY, widthB, heightB;
    String tooltip = "";
    
    boolean drawItems = (items.size() == xData.size());
    if ((!drawItems) && items.size() > 0) {
      println("Error:    xData.size() =",xData.size()," does not match items.size() =",items.size());
      println("Solution: IGNORING items.");
    }
    
    for (int i = 0; i < xData.size(); ++i) {
      upperX = tickX-(xInterval*0.9f)/2;
      upperY = zeroY-unit*yData.get(i);
      widthB = xInterval*0.9f;
      heightB = unit*yData.get(i);
      if (draw_tool_tips && testToolTip(upperX, upperY, widthB, heightB, tintVal)) {
        tooltip = xData.get(i) + ", " + yData.get(i);
      }
//      tint(255, tintVal);
      rect(upperX, upperY, widthB, heightB);
      if (drawItems) {
        items.get(i).draw(upperX, upperY, widthB, heightB);
      }

      tickX+= xInterval;
      
    }
    
//    if (tooltip != "") {
//      textSize(15);
//      textAlign(LEFT);
//      float textW = textWidth(tooltip);
//      fill(255);
//      rect(mouseX, mouseY-20, textW*1.1, 20);
//      fill(0);
//      text(tooltip, mouseX+ textW*0.05, mouseY-3);
//      textAlign(CENTER, BOTTOM);
//    }

    textAlign(LEFT, CENTER);
    textSize(15);
  }
}


public interface Drawable {
  public void draw(float x0, float y0, float w, float h);
}



class Graph {
  
  ArrayList<String> xData;
  ArrayList<Integer> yData;
  float unit;
  float zeroY;
  int longestIndex;
  int maxRange, topRange, lowRange;
  int intervalX;
  boolean isDragged;
  
  Graph(ArrayList<String> xData, ArrayList<Integer> yData) {
    this.xData = xData;
    this.yData = yData;
    splitLabel();
    longestIndex = getLongestXValueIndex();
    println(xData.get(longestIndex));
    if (getMinYValue() < 0) {
      intervalX = ceil((getMaxYValue() - getMinYValue()) / 10.0f);
      //intervalX = ceil((getMaxYValue()-getMinYValue()) / 50.0) * 5;
      lowRange = (abs(getMinYValue()) % intervalX == 0) ? getMinYValue() : (getMinYValue() - (intervalX - (abs(getMinYValue()) % intervalX)));
      topRange  = (getMaxYValue() % intervalX == 0) ? getMaxYValue() : (getMaxYValue() + (getMaxYValue() % intervalX));
      maxRange = topRange - lowRange;
      }
    else {
      intervalX = ceil((getMaxYValue() - getMinYValue()) / 10.0f);
      //intervalX = ceil(getMaxYValue()/ 50.0) * 5;
      topRange  = (getMaxYValue() % intervalX == 0) ? getMaxYValue() : (getMaxYValue() + (getMaxYValue() % intervalX));
      lowRange = 0;
      maxRange = topRange;
    }
  }
  
  public void splitLabel() {
    String l [], temp;
    for (int i = 0; i < xData.size(); ++i) {
      temp = "";
      l = splitTokens(xData.get(i));
      for (int j = 0; j < l.length; ++j) {
        temp += l[j] + "\n";
      }
      xData.set(i, temp);
    }
  }
  
  public void draw() {
    drawAxis();
    drawYTicks();
    drawXTicks();
    drawXLabels();
  }

  public void drawXLabels() {
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    float tickX = width*0.1f + xInterval;
    int tSize = 20;
    textSize(tSize);
    while (textWidth(xData.get(longestIndex)) > (height*0.15f-height*0.02f)) {
      --tSize;
      textSize(tSize);
    }
    textSize(tSize);
    textLeading(tSize);
    for (int i = 0; i < xData.size(); i++) {
      textAlign(LEFT, CENTER);
      pushMatrix();
      translate(tickX,height*0.99f);
      rotate(-HALF_PI);
      fill(0);
      text(xData.get(i), 0, 0);
      popMatrix();
      tickX += xInterval;
    }
    textSize(15);
  }
  
  public void drawAxis() {
    if (getMinYValue()<0) {
      unit = (height*0.75f  /(maxRange))/1.1f;
      zeroY = height*0.85f + lowRange*unit;
    }
    else {
      unit = (height*0.75f / (maxRange))/1.1f;
      zeroY = height*0.85f;
    }
    // Y-Axis
    line(width*0.1f, height*0.85f, width*0.1f, height*0.1f);
    // X- Axis
    line(width*0.1f, zeroY, width*0.9f, zeroY);
  }

  public void drawYTicks() {
    textAlign(CENTER, CENTER);
    float halfTick = width * 0.01f;
    for (int i = lowRange; i <= topRange; i+= intervalX) {
      line(width*0.1f- halfTick, zeroY-unit*i, width*0.1f+halfTick, zeroY-unit*i);
      fill(0,0,0);
      text(i, width*0.05f, zeroY-unit*i);
    }
  }

  public void drawXTicks() {
    float halfTick = height * 0.01f;
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    float tickX = width*0.1f + xInterval;
    for (int i = 0; i < xData.size(); i++) {
      line(tickX, zeroY - halfTick, tickX, zeroY+halfTick);
      tickX += xInterval;
    }
  }
  
  public int getLongestXValueIndex() {
   int index = 0;
   textSize(15);
   float maxL = textWidth(xData.get(0));
   for (int i = 0; i < xData.size(); i++) {
     if (textWidth(xData.get(i)) > maxL) {
       index = i;
       maxL = textWidth(xData.get(i));
     }
   }
   return index;
 }
 
  
  public int getMaxYValue() {
   int maxIndex = yData.indexOf(Collections.max(yData));
   return yData.get(maxIndex);
  }
  
  public int getMinYValue() {
   int minIndex = yData.indexOf(Collections.min(yData));
   return yData.get(minIndex);
  }
}


class Button {
	float h, w;
	float initX, initY;
	float x, y;
	String title;
	boolean locked, alwaysLocked;

	Button(float x, float y, float w, float h, String title) {
		this.initX = x;
		this.initY = y;
		this.x = x;
		this.y = y;
		this.h = h;
		this.w = w;
		this.title = title;
		this.locked = true;
		this.alwaysLocked = false;
	}

	public void draw() {
		fill(200, 150, 10);
		rect(x, y, w, h);
		fill(255, 255, 255);
		textAlign(CENTER, CENTER);
        textSize(10);
        text(title, x + w/2, y + h/2);
	}

	// GETTERS
	public String getTitle() 	{ return title; }
	public float getWidth() 	{ return w; }
	public float getCenterX() 	{ return x + w/2; }
	public float getCenterY() 	{ return y + h/2; }
	public float getX() 		{ return x; }
	public float getY() 		{ return y; }
	public float getInitX() 	{ return initX; }

	// SETTERS
	public void setAlwaysLocked() 	{ this.alwaysLocked = true; }
	public void unlock() 			{ locked = false; }
	public void lock()  		 	{ locked = true; }
	public void moveUnlockedButton() {
		if (!alwaysLocked && !locked) {
			x = mouseX - w/2;
		}
	}

	public void setX(float x) {
		if (!alwaysLocked) {
			this.x = x;
		}
	}

	public void setInitX(float x) {
		if (!alwaysLocked) {
			this.initX = x;
		}
	}

	// BOOLS
	public boolean isAlwaysLocked() 	{ return alwaysLocked; }
	public boolean isLocked() 			{ return locked; }
	public boolean isIntersect() {
		if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
			return true;
		} else {
			return false;
		}
	}

	public boolean isRightNeighbor(Button b) {
		// immediately right
		if (initX == b.getInitX() + w) {
			return true;
		} else {
			return false;
		}
	}

	public boolean isLeftNeighbor(Button b) {
		// immediately left
		if (b.getInitX() == initX + w) {
			return true;
		} else {
			return false;
		}
	}
};


class SwitchButton {

	ArrayList<Button> buttons;
	ArrayList<String> buttonOrder;
	float buttonHeight;
	float buttonWidth;
	float totalWidth;
	float x0, y0;
	float button1X, button2X, button3X;
	boolean buttonUnlocked;

	SwitchButton(ArrayList<String> data, float x0, float y0) {
		this.buttonHeight = 20;
		this.buttonWidth = 80;
		this.buttons = new ArrayList<Button>();
		this.buttonOrder = new ArrayList<String>();
		this.totalWidth = 0;
		this.x0 = x0;
		this.y0 = y0;
		this.buttonUnlocked = false;

		float xPos = x0;
		for(int i=0; i<data.size(); i++) {
			this.buttonOrder.add(data.get(i));
			Button b = new Button(xPos, y0, buttonWidth, buttonHeight, data.get(i) );
			this.buttons.add(b);	
			this.totalWidth += buttonWidth;
			xPos += buttonWidth;
		}
		// Last button cannot be moved
		this.buttons.get(this.buttons.size()-1).setAlwaysLocked();
	}

	public void draw() {
		for(int i=0; i<buttons.size(); i++) {
			buttons.get(i).draw();
		}
	}

	// Used by Treemap to get order of categories
	public ArrayList<String> getButtonOrder() { 
		return buttonOrder; 
	}

	public void buttonDragged() {
		// Make the current clicked button moveable/unlocked
		unlockClickedButton();
		for (int i=0; i<buttons.size(); i++) {
			Button b = buttons.get(i);
			// If mouse intersects with button and is not the last button
			if (b.isIntersect() && !b.isAlwaysLocked()) {
				// Move the button until its x pos overlaps with another button's x pos
				if (!isOverlapped(b)) {
					b.moveUnlockedButton();
				} 
			}
		}
	}

	public void unlockClickedButton() {
		//buttonUnlocked allows only one button to be unlocked at a time during mouse dragged
		if (!buttonUnlocked) {
			for (int i=0; i<buttons.size(); i++) {
				if (buttons.get(i).isIntersect()) {
					buttons.get(i).unlock();
					buttonUnlocked = true;
					break;	
				}
			}
		}
	}

	// Iterates through buttons and checks if current has overlapped any of them, 
	// Swaps the positions if so
	public boolean isOverlapped(Button current) {
		for (int i=0; i<buttons.size(); i++) {
			Button b = buttons.get(i);
			if (!b.isAlwaysLocked() && b.isLocked()) {
				if ( (current.getX() > b.getX() && b.isRightNeighbor(current)) || 
					 (current.getX() < b.getX() && b.isLeftNeighbor(current)) ) {
					// Swaps the current and overlapped button's X's
					b.setX(current.getInitX());
					current.setX(b.getInitX());

					// Resets InitX to the swapped X values
					b.setInitX(current.getInitX());
					current.setInitX(current.getX());

					// Swap order of buttonOrder arraylist to reflect changes in button order
					swapButtonOrder(current, b); 
					return true;
				}
			}
		}
		return false;
	}

	// Finds indexes of two buttons and swaps their positions using Collections in
	// buttonOrder arraylist (strings)
	public void swapButtonOrder(Button currentButton, Button toSwapButton) {
		int currentIndex = getButtonIndex(currentButton);
		int toSwapIndex = getButtonIndex(toSwapButton);

		if (currentIndex != -1 && toSwapIndex != -1) {
			Collections.swap(buttonOrder, currentIndex, toSwapIndex);
		}
	}

	// Returns -1 if Button is not in buttons arraylist
	public int getButtonIndex(Button b) {
		for (int i=0; i<buttons.size(); i++) {
			// This assumes the buttons are all labeled differently
			if (buttonOrder.get(i) == b.getTitle()) {
				return i;
			}
		}
		return -1;
	}

	// Resets all buttons to locked, snap current button back into place
	public void buttonReleased() {
		for (int i=0; i<buttons.size(); i++){
			buttons.get(i).lock();
			buttons.get(i).setX(buttons.get(i).getInitX());
		}
		buttonUnlocked = false;
	}
};

SwitchButton switchButton;

public void mouseDragged() {
	switchButton.buttonDragged();
}

public void mouseReleased() {
	switchButton.buttonReleased();
}





  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "funding" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
