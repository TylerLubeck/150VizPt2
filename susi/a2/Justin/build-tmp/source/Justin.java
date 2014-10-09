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

public class Justin extends PApplet {

String data = "Dataset1.csv";
//String data = "Dataset2.csv";

BarGraph barGraph;
LineGraph lineGraph;
LineToBarAnimation lineToBarAnim;
BarToLineAnimation barToLineAnim;
ArrayList<String> labels;
ArrayList<ArrayList<Float>> values;
boolean inTransition, bar, pie, lineG, toPie, toBar, toLine;

public void setup() {
  parseData(data);
  frame.setResizable(true);
  size(600, 400);
  barGraph = new BarGraph(labels, values.get(0));
  lineGraph = new LineGraph(labels, values.get(0));


  lineToBarAnim = new LineToBarAnimation(lineGraph, barGraph);
  barToLineAnim = new BarToLineAnimation(lineGraph, barGraph);

  inTransition = pie = lineG = toPie = toBar = toLine = false;
  bar = true;
  lineG = true;
}

public void draw() {
  background(255, 255, 255);
  if (inTransition){
    if (bar && toLine) {
      // Bar to line animation
      barToLineAnim.draw(255);
    }
    else if (lineG && toBar);
      // Line to Bar animation
      lineToBarAnim.draw(255);
  }
  else if (bar)
    barGraph.draw(255);
  else if (lineG)
    lineGraph.draw(255);
}

public void parseData(String dat) {
  labels = new ArrayList<String>();
  values = new ArrayList<ArrayList<Float>>();
  String file [] = loadStrings(dat);
  String temp [] = splitTokens(file[0], ",");
  for (int i =1; i < temp.length; ++i) {
    values.add(new ArrayList<Float>());
  }
  for (int i = 1; i < file.length; ++i) {
    temp = splitTokens(file[i], ",");
    labels.add(temp[0]);
    for (int j = 1; j < temp.length; ++j) {
      values.get(j-1).add(Float.parseFloat(temp[j]));
    }
  }
}

public void mouseClicked() {
  if (bar) {
    toLine = true;
    toBar = false;
    inTransition = true;
  }
  else if (lineG) {
    // toBar = true;
    // toLine = false;
    // inTransition = true;
  }
}
class BarToLineAnimation {

	LineGraph lineGraph;
	BarGraph  barGraph;

	BarToLineAnimation(LineGraph l, BarGraph b) {
		this.lineGraph = l;
		this.barGraph  = b;
	}

	public void draw(int tintVal) {
		lineGraph.draw(tintVal);
	}

};
class LineToBarAnimation {

	LineGraph lineGraph;
	BarGraph  barGraph;

	LineToBarAnimation(LineGraph l, BarGraph b) {
		this.lineGraph = l;
		this.barGraph  = b;
	}

	public void draw(int tintVal) {
		barGraph.draw(tintVal);
	}

};


class BarGraph extends Graph {
  
  // List of items to be drawn (in place of rects)
  // in order of increasing xData
  ArrayList<Drawable> items;

  BarGraph(ArrayList<String> xData, ArrayList<Float> yData) {
    super(xData, yData);
    this.items = new ArrayList<Drawable>(); // the items to be drawn
  }
  
  public void draw(int tintVal) {
    super.draw();
    drawBars(tintVal);
  }

  public boolean testToolTip(float upperX, float upperY, float widthB, float heightB, int tintVal) {
    if (mouseX >= upperX && mouseX <= (upperX + widthB) && mouseY >= upperY && mouseY <= (upperY + heightB)) {
      fill(255,20,0, tintVal);
      return true;
    }
    fill (0, 20, 255, tintVal);
    return false;
  }
  
