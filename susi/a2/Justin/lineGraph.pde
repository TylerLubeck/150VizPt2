import java.util.Collections;

class LineGraph extends Graph implements Drawable {
  
  LineGraph(ArrayList<String> xData, ArrayList<Float> yData) {
    super(xData, yData);
  }
  
  void draw(float x, float y, float w, float h) {
    draw(255);
  }
  
  void draw(int tintVal) {
    if (tintVal == 255) {
      super.draw();
    }
    drawLines(tintVal);
    drawDots(tintVal);
  }
  
  boolean testToolTip(float centerX, float centerY, float radius, int tintVal) {
    float distance = sqrt((mouseX - centerX) * (mouseX - centerX) + (mouseY - centerY) * (mouseY - centerY));
    if (distance <= radius) {
      fill(255,20,0, tintVal);
      return true;
    }
    fill (0, 20, 255, tintVal);
    return false;
  }
  
  void drawDots(int tintVal) {
    float x,y;
    float xInterval = width*0.8 / (float(xData.size()) + 1.0);
    String tooltip = "";
    x = width*0.1 + xInterval;
    for (int i = 0; i < xData.size(); i++) {
      y = zeroY - unit * yData.get(i);
      if(testToolTip(x,y,0.01*width, tintVal)) {
        tooltip = xData.get(i) + ", " + yData.get(i);
      }
      ellipse(x,y,0.015*width,0.015*width);
      x += xInterval;
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
  
  void drawLines(int tintVal) {
    float x,y;
    float xInterval = width*0.8 / (float(xData.size()) + 1.0);
    x = width*0.1 + xInterval;
    float xPrev = x;
    float yPrev = zeroY - unit * yData.get(0);
    x += xInterval;
    for (int i = 1; i < xData.size(); i++) {
      y = zeroY - unit * yData.get(i);
      color(0, tintVal);
      line(xPrev,yPrev,x,y);
      xPrev = x;
      yPrev = y;
      x += xInterval;
    }
  }
  
  int getMaxYValue(ArrayList<Integer> yData) {
   int maxIndex = yData.indexOf(Collections.max(yData));
   return yData.get(maxIndex);
  }
  
  int getMinYValue(ArrayList<Integer> yData) {
   int minIndex = yData.indexOf(Collections.min(yData));
   return yData.get(minIndex);
  }
  
};
