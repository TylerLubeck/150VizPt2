import java.util.Collections;

class BarGraph extends Graph {
  
  // List of items to be drawn (in place of rects)
  // in order of increasing xData
  ArrayList<Drawable> items;

  BarGraph(ArrayList<String> xData, ArrayList<Float> yData) {
    super(xData, yData);
    this.items = new ArrayList<Drawable>(); // the items to be drawn
  }
  
  void draw(int tintVal) {
    super.draw();
    drawBars(tintVal);
  }

  boolean testToolTip(float upperX, float upperY, float widthB, float heightB, int tintVal) {
    if (mouseX >= upperX && mouseX <= (upperX + widthB) && mouseY >= upperY && mouseY <= (upperY + heightB)) {
      fill(255,20,0, tintVal);
      return true;
    }
    fill (0, 20, 255, tintVal);
    return false;
  }
  
  void drawBars(int tintVal){
    float xInterval = width*0.8 / (float(xData.size()) + 1.0);
    float tickX = width*0.1 + xInterval;
    float halfTick = height*0.01;
    float upperX, upperY, widthB, heightB;
    String tooltip = "";
    
    boolean drawItems = (items.size() == xData.size());
    if ((!drawItems) && items.size() > 0) {
      println("Error:    xData.size() =",xData.size()," does not match items.size() =",items.size());
      println("Solution: IGNORING items.");
    }
    
    for (int i = 0; i < xData.size(); ++i) {
      upperX = tickX-(xInterval*0.9)/2;
      upperY = zeroY-unit*yData.get(i);
      widthB = xInterval*0.9;
      heightB = unit*yData.get(i);
      if (testToolTip(upperX, upperY, widthB, heightB, tintVal)) {
        tooltip = xData.get(i) + ", " + yData.get(i);
      }
//      tint(255, tintVal);
      rect(upperX, upperY, widthB, heightB);
      if (drawItems) {
        items.get(i).draw(upperX, upperY, widthB, heightB);
      }

      tickX+= xInterval;
      
    }
    
    if (tooltip != "") {
      textSize(15);
      textAlign(LEFT);
      float textW = textWidth(tooltip);
      fill(255);
      rect(mouseX, mouseY-20, textW*1.1, 20);
      fill(0);
      text(tooltip, mouseX+ textW*0.05, mouseY-3);
      textAlign(CENTER, BOTTOM);
    }

    textAlign(LEFT, CENTER);
    textSize(15);
  }
  
  float getWidth() {
    return width*0.8 / (float(xData.size()) + 1.0);
  }
};

