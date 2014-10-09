import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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

public class lab1_graphs extends PApplet {


 ArrayList<String> xData;
 ArrayList<Integer> yData;
 boolean isLineGraph;
 LineGraph lineGraph;
 BarGraph barGraph;
 String[] button = {"Bar Graph", "Line Graph"};
 float buttonW, buttonH;
  
 public void setup() {
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
 }
 
 public void draw() {
   background(255, 255, 255);
   fill(220);
   rect(width*0.9f - buttonW, height*0.1f, buttonW, buttonH);
   fill(0);
   textAlign(CENTER, CENTER);
   if(isLineGraph) {
     text(button[0], width*0.9f-buttonW/2, height*0.1f+9);
   }
   else {
     text(button[1], width*0.9f-buttonW/2, height*0.1f+9);
   }
    if (isLineGraph) {
      lineGraph.draw();
    } else {
      barGraph.draw();
    }
 }
  
  
 public void parseData(String file) {
   String data[] = loadStrings(file);
   
   for (int i=1; i < data.length; i++) {
      String temp[] = splitTokens(data[i], ", "); 
      String name = trim(temp[0]);
      int number = Integer.parseInt(trim(temp[1]));
      xData.add(name);
      yData.add(number);
   }
 }
 
public void mouseClicked() {
  if (mouseX <= width* 0.9f && mouseX >= (width*0.9f - buttonW) 
      && mouseY >= height*0.1f && mouseY <= (height*0.1f + buttonH)) {
        isLineGraph = !isLineGraph;
  }
}
   



class BarGraph extends Graph {
  
  BarGraph(ArrayList<String> xData, ArrayList<Integer> yData) {
    super(xData, yData);
  }

  public void draw() {
    super.draw();
    drawBars();
  }

  public boolean testToolTip(float upperX, float upperY, float widthB, float heightB) {
    if (mouseX >= upperX && mouseX <= (upperX + widthB) && mouseY >= upperY && mouseY <= (upperY + heightB)) {
      fill(255,20,0);
      return true;
    }
    fill (0, 20, 255);
    return false;
  }
  
  public void drawBars(){
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    float tickX = width*0.1f + xInterval;
    float halfTick = height*0.01f;
    float upperX, upperY, widthB, heightB;
    String tooltip = "";
    
    for (int i = 0; i < xData.size(); ++i) {
      upperX = tickX-(xInterval*0.9f)/2;
      upperY = zeroY-unit*yData.get(i);
      widthB = xInterval*0.9f;
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
      rect(mouseX, mouseY-20, textW*1.1f, 20);
      fill(0);
      text(tooltip, mouseX+ textW*0.05f, mouseY-3);
      textAlign(CENTER, BOTTOM);
    }

    textAlign(LEFT, CENTER);
    textSize(15);
  }
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
    longestIndex = getLongestXValueIndex();
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
   int maxL = (xData.get(0)).length();
   for (int i = 0; i < xData.size(); i++) {
     if ((xData.get(i)).length() > maxL) {
       index = i;
       maxL = (xData.get(i)).length();
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


class LineGraph extends Graph {
  
  LineGraph(ArrayList<String> xData, ArrayList<Integer> yData) {
    super(xData, yData);
  }
  
  public void draw() {
    super.draw();
    drawLines();
    drawDots();
  }
  
  public boolean testToolTip(float centerX, float centerY, float radius) {
    float distance = sqrt((mouseX - centerX) * (mouseX - centerX) + (mouseY - centerY) * (mouseY - centerY));
    if (distance <= radius) {
      fill(255,20,0);
      return true;
    }
    fill (0, 20, 255);
    return false;
  }
  
  public void drawDots() {
    float x,y;
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    String tooltip = "";
    x = width*0.1f + xInterval;
    for (int i = 0; i < xData.size(); i++) {
      y = zeroY - unit * yData.get(i);
      if(testToolTip(x,y,0.01f*width)) {
        tooltip = xData.get(i) + ", " + yData.get(i);
      }
      ellipse(x,y,0.01f*width,0.01f*width);
      x += xInterval;
    }
    if (tooltip != "") {
      textSize(15);
      textAlign(LEFT);
      float textW = textWidth(tooltip);
      fill(255);
      rect(mouseX, mouseY-20, textW*1.1f, 20);
      fill(0);
      text(tooltip, mouseX+ textW*0.05f, mouseY-3);
      textAlign(CENTER, BOTTOM);
    }
    textAlign(LEFT, CENTER);
    textSize(15);

  }
  
  public void drawLines() {
    float x,y;
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    x = width*0.1f + xInterval;
    float xPrev = x;
    float yPrev = zeroY - unit * yData.get(0);
    x += xInterval;
    for (int i = 1; i < xData.size(); i++) {
      y = zeroY - unit * yData.get(i);
      //ellipse(x,y,0.01*width,0.01*height);
      line(xPrev,yPrev,x,y);
      xPrev = x;
      yPrev = y;
      x += xInterval;
    }
  }
  
  public int getMaxYValue(ArrayList<Integer> yData) {
   int maxIndex = yData.indexOf(Collections.max(yData));
   return yData.get(maxIndex);
  }
  
  public int getMinYValue(ArrayList<Integer> yData) {
   int minIndex = yData.indexOf(Collections.min(yData));
   return yData.get(minIndex);
  }
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "lab1_graphs" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
