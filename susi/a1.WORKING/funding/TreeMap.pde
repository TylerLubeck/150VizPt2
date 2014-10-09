
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

  void printMe() {
    this.root.printMe();
  }

}

class SqTreeMap extends TreeMap implements Cloneable,Drawable {
  color[] colors = {
    color(100, 100, 200), color(0, 255, 0), color(255, 0, 0), color(0, 255, 255), color(255, 0, 255)};
  color highlight = color(255, 255, 0);
  /* Location of the SqTreeMap on the main canvas */
  //  Canvas canvas;
  Node curr_root; // zoom-level root

  /* Squarified TreeMap subdivision algorithm goes here */
  void draw(float x0, float y0, float w, float h) {
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

  void rec_draw(ArrayList<Node> children, Canvas c, float area) {
    
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
  
  void framerect(float x, float y, float w, float h) {
    float f = 0.000*width;
    rect(x + f, y + f, w - 2*f, h - 2*f);
  } 

  void drawRow(ArrayList<Node> row, Canvas c, boolean rowVertical, float rowArea, float rowWidth) {
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
  
  boolean intersect(float x0, float y0, float w, float h) {
    return (mouseX >= x0 && mouseX <= (x0 + w) && mouseY >= y0 && mouseY <= (y0 +h));
  }

  float worstRatio(ArrayList<Node> row, float rowLength, float ratio) {
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
  void zoomIn() {
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