  public void drawBars(int tintVal){
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    float tickX = width*0.1f + xInterval;
    float halfTick = height*0.01f;
    float upperX, upperY, widthB, heightB;
    String tooltip = "";
    
    boolean drawItems = (items.size() == xData.size());
    if ((!drawItems) && items.size() > 0) {
      println("Error:    xData.size() =",xData.size()," does not match items.size() =",items.size());
      println("Solution: IGNORING items.");
    }
    
    for (int i = 0; i < xData.size(); ++i) {
      upperX = tickX-(xInterval*0.9f)/2;
      upperY = zeroY-unit*yData.get(i);
      widthB = xInterval*0.9f;
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
      rect(mouseX, mouseY-20, textW*1.1f, 20);
      fill(0);
      text(tooltip, mouseX+ textW*0.05f, mouseY-3);
      textAlign(CENTER, BOTTOM);
    }

    textAlign(LEFT, CENTER);
    textSize(15);
  }
  
  public float getWidth() {
    return width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
  }
};


public interface Drawable {
  public void draw(float x0, float y0, float w, float h);
}



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
      intervalX = ceil((getMaxYValue() - getMinYValue()) / 10.0f);
      //intervalX = ceil((getMaxYValue()-getMinYValue()) / 50.0) * 5;
      lowRange = (abs(floor(getMinYValue())) % intervalX == 0) ? floor(getMinYValue()) : (floor(getMinYValue()) - (intervalX - (abs(floor(getMinYValue())) % intervalX)));
      topRange  = (ceil(getMaxYValue()) % intervalX == 0) ? ceil(getMaxYValue()) : (ceil(getMaxYValue()) + (ceil(getMaxYValue()) % intervalX));
      maxRange = topRange - lowRange;
      }
    else {
      intervalX = ceil(getMaxYValue() / 10.0f);
      //intervalX = ceil(getMaxYValue()/ 50.0) * 5;
      topRange  = (ceil(getMaxYValue()) % intervalX == 0) ? ceil(getMaxYValue()) : (ceil(getMaxYValue()) + (ceil(getMaxYValue()) % intervalX));
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
    textAlign(CENTER, CENTER);
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
 
  
  public float getMaxYValue() {
   int maxIndex = yData.indexOf(Collections.max(yData));
   return yData.get(maxIndex);
  }
  
  public float getMinYValue() {
   int minIndex = yData.indexOf(Collections.min(yData));
   return yData.get(minIndex);
  }
};


class LineGraph extends Graph implements Drawable {
  
  LineGraph(ArrayList<String> xData, ArrayList<Float> yData) {
    super(xData, yData);
  }
  
  public void draw(float x, float y, float w, float h) {
    draw(255);
  }
  
  public void draw(int tintVal) {
    if (tintVal == 255) {
      super.draw();
    }
    drawLines(tintVal);
    drawDots(tintVal);
  }
  
  public boolean testToolTip(float centerX, float centerY, float radius, int tintVal) {
    float distance = sqrt((mouseX - centerX) * (mouseX - centerX) + (mouseY - centerY) * (mouseY - centerY));
    if (distance <= radius) {
      fill(255,20,0, tintVal);
      return true;
    }
    fill (0, 20, 255, tintVal);
    return false;
  }
  
