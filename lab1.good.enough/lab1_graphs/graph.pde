import java.util.Collections;

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
    longestIndex = getLongestXValueIndex();
    if (getMinYValue() < 0) {
      intervalX = ceil((getMaxYValue() - getMinYValue()) / 10.0);
      //intervalX = ceil((getMaxYValue()-getMinYValue()) / 50.0) * 5;
      lowRange = (abs(getMinYValue()) % intervalX == 0) ? getMinYValue() : (getMinYValue() - (intervalX - (abs(getMinYValue()) % intervalX)));
      topRange  = (getMaxYValue() % intervalX == 0) ? getMaxYValue() : (getMaxYValue() + (getMaxYValue() % intervalX));
      maxRange = topRange - lowRange;
      }
    else {
      intervalX = ceil((getMaxYValue() - getMinYValue()) / 10.0);
      //intervalX = ceil(getMaxYValue()/ 50.0) * 5;
      topRange  = (getMaxYValue() % intervalX == 0) ? getMaxYValue() : (getMaxYValue() + (getMaxYValue() % intervalX));
      lowRange = 0;
      maxRange = topRange;
    }
  }
  
  void draw() {
    drawAxis();
    drawYTicks();
    drawXTicks();
    drawXLabels();
  }

  void drawXLabels() {
    float xInterval = width*0.8 / (float(xData.size()) + 1.0);
    float tickX = width*0.1 + xInterval;
    int tSize = 20;
    textSize(tSize);
    while (textWidth(xData.get(longestIndex)) > (height*0.15-height*0.02)) {
      --tSize;
      textSize(tSize);
    }
    textSize(tSize);
    for (int i = 0; i < xData.size(); i++) {
      textAlign(LEFT, CENTER);
      pushMatrix();
      translate(tickX,height*0.99);
      rotate(-HALF_PI);
      fill(0);
      text(xData.get(i), 0, 0);
      popMatrix();
      tickX += xInterval;
    }
    textSize(15);
  }
  
  void drawAxis() {
    if (getMinYValue()<0) {
      unit = (height*0.75  /(maxRange))/1.1;
      zeroY = height*0.85 + lowRange*unit;
    }
    else {
      unit = (height*0.75 / (maxRange))/1.1;
      zeroY = height*0.85;
    }
    // Y-Axis
    line(width*0.1, height*0.85, width*0.1, height*0.1);
    // X- Axis
    line(width*0.1, zeroY, width*0.9, zeroY);
  }

  void drawYTicks() {
    float halfTick = width * 0.01;
    for (int i = lowRange; i <= topRange; i+= intervalX) {
      line(width*0.1- halfTick, zeroY-unit*i, width*0.1+halfTick, zeroY-unit*i);
      fill(0,0,0);
      text(i, width*0.05, zeroY-unit*i);
    }
  }

  void drawXTicks() {
    float halfTick = height * 0.01;
    float xInterval = width*0.8 / (float(xData.size()) + 1.0);
    float tickX = width*0.1 + xInterval;
    for (int i = 0; i < xData.size(); i++) {
      line(tickX, zeroY - halfTick, tickX, zeroY+halfTick);
      tickX += xInterval;
    }
  }
  
  int getLongestXValueIndex() {
   int index = 0;
   int maxL = (xData.get(0)).length();
   for (int i = 0; i < xData.size(); i++) {
     if ((xData.get(i)).length() > maxL) {
       index = i;
       maxL = (xData.get(i)).length();
     }
   }
   return index;
 }
 
  
  int getMaxYValue() {
   int maxIndex = yData.indexOf(Collections.max(yData));
   return yData.get(maxIndex);
  }
  
  int getMinYValue() {
   int minIndex = yData.indexOf(Collections.min(yData));
   return yData.get(minIndex);
  }
}
