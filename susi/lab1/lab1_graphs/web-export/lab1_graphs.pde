
 ArrayList<String> xData;
 ArrayList<Integer> yData;
 boolean isLineGraph;
 LineGraph lineGraph;
 BarGraph barGraph;
 String[] button = {"Bar Graph", "Line Graph"};
 float buttonW, buttonH;
 boolean inTransition;
 int tintVal;
  
 void setup() {
   size(600,600);
   frame.setResizable(true);
   textSize(15);
   buttonW = max(textWidth(button[0]), textWidth(button[1])) + 4;
   buttonH = 18;
   xData = new ArrayList<String>();
   yData = new ArrayList<Integer>();
   isLineGraph = true; // true = line graph
   
   parseData("lab1-data.csv");
   
   lineGraph = new LineGraph(xData, yData);
   barGraph = new BarGraph(xData, yData);
   
   tintVal = 255;
 }
 
 void draw() {
   background(255, 255, 255);
   fill(220);
   rect(width*0.9 - buttonW, height*0.1, buttonW, buttonH);
   fill(0);
   textAlign(CENTER, CENTER);
   if(inTransition) {
     lineGraph.draw(abs(tintVal-255));
     barGraph.draw(tintVal);
     tintVal = isLineGraph? (tintVal - 5) : (tintVal + 5);
     if (tintVal == 255 || tintVal == 0) {
       inTransition = false;
       tintVal = 255;
     }
   }
   else {
     if(isLineGraph) {
       text(button[0], width*0.9-buttonW/2, height*0.1+9);
     }
     else {
       text(button[1], width*0.9-buttonW/2, height*0.1+9);
     }
      if (isLineGraph) {
        lineGraph.draw(tintVal);
      } else {
        barGraph.draw(tintVal);
      }
   }
 }
  
  
 void parseData(String file) {
   String data[] = loadStrings(file);
   
   for (int i=1; i < data.length; i++) {
      String temp[] = splitTokens(data[i], ", "); 
      String name = trim(temp[0]);
      int number = Integer.parseInt(trim(temp[1]));
      xData.add(name);
      yData.add(number);
   }
 }
 
void mouseClicked() {
  if (mouseX <= width* 0.9 && mouseX >= (width*0.9 - buttonW) 
      && mouseY >= height*0.1 && mouseY <= (height*0.1 + buttonH)) {
        isLineGraph = !isLineGraph;
        inTransition = true;
        tintVal = isLineGraph? 250 : 5;
  }
}
   

import java.util.Collections;

class BarGraph extends Graph {
  
  // List of items to be drawn (in place of rects)
  // in order of increasing xData
  ArrayList<Drawable> items;

  BarGraph(ArrayList<String> xData, ArrayList<Integer> yData) {
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
}

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
 
  
  int getMaxYValue() {
   int maxIndex = yData.indexOf(Collections.max(yData));
   return yData.get(maxIndex);
  }
  
  int getMinYValue() {
   int minIndex = yData.indexOf(Collections.min(yData));
   return yData.get(minIndex);
  }
};
import java.util.Collections;

class LineGraph extends Graph {
  
  LineGraph(ArrayList<String> xData, ArrayList<Integer> yData) {
    super(xData, yData);
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
  
}

