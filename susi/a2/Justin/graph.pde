import java.util.Collections;

class Graph {
  
  ArrayList<String> xData;
  ArrayList<Float> yData;
  float unit;
  float zeroY;
  int longestIndex;
  int maxRange, topRange, lowRange;
  int intervalX;
  boolean isDragged;
  
  Graph(ArrayList<String> xData, ArrayList<Float> yData) {
    this.xData = xData;
    this.yData = yData;
    longestIndex = getLongestXValueIndex();
    if (getMinYValue() < 0) {
      intervalX = ceil((getMaxYValue() - getMinYValue()) / 10.0);
      //intervalX = ceil((getMaxYValue()-getMinYValue()) / 50.0) * 5;
      lowRange = (abs(floor(getMinYValue())) % intervalX == 0) ? floor(getMinYValue()) : (floor(getMinYValue()) - (intervalX - (abs(floor(getMinYValue())) % intervalX)));
      topRange  = (ceil(getMaxYValue()) % intervalX == 0) ? ceil(getMaxYValue()) : (ceil(getMaxYValue()) + (ceil(getMaxYValue()) % intervalX));
      maxRange = topRange - lowRange;
      }
    else {
      intervalX = ceil(getMaxYValue() / 10.0);
      //intervalX = ceil(getMaxYValue()/ 50.0) * 5;
      topRange  = (ceil(getMaxYValue()) % intervalX == 0) ? ceil(getMaxYValue()) : (ceil(getMaxYValue()) + (ceil(getMaxYValue()) % intervalX));
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
    textAlign(CENTER, CENTER);
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
 
  
  float getMaxYValue() {
   int maxIndex = yData.indexOf(Collections.max(yData));
   return yData.get(maxIndex);
  }
  
  float getMinYValue() {
   int minIndex = yData.indexOf(Collections.min(yData));
   return yData.get(minIndex);
  }
};
