
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

class Node {
  
  float value;
  boolean marked;
  float x, y, w, h;

  Node(float value, boolean marked) {
    this.value = value;
    this.marked = marked;
  }
}


class SqTreeMap  {
  ArrayList<Node> values;
  float totalVal;
  float overallWidth;
  
  SqTreeMap(Data d) {
    values = new ArrayList<Node>();
    setMembers(d);
    sortValues();
  }
  
  void setMembers(Data d) {
    float total = 0.0;
    Node temp;
    for (int i = 0; i < d.getSize(); ++i) {
      total += d.getValue(i);
      temp = new Node(d.getValue(i), d.isMarked(i));
      values.add(temp);
    }
    totalVal = total;
  }
  
  void sortValues() {
    int j;
    Node temp;
    for (int i = 1; i < values.size(); ++i) {
      j = i-1;
      while (j >=0 && values.get(i).value > values.get(j).value) 
        j--;
      if (i != (j+1)) {
        temp = values.get(i);
        values.remove(i);
        values.add(j+1, temp);
      }
    }
  }
  
  void draw(float x0, float y0, float w, float h) {
    overallWidth = w;
    Canvas canvas = new Canvas(x0, y0, w, h);
    canvas.VA_ratio = (canvas.w * canvas.h) / totalVal ;
    rec_draw((ArrayList<Node>)(values).clone(), canvas, totalVal);
  }

  void rec_draw(ArrayList<Node> children, Canvas c, float area) {
    int cIndex = 0; 
    ArrayList<Node> row = new ArrayList<Node>();
    boolean rowVertical = (c.h < c.w);
    float rowLength = c.h < c.w ? c.h : c.w;
    float rowArea = 0, rowWidth = 0;
    float currentRatio = 0;
    float tempRatio;
    
    while (children.size () > 0) {
      row.add(children.get(0));
      tempRatio = worstRatio(row, (rowArea + children.get(0).value * c.VA_ratio) / rowLength, c.VA_ratio);
      if (tempRatio >= currentRatio) {
        rowArea += children.get(0).value * c.VA_ratio;
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
      rec_draw((ArrayList<Node>)children, newC, (area - rowArea/c.VA_ratio));
    }
  }
  
  void framerect(float x, float y, float w, float h) {
    float f = 0.000*width;
    rect(x + f, y + f, w - 2*f, h - 2*f);
  } 

  void drawRow(ArrayList<Node> row, Canvas c, boolean rowVertical, float rowArea, float rowWidth) {
    float tempArea = 0;
    for (int i = 0; i < row.size (); i++) {
      fill(70, 170, 208);
        if (rowVertical) {
          rect(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).value * c.VA_ratio/ rowWidth));
          if (row.get(i).marked) {
            fill(0);
             ellipse(c.x0 + rowWidth / 2, (c.y0 + tempArea/ rowWidth) + (row.get(i).value * c.VA_ratio/ rowWidth) /2, 
                 overallWidth*0.02, overallWidth*0.02);
          }
        } else {
          rect((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).value * c.VA_ratio / rowWidth), rowWidth);
          if (row.get(i).marked) {
            fill(0);
            ellipse((c.x0 + tempArea / rowWidth) + (row.get(i).value * c.VA_ratio / rowWidth) / 2, c.y0 + rowWidth/2, 
                overallWidth*0.02, overallWidth*0.02);
          }
        } 
      tempArea += row.get(i).value * c.VA_ratio;
    }
  }
  
  
  float worstRatio(ArrayList<Node> row, float rowLength, float ratio) {
    float currentRatio = min((row.get(0).value * ratio / rowLength), rowLength) / 
    max((row.get(0).value * ratio / rowLength), rowLength);
    float tempRatio;
    for (int i=1; i < row.size (); i++) {
      tempRatio = min((row.get(i).value *ratio/ rowLength), rowLength) / 
      max((row.get(i).value*ratio / rowLength), rowLength); 
      if (tempRatio < currentRatio) {
        currentRatio = tempRatio;
      }
    }
    return abs(currentRatio);
  }

}

