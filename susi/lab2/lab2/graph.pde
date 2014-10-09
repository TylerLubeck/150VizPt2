
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
    //println(xData.get(longestIndex));
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
  
  void splitLabel() {
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
    textLeading(tSize);
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
    //println(maxRange);
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
 
  
  int getMaxYValue() {
   int maxIndex = 0; //yData.indexOf(Collections.max(yData));
   for (int i = 0; i < yData.size(); i++) {
     if (yData.get(i) > yData.get(maxIndex))
       maxIndex = i;
   }
   return yData.get(maxIndex);
  }
  
  int getMinYValue() {
   int minIndex = 0; //xData.indexOf(Collections.min(yData));
   for (int i = 0; i < yData.size(); i++) {
     if (yData.get(i) < yData.get(minIndex))
       minIndex = i;
   }
   return yData.get(minIndex);
  }
}
