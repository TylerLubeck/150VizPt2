import java.util.Collections;

class BarGraph extends Graph {
  
  BarGraph(ArrayList<String> xData, ArrayList<Integer> yData) {
    super(xData, yData);
  }

  void draw() {
    super.draw();
    drawBars();
  }

  boolean testToolTip(float upperX, float upperY, float widthB, float heightB) {
    if (mouseX >= upperX && mouseX <= (upperX + widthB) && mouseY >= upperY && mouseY <= (upperY + heightB)) {
      fill(255,20,0);
      return true;
    }
    fill (0, 20, 255);
    return false;
  }
  
  void drawBars(){
    float xInterval = width*0.8 / (float(xData.size()) + 1.0);
    float tickX = width*0.1 + xInterval;
    float halfTick = height*0.01;
    float upperX, upperY, widthB, heightB;
    String tooltip = "";
    
    for (int i = 0; i < xData.size(); ++i) {
      upperX = tickX-(xInterval*0.9)/2;
      upperY = zeroY-unit*yData.get(i);
      widthB = xInterval*0.9;
      heightB = unit*yData.get(i);
      if (testToolTip(upperX, upperY, widthB, heightB)) {
        tooltip = xData.get(i) + ", " + yData.get(i);
      }
      rect(upperX, upperY, widthB, heightB);
      
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
}

