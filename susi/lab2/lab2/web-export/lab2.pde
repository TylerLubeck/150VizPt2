
int curr = 0;
int NUM_SLIDES = 3;
Button nextButton;
int margin = 30, iWidth = 800, iHeight = 600;

void setup() {
  size(iWidth + 2 * margin, iHeight + 2 * margin, P2D);
  //size(800, 500);
  //size(width, height);
  background(255);
  nextButton = new Button(0.04*width, 0.93*height, 0.08*width, 0.05*height);
}

void draw() {
  background(255);
  switch (curr) {
    case 0: step0(); break;
    case 1: step1(); break;
    case 2: step2(); break;
  }
  //nextButton.draw();
}

void changeSlide(int n) { curr = n }

void mouseClicked() {
  if (nextButton.contains(mouseX,mouseY)) {    
    curr = (curr + 1) % NUM_SLIDES;
  }
}


class BarGraph extends Graph {
  
  // List of items to be drawn (in place of rects)
  // in order of increasing xData
  ArrayList<Drawable> items;
  boolean draw_tool_tips;

  BarGraph(ArrayList<String> xData, ArrayList<Integer> yData) {
    super(xData, yData);
    this.items = new ArrayList<Drawable>(); // the items to be drawn
    this.draw_tool_tips = true;
  }

  void draw(int tintVal) {
    super.draw();
    drawBars(tintVal);
  }

  boolean testToolTip(float upperX, float upperY, float widthB, float heightB, int tintVal) {
    if (mouseX >= upperX && mouseX <= (upperX + widthB) && mouseY >= upperY && mouseY <= (upperY + heightB)) {
//      fill(255,20,0, tintVal);
    fill (0, 20, 255, tintVal);

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
      
      //println(this.unit);
      upperX = tickX-(xInterval*0.9)/2;
      upperY = zeroY-unit*yData.get(i);
      widthB = xInterval*0.9;
      heightB = unit*yData.get(i);
      if (draw_tool_tips && testToolTip(upperX, upperY, widthB, heightB, tintVal)) {
        tooltip = xData.get(i) + ", " + yData.get(i);
      }
//      tint(255, tintVal);
      //print("rect("); print(upperX); print(", "); print(upperY); print(", "); print(widthB); print(", "); print(heightB); println(");");
      rect(upperX, upperY, widthB, heightB);
      if (drawItems) {
        items.get(i).draw(upperX, upperY, widthB, heightB);
      }

      tickX+= xInterval;
      
    }
    
//    if (tooltip != "") {
//      textSize(15);
//      textAlign(LEFT);
//      float textW = textWidth(tooltip);
//      fill(255);
//      rect(mouseX, mouseY-20, textW*1.1, 20);
//      fill(0);
//      text(tooltip, mouseX+ textW*0.05, mouseY-3);
//      textAlign(CENTER, BOTTOM);
//    }

    textAlign(LEFT, CENTER);
    textSize(15);
  }
}


class Button {

  float x;
  float y;
  float w;
  float h;

  Button(float x, float y, float w, float h) {
    this.x = x; this.y = y;
    this.w = w; this.h = h;
  }

  void draw() {
    //print(x); print(" "); print(y); print(" "); print(w); print(" "); println(h);
    rect(x,y,w,h);
  }

  boolean contains(int xM, int yM) {
    //println(xM,x,x+w,yM,y,y+h,curr);
    return (xM > x) && (xM < (x + w)) && (yM > y) && (yM < (y + h));
  }

}

public interface Drawable {
  void draw(float x0, float y0, float w, float h);
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
class PieGraph {
  ArrayList<String> categories;
  ArrayList<Integer> peoplePerCat;
  ArrayList<Double> angles;
  int totalNumPeople;
  
  PieGraph(ArrayList<String> categories, ArrayList<Integer> peoplePerCat) {
    this.categories = categories;
    this.peoplePerCat = peoplePerCat;
    angles = new ArrayList<Double>();
    calcTotalNum();
    calcAngles();
  }
  
  void getTotalNum() {
    totalNumPeople = 0;
    for (int i=0; i<peoplePerCat.size(); ++i) {
      totalNumPeople += peoplePerCat.get(i);
    }
  }
  
  void calcAngles() {
    for (int i = 0; i<peoplePerCat.size(); ++i) {
      angles.add(((double)peoplePerCat.get(i) / (double)totalNumPeople) * 360.0);
    }
  }
}


class BarGraph extends Graph {
  
  // List of items to be drawn (in place of rects)
  // in order of increasing xData
  ArrayList<Drawable> items;
  boolean draw_tool_tips;

  BarGraph(ArrayList<String> xData, ArrayList<Integer> yData) {
    super(xData, yData);
    this.items = new ArrayList<Drawable>(); // the items to be drawn
    this.draw_tool_tips = true;
  }

  void draw(int tintVal) {
    super.draw();
    drawBars(tintVal);
  }

  boolean testToolTip(float upperX, float upperY, float widthB, float heightB, int tintVal) {
    if (mouseX >= upperX && mouseX <= (upperX + widthB) && mouseY >= upperY && mouseY <= (upperY + heightB)) {
//      fill(255,20,0, tintVal);
    fill (0, 20, 255, tintVal);

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
      
      //println(this.unit);
      upperX = tickX-(xInterval*0.9)/2;
      upperY = zeroY-unit*yData.get(i);
      widthB = xInterval*0.9;
      heightB = unit*yData.get(i);
      if (draw_tool_tips && testToolTip(upperX, upperY, widthB, heightB, tintVal)) {
        tooltip = xData.get(i) + ", " + yData.get(i);
      }
//      tint(255, tintVal);
      //print("rect("); print(upperX); print(", "); print(upperY); print(", "); print(widthB); print(", "); print(heightB); println(");");
      rect(upperX, upperY, widthB, heightB);
      if (drawItems) {
        items.get(i).draw(upperX, upperY, widthB, heightB);
      }

      tickX+= xInterval;
      
    }
    
//    if (tooltip != "") {
//      textSize(15);
//      textAlign(LEFT);
//      float textW = textWidth(tooltip);
//      fill(255);
//      rect(mouseX, mouseY-20, textW*1.1, 20);
//      fill(0);
//      text(tooltip, mouseX+ textW*0.05, mouseY-3);
//      textAlign(CENTER, BOTTOM);
//    }

    textAlign(LEFT, CENTER);
    textSize(15);
  }
}


void ignore0() { }

void step0() {
  rect(100,100,200,200);
}


void ignore1() { }

void step1() {
  rect(50,50,20,30);

}


ArrayList<String> xData;
ArrayList<Integer> yData;

void ignore2() { }

void step2() {
  //triangle(0.1*width, 0.1*height, 0.5*width, 0.2*height, 0.8*width, 0.4*height);
  xData = new ArrayList<String>();
  yData = new ArrayList<Integer>();
  xData.add("First"); xData.add("Second"); xData.add("Third");
  yData.add(2); yData.add(4); yData.add(7);
  BarGraph bgraph = new BarGraph(xData, yData);
  bgraph.draw(0);
}