  public void drawDots(int tintVal) {
    float x,y;
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    String tooltip = "";
    x = width*0.1f + xInterval;
    for (int i = 0; i < xData.size(); i++) {
      y = zeroY - unit * yData.get(i);
      if(testToolTip(x,y,0.01f*width, tintVal)) {
        tooltip = xData.get(i) + ", " + yData.get(i);
      }
      ellipse(x,y,0.015f*width,0.015f*width);
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
  
  public void drawLines(int tintVal) {
    float x,y;
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    x = width*0.1f + xInterval;
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
  
  public int getMaxYValue(ArrayList<Integer> yData) {
   int maxIndex = yData.indexOf(Collections.max(yData));
   return yData.get(maxIndex);
  }
  
  public int getMinYValue(ArrayList<Integer> yData) {
   int minIndex = yData.indexOf(Collections.min(yData));
   return yData.get(minIndex);
  }
  
};
// class PieGraph implements Drawable, Cloneable{
//   color[] colors = {
//     color(0, 0, 255), color(0, 255, 0), color(255, 0, 0), color(0, 255, 255), color(255, 0, 255)};
//   color highlight = color(255, 255, 0);
  
//   ArrayList<String> categories;
//   ArrayList<Float> peoplePerCat;
//   ArrayList<Float> angles;
//   int totalNumPeople;
//   String toolTip;
//   boolean lastLevel, pbChange;
//   float centerX, centerY, radius;
//   float pbExplRad, pbSpreadRad, pbSqRad, pbX, pbY, pbSpreadIncrement;
  
//   ArrayList<Float> pbRadii;
//   ArrayList<Float> pbThetas;
  
  
//   PieGraph(ArrayList<String> categories, ArrayList<Float> peoplePerCat, boolean lastLevel) {
//     this.categories = categories;
//     this.peoplePerCat = peoplePerCat;
//     angles = new ArrayList<Float>();
//     calcTotalNum();
//     calcAngles();
//     toolTip = "";
//     this.lastLevel = lastLevel;
//     pbExplRad = 0;
//     pbChange = false;
//   }
  
//   String getSelectedCategory() {
//     float currentAngle = 270;
//     for (int i = 0; i < angles.size(); ++i) {
//       if(testIntersect(centerX, centerY, radius, (currentAngle - angles.get(i)), currentAngle)) {
//         return categories.get(i);
//       }
//       currentAngle -= angles.get(i);
//     }
//     return "";
//   }
  
//   void calcTotalNum() {
//     totalNumPeople = 0;
//     for (int i=0; i<peoplePerCat.size(); ++i) {
//       totalNumPeople += peoplePerCat.get(i);
//     }
//   }
  
//   void calcAngles() {
//     for (int i = 0; i<peoplePerCat.size(); ++i) {
//       angles.add(((float)peoplePerCat.get(i) / (float)totalNumPeople) * 360.0);
//     }
//   }
  
//   void draw(float x, float y, float w, float h) {
//     draw((x + w)/2.0, (y + h)/2.0, w < h ? 0.9*(w/2) : 0.9*(h/2));
//   }

//   void draw(float centerX, float centerY, float radius) {
//     this.centerX = centerX;
//     this.centerY = centerY;
//     this.radius = radius;
//     float currentAngle = 270;
//     toolTip = "";
//     int colorIndex = 0;
//     for (int i =0; i < angles.size(); ++i) {
//       if(testIntersect(centerX, centerY, radius, (currentAngle - angles.get(i)), currentAngle)) {
//         fill(highlight);
//         toolTip = categories.get(i) + " - " + peoplePerCat.get(i);
//       }
//       else {
//         fill(colors[colorIndex]);
//       }
//       arc(centerX, centerY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
//       currentAngle -= angles.get(i);
//       colorIndex = (colorIndex + 1) % colors.length;
//     }
//     if (toolTip != "") {
//       if (! lastLevel)
//         toolTip += "\nClick for more information";
//       textSize(15);
//       textAlign(LEFT);
//       float textW = textWidth(toolTip);
//       fill(255);
//       rect(mouseX, mouseY-40, textW*1.1, 45);
//       fill(0);
//       text(toolTip, mouseX+ textW*0.05, mouseY-23);
//       textAlign(CENTER, BOTTOM);
//     }
//   }
  
//   boolean testIntersect(float centerX, float centerY, float radius, float lowerAngle, float upperAngle) {
//     float distance = sqrt((mouseX - centerX) * (mouseX - centerX) + (mouseY - centerY) * (mouseY - centerY));
//     if (distance > radius) 
//       return false;
//     float mouseAngle = degrees(atan2((mouseY - centerY),(mouseX - centerX)));
//     if (mouseAngle < 0) 
//       mouseAngle += 360.0;
//     if (lowerAngle < 0 && upperAngle < 0) {
//       lowerAngle += 360;
//       upperAngle += 360;
//     }
//     else if (lowerAngle < 0) {
//       lowerAngle += 360;
//       if (lowerAngle > upperAngle)
//         return (! (upperAngle < mouseAngle && mouseAngle < lowerAngle));
//     }
//     return (lowerAngle < mouseAngle && mouseAngle < upperAngle);
//   }
  
//   void pbTransform(float centerX, float centerY, float radius, float barWidth) {
//     this.centerX = centerX;
//     this.centerY = centerY;
//     this.radius = radius;
    
//     if (pbExplRad  < radius /2) {
//       explode();
//       pbSpreadRad = pbExplRad;
//       pbSpreadIncrement = (radius * 1.2 - pbExplRad)/ (log((100 * radius)/ pbExplRad) / log(1.01));
//     }
//     else if (pbSpreadRad <= 100 *radius){
//       spread();
//       pbSqRad = pbSpreadRad;
//       pbSqStartCond();
//     }
//     else
//       squarify(barWidth);
//   }
    
//   void explode() {
//     float currentAngle = 270;
//     int colorIndex = 0;
//     float transX, transY;
//     for (int i =0; i < angles.size(); ++i) {
//       fill(colors[colorIndex]);
//       transX = centerX + pbExplRad * cos(radians(currentAngle - angles.get(i)/2));
//       transY = centerY + pbExplRad * sin(radians(currentAngle - angles.get(i)/2));
//       arc(transX, transY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
//       currentAngle -= angles.get(i);
//       colorIndex = (colorIndex + 1) % colors.length;
//     }
//     if (pbExplRad < radius/2)
//         pbExplRad += 0.5;
//   }  
  
//   void spread() {
//     float currentAngle = 270;
//     int colorIndex = 0;
//     float transX, transY, tempAngle;
//     for (int i =0; i < angles.size(); ++i) {
//       fill(colors[colorIndex]);
//       tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
//       transX = centerX + pbSpreadRad * cos(tempAngle);
//       transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
//       arc(transX, transY, 2*radius, 2*radius, (tempAngle - radians(angles.get(i)/2)), (tempAngle + radians(angles.get(i)/2)),  PIE);
//       currentAngle -= angles.get(i);
//       colorIndex = (colorIndex + 1) % colors.length;
//     } 
//     if (pbSpreadRad < 100 *radius){
//         pbSpreadRad *= 1.01;
//         if (pbExplRad < radius * 1.3)
//           pbExplRad += pbSpreadIncrement;
//     }
//   }
  
//   void pbSqStartCond() {
//     pbRadii = new ArrayList<Float>();
//     pbX = new ArrayList<Float>();
//     pbY = new ArrayList<Float>();
//     float currentAngle = 270;
//     for (int i = 0; i < angles.size(); ++i) {
//       pbRadii.add(radius);
//       tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
//       transX = centerX + pbSpreadRad * cos(tempAngle);
//       transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
//       pbX.add(transX);
//       pbY.add(transY);
//       currentAngle -= angles.get(i);

//     }  
//     pbThetas = (ArrayList<Float>)angles.clone();
//   }
  
//   void squarify(float barWidth) {
//     pbChange = false;
//     float currentAngle = 270;
//     int colorIndex = 0;
//     float transX, transY, tempAngle;
//     for (int i =0; i < angles.size(); ++i) {
//       fill(colors[colorIndex]);
//       if (pbThetas.get(i) * pbRadii.get(i) < barWidth) {
//          pbChange = true; 
//       }
//       tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
//       transX = centerX + pbSpreadRad * cos(tempAngle);
//       transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
//       arc(transX, transY, 2*radius, 2*radius, (tempAngle - radians(angles.get(i)/2)), (tempAngle + radians(angles.get(i)/2)),  PIE);
//       currentAngle -= angles.get(i);
//       colorIndex = (colorIndex + 1) % colors.length;
//     } 
//     if (pbSpreadRad < 100 *radius){
//         pbSpreadRad *= 1.01;
//         if (pbExplRad < radius * 1.3)
//           pbExplRad += pbSpreadIncrement;
//     }
    
//   }
    
// }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Justin" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
