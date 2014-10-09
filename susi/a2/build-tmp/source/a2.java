import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Collections; 
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

public class a2 extends PApplet {

String data = "Dataset1.csv";
//String data = "Dataset2.csv";

/* Graphs objects */
PieGraph pieGraph;
BarGraph barGraph;
LineGraph lineGraph;
RoseChart roseChart;
StackedBar stackedBar;

/* Animation objects / state information */
PieToBar pieToBar;
BarToPie barToPie;
PieToLine pieToLine;
LineToPie lineToPie;
BarToLine barToLine;
LineToBar lineToBar;
PieToRose pieToRose;
RoseToPie roseToPie;
BarToStacked barToStacked;
StackedToBar stackedToBar;
boolean inTransition, inExtTrans, bar, pie, line, rose, stacked, toPie, toBar, toLine, toRose, toStacked;

/* Transitioning buttons: */
float buttonWidthP = 0.08f;
float buttonHeightP = 0.06f;
Button pieButton = new  Button(0.90f, 0.02f, buttonWidthP, buttonHeightP, "Pie");
Button barButton = new  Button(0.90f, 0.10f, buttonWidthP, buttonHeightP, "Bar");
Button lineButton = new Button(0.90f, 0.18f, buttonWidthP, buttonHeightP, "Line");
Button roseButton = new Button(0.90f, 0.26f, buttonWidthP, buttonHeightP, "Rose");
Button stackedButton = new Button(0.90f, 0.34f, buttonWidthP, buttonHeightP, "Stacked\nBar");
ArrayList<Button> buttons = new ArrayList<Button>();

/* Data lists */
ArrayList<String> labels;
ArrayList<ArrayList<Float>> values;


public void setup() {
  parseData(data);
  frame.setResizable(true);
  size(800, 600);

  /* Initialize graphs */
  pieGraph = new PieGraph(labels, values.get(0), true);
  barGraph = new BarGraph(labels, values.get(0));
  lineGraph = new LineGraph(labels, values.get(0));
  roseChart = new RoseChart(labels, values);
  stackedBar = new StackedBar(labels, values);
  /* Initialize animations */
  pieToBar = new PieToBar(pieGraph, barGraph);
  barToPie = new BarToPie(pieGraph, barGraph);
  lineToPie = new LineToPie(lineGraph, pieGraph);
  pieToLine = new PieToLine(pieGraph, lineGraph);
  barToLine = new BarToLine(barGraph, lineGraph);
  lineToBar = new LineToBar(lineGraph, barGraph);
  pieToRose = new PieToRose(pieGraph, roseChart);
  roseToPie = new RoseToPie(pieGraph, roseChart);
  barToStacked = new BarToStacked(barGraph, stackedBar);
  stackedToBar = new StackedToBar(barGraph, stackedBar);

  inTransition = bar = pie = rose =line = stacked = toPie = toBar = toLine = toRose = toStacked = false;
  bar = true;

  buttons.add(pieButton);
  buttons.add(barButton);
  buttons.add(lineButton);
  buttons.add(roseButton);
  buttons.add(stackedButton);
}

public void draw() {
  background(255, 255, 255);
  if (inExtTrans) {
    inTransition = true;
    inExtTrans = false;
  }
  if (toRose && !pie) {
    toPie = true;
    inExtTrans = true;
  }
  else if (rose && (toBar || toLine || toStacked)) {
    toPie = true;
    inExtTrans = true;
  }
  if (toStacked && ! bar){
    toBar = true;
    inExtTrans = true;
  }
  else if (stacked && (toLine || toPie || toRose)) {
    toBar = true;
    inExtTrans = true;
  }
  if (inTransition){
    if (pie && toBar)
      pieToBar.pbTransform(width/2, height/2, height/6, barGraph.getWidth());
    else if (bar && toPie)
      barToPie.bpTransform(width/2, height/2, height/6, barGraph.getWidth());
    else if (pie && toLine)
      pieToLine.draw();
    else if (line && toPie)
      lineToPie.draw();
    else if (bar && toLine) 
      barToLine.draw();
    else if (line && toBar)
      lineToBar.draw();
    else if (pie && toRose)
      pieToRose.draw(width/2, height/2, height/6, height/3);
    else if (rose && toPie)
      roseToPie.draw(width/2, height/2, height/6, height/3);
    else if (bar && toStacked)
      barToStacked.draw();
    else if (stacked && toBar) 
      stackedToBar.draw();
  }
  else if (pie)
    pieGraph.draw(width/2, height/2, height/6);
  else if (bar)
    barGraph.draw(255);
  else if (line)
    lineGraph.draw(255);
  else if (rose)
    roseChart.draw(width/2, height/2, height/3);
  else if (stacked)
    stackedBar.draw(255);

  /* Draw buttons */
  pieButton.draw();
  barButton.draw();
  lineButton.draw();
  roseButton.draw();
  stackedButton.draw();
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

public void mousePressed() {
  for (int i = 0; i < buttons.size(); i++)
    if (buttons.get(i).mousePressed(mouseX,mouseY))
      break;
}

public void mouseReleased() {
  for (int i = 0; i < buttons.size(); i++)
    buttons.get(i).mouseReleased();
}

public void mouseClicked() {
  if (! inTransition) {
    if (pieButton.contains(mouseX, mouseY)) {
      inTransition = toPie = !pie;
    } else if (barButton.contains(mouseX, mouseY)) {
      inTransition = toBar = !bar;
    } else if (lineButton.contains(mouseX, mouseY)) {
      inTransition = toLine = !line;
    } else if (roseButton.contains(mouseX, mouseY)) {
      inTransition = toRose = !rose;
    } else if (stackedButton.contains(mouseX, mouseY)) {
      inTransition = toStacked = !stacked;
    }
  }
}


abstract class Animation extends Drawable {
  float progress; /* Fraction on [0,1], representing the progress of the animation */
  float progressInterval; /* Amount to increase progress by after each draw() */
  
  Animation() {
    this.progress = 0;
    this.progressInterval = 0.001f;
  }

}


class LineToPie extends Animation {
  
  LineGraph toGraph;
  PieGraph fromGraph;

  LineToPie(LineGraph lGraph, PieGraph pGraph) {
    this.fromGraph = pGraph;
    this.toGraph = lGraph;
    this.progressInterval = 0.005f;
    this.progress = 1.6f;
  }

  public void drawTransition(float x, float y, float w, float h) {
    float centerX = (x + w)/2.0f;
    float centerY = (y + h)/2.0f;
    float radius = (w < h ? 0.9f*(w/2) : 0.9f*(h/2)) * 0.73f;
    float radiusOrig = radius;
    float currAngle = radians(270.0f); //0.75*2*PI;
    float barAngle = 0.0f;
    float xInterval = width*0.8f / (PApplet.parseFloat(toGraph.xData.size()) + 1.0f);
    pushMatrix();
    translate(centerX,centerY);
    for (int i = 0; i < toGraph.xData.size(); i++) {
      barAngle = radians(fromGraph.angles.get(i) % 360);
      fill(fromGraph.colors[i % fromGraph.colors.length]);
      float centerXA = 50 * progress * cos(currAngle);
      float centerYA = 50 * progress * sin(currAngle);
      if (progress < 0.5f) {
        stroke(0);
        //pushMatrix();
        //rotate((progressInterval * i) * PI);
        arc(centerXA, centerYA, radius, radius, currAngle - barAngle, currAngle, PIE);
        //popMatrix();
      } else {
        pushMatrix();
        translate(0-centerX, 0-centerY);
        float prog2 = (progress - 0.5f) * 2;
        float newX = lerp(centerXA + centerX, width*0.1f + xInterval*(i+1), prog2);
        toGraph.unit = (height*0.75f  /(toGraph.maxRange))/1.1f;
        tint(1.0f); toGraph.drawAxis(); tint(0.0f);
        float lineGraphYValue = toGraph.zeroY - toGraph.unit * toGraph.yData.get(i);
        float newY = lerp(centerYA + centerY, lineGraphYValue, prog2);
        //if (i == 23) println(lineGraphYValue,newY);
        stroke(0);
        radius = radiusOrig * (1.10f - prog2);

        arc(newX, newY, radius, radius, currAngle - barAngle, currAngle, PIE);
        popMatrix();
      }
      currAngle -= barAngle;
    }
    popMatrix();
  }

  public void fadeOutLineGraph() {
    toGraph.draw(255 - (int)(50 + (1.6f - progress) / 0.6f * 200));
  }

  public void draw(float x, float y, float w, float h) {
    //println(this.progress);

    float progressBak = progress;
    if (progress >= 1.0f) progress = 1.0f;
    //if (progress < 1.0)
    drawTransition(x,y,w,h);
    progress = progressBak;
    if (progress > 0.9f) fadeOutLineGraph();

    if ((progress -= progressInterval) <= 0.0f) {
      inTransition = false; toPie = false;
      line = false; pie = true;
      progress = 1.6f;
    }
  }

}


class PieToLine extends Animation {
  
  PieGraph fromGraph;
  LineGraph toGraph;

  PieToLine(PieGraph pGraph, LineGraph lGraph) {
    this.fromGraph = pGraph;
    this.toGraph = lGraph;
    this.progressInterval = 0.005f;
  }

  public void drawTransition(float x, float y, float w, float h) {
    float centerX = (x + w)/2.0f;
    float centerY = (y + h)/2.0f;
    float radius = (w < h ? 0.9f*(w/2) : 0.9f*(h/2)) * 0.73f;
    float radiusOrig = radius;
    float currAngle = radians(270.0f); //0.75*2*PI;
    float barAngle = 0.0f;
    float xInterval = width*0.8f / (PApplet.parseFloat(toGraph.xData.size()) + 1.0f);
    pushMatrix();
    translate(centerX,centerY);
    for (int i = 0; i < toGraph.xData.size(); i++) {
      barAngle = radians(fromGraph.angles.get(i) % 360);
      fill(fromGraph.colors[i % fromGraph.colors.length]);
      float centerXA = 50 * progress * cos(currAngle);
      float centerYA = 50 * progress * sin(currAngle);
      if (progress < 0.5f) {
        stroke(0);
        //pushMatrix();
        //rotate((progressInterval * i) * PI);
        arc(centerXA, centerYA, radius, radius, currAngle - barAngle, currAngle, PIE);
        //popMatrix();
      } else {
        pushMatrix();
        translate(0-centerX, 0-centerY);
        float prog2 = (progress - 0.5f) * 2;
        float newX = lerp(centerXA + centerX, width*0.1f + xInterval*(i+1), prog2);
        toGraph.unit = (height*0.75f  /(toGraph.maxRange))/1.1f;
        tint(1.0f); toGraph.drawAxis(); tint(0.0f);
        float lineGraphYValue = toGraph.zeroY - toGraph.unit * toGraph.yData.get(i);
        float newY = lerp(centerYA + centerY, lineGraphYValue, prog2);
        //if (i == 23) println(lineGraphYValue,newY);
        stroke(0);
        radius = radiusOrig * (1.10f - prog2);

        arc(newX, newY, radius, radius, currAngle - barAngle, currAngle, PIE);
        popMatrix();
      }
      currAngle -= barAngle;
    }
    popMatrix();
  }

  public void fadeInLineGraph() {
    toGraph.draw(255 - (int)(50 + (1.6f - progress) / 0.6f * 200));
  }

  public void draw(float x, float y, float w, float h) {
    //println(this.progress);

    float progressBak = progress;
    if (progress >= 1.0f) progress = 1.0f;
    //if (progress < 1.0)
    drawTransition(x,y,w,h);
    progress = progressBak;
    if (progress > 0.9f) fadeInLineGraph();
    
    if ((progress += progressInterval) >= 1.6f) {
      inTransition = false; toLine = false;
      pie = false; line = true; 
      progress = 0.0f;
    }
  }

}



class BarGraph extends Graph {
  
  // List of items to be drawn (in place of rects)
  // in order of increasing xData
  ArrayList<Drawable> items;

  BarGraph(ArrayList<String> xData, ArrayList<Float> yData) {
    super(xData, yData);
    this.items = new ArrayList<Drawable>(); // the items to be drawn
  }
  
  public void draw(float x, float y, float w, float h) { this.draw(0); }

  public void draw(int tintVal) {
    super.draw(0,0,width,height);
    drawBars(tintVal);
  }

  public boolean testToolTip(float upperX, float upperY, float widthB, float heightB, int tintVal) {
    if (mouseX >= upperX && mouseX <= (upperX + widthB) && mouseY >= upperY && mouseY <= (upperY + heightB)) {
      fill(230,230,161, tintVal);
      return true;
    }
    fill (255, 255, 179, tintVal);
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
    return width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f) * 0.9f;
  }
};

class BarToLine extends Animation {

	BarGraph  fromGraph;
	LineGraph toGraph;
	float barWidth, fadeProg;
	float xInterval, xPos, yPos;
	boolean isFinished, reduceBarsFinished;

	BarToLine(BarGraph b, LineGraph l) {
		this.fromGraph = b;
		this.toGraph  = l;
		this.progressInterval = 0.01f;
		this.xInterval = width*0.8f / (PApplet.parseFloat(this.toGraph.xData.size()) + 1.0f);
		this.barWidth = this.xInterval*0.9f;
		this.isFinished = false;
		this.reduceBarsFinished = false;
		this.fadeProg = 0.0f;
	}

	public void draw(float x, float y, float w, float h) {
		this.xInterval = width*0.8f / (PApplet.parseFloat(this.toGraph.xData.size()) + 1.0f);
    
		animate(x,y,w,h);

		if (isFinished) {
			fadeLineIn();
			if (fadeProg >= 1) {
				inTransition = false;
				bar = false;
				line = true;
                                toLine = false;
				progress = 0.0f;
				barWidth = xInterval*0.9f;
				isFinished = false;
				reduceBarsFinished = false;
				fadeProg = 0.0f;
			}
		}
		progress += progressInterval;
	}

	public void animate(float x, float y, float w, float h) {
		float tickX = width*0.1f + xInterval;
		float widthB = xInterval*0.9f;
		float heightB, upperX, upperY, newWidth;
		float prevX = tickX;
		float prevY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(0);
		
		if (!isFinished) {
			for (int i=0; i<toGraph.xData.size(); i++) {
				upperX = tickX-(xInterval*0.9f)/2;
	      		upperY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(i);
				heightB = fromGraph.unit * fromGraph.yData.get(i);


				float x1 = upperX+widthB/2;
				float y1 = upperY;
				float x2 = x1;
				float y2 = y1 + heightB;
				float newY = y2 - (lerp(y1, y2, progress) - y2);
				float dotWidth = 0.015f*width;
				float dotInterval = lerp(0, dotWidth, progress);
				float dot = dotWidth - dotInterval;

				if (!reduceBarsFinished) {
					if (barWidth > 1.0f) {
						float newUpperX = lerp(upperX, upperX + widthB/2, progress);
						newWidth = lerp(0, widthB, progress);
						barWidth = widthB - newWidth;
						fill(255,255,179);
						rect(newUpperX, upperY, barWidth, heightB);
					} else {

						if (newY >= y1) {
							line(x1, y1, x2, newY);
							fill(255,255,179);
							ellipse(x1, y1, dot, dot);
						} else {
							reduceBarsFinished = true;
							progress = 0.0f;
						}
					}
				} else {
		  			newY = lerp(prevY, y1, progress);
		  			float newX = lerp(prevX, x1, progress);
		  			if (newX <= x1) {
						line(prevX, prevY, newX, newY);
						prevX = x1;
						prevY = y1;	
		  			} else {
		  				isFinished = true;
		  			}

					fill(255,255,179);
					ellipse(x1, y1, dotWidth, dotWidth);
				}


				tickX+= xInterval;
			}
		}

	}

	public void fadeLineIn() {
		fadeProg += 0.01f;
		toGraph.setTint(PApplet.parseInt(lerp(0,255,fadeProg)));
		fill(0, PApplet.parseInt(lerp(0,255,fadeProg)));
		toGraph.drawAxis();
		toGraph.drawYTicks();
		toGraph.drawXTicks();
		toGraph.drawXLabels();	
		toGraph.drawDots(255);
		toGraph.drawLines(255);
	}

};





class BarToPie implements  Cloneable {
  BarGraph barGraph;
  PieGraph pieGraph;
  int[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
  boolean bpShrinkChange, bpSqChange, bpMoved;
  float centerX, centerY, radius, bpExplRad, bpSpreadRad, bpSqRad, bpSpreadIncrement, progress, fadeProg;
  ArrayList<Float> angles, bpRadii, bpThetas, bpX, bpX1, bpX2, bpY, bpY1, bpY2, bpW1, bpW2, bpBarArea; 
  
  BarToPie(PieGraph pie, BarGraph bar) {
    this.pieGraph = pie;
    this.barGraph = bar;
    bpSetup();
  }
  
  public void bpSetup() {
    this.angles = (ArrayList<Float>)pieGraph.angles.clone();
    bpExplRad = progress = fadeProg = 0;
    bpShrinkChange = bpSqChange = true;
    bpMoved = false;
    getXYW(barGraph.getWidth());
  }
  
  public void bpTransform(float centerX, float centerY, float radius, float barWidth) {
    getXYW(barGraph.getWidth());
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    if (fadeProg < 1) {
      fadeBarOut(barWidth); 
      if (fadeProg >= 1)
        bpSqStartCond(barWidth);
    }
    else if (bpSqChange) {
      moveRect(barWidth);
      if (! bpSqChange)
        progress = 0;
    }
    else if (bpShrinkChange) {
      shrink(barWidth);
      if (! bpShrinkChange) {
        progress = 0;
      }
    }
    else if (bpSpreadRad > radius/2){
      consolidate();
      if (bpSpreadRad > radius/2) {
        progress = 0;
      }
    }
    
    else if (bpExplRad  > 0) {
      implode();
      if (bpExplRad < 0.00000001f) {
        inTransition = false;
        bar = false;
        pie = true;    
        toPie = false;  
        bpSetup();
        barGraph.setTint(255);
      }
    }
  }
    
    
  public void getXYW(float barWidth) {
    float xInterval = width*0.8f / (PApplet.parseFloat(angles.size()) + 1.0f);
    float tickX = width*0.1f + xInterval;
    float unit = barGraph.getUnit();
    float zeroY = height*0.85f + barGraph.lowRange*unit;
    bpX = new ArrayList<Float>();
    bpY = new ArrayList<Float>();
    bpBarArea = new ArrayList<Float>();
    for (int i = 0; i < angles.size(); ++i) {
      bpX.add(tickX);
      bpY.add(zeroY-unit*barGraph.yData.get(i));
      bpBarArea.add(barGraph.getUnit() * barWidth * barGraph.yData.get(i));
      tickX+= xInterval;
   }
  }
  
  public void fadeBarOut(float barWidth) {
    fadeProg += 0.1f;
    barGraph.setTint(PApplet.parseInt(lerp(255, 0, fadeProg)));
    fill(0, PApplet.parseInt(lerp(255, 0, fadeProg)));
    barGraph.drawAxis();
    barGraph.drawYTicks();
    barGraph.drawXTicks();
    barGraph.drawXLabels();
    for (int i = 0; i < angles.size(); ++i) {
      fill(255,255,179);
      rect(bpX.get(i) - barWidth/2, bpY.get(i), barWidth, bpBarArea.get(i) / barWidth);
    }
  }
  
  public void bpSqStartCond(float barWidth) {
    bpRadii = new ArrayList<Float>();
    bpThetas = new ArrayList<Float>();
    bpX1 = new ArrayList<Float>();
    bpY1 = new ArrayList<Float>();
    bpX2 = new ArrayList<Float>();
    bpY2 = new ArrayList<Float>();
    bpW1 = new ArrayList<Float>();
    bpW2 = new ArrayList<Float>();
    float currentAngle = 270;
    bpSpreadIncrement = (radius * 1.2f - radius/2)/ (log((100 * radius)/ (radius/2)) / log(1.03f));
    bpSpreadRad = bpExplRad = radius/2;
    
    while (bpSpreadRad <= 100 * radius) {
      bpSpreadRad *= 1.03f;
      bpExplRad += bpSpreadIncrement;
    }
    
    float transX, transY, tempAngle, finalAngle;
    for (int i = 0; i < angles.size(); ++i) {
      finalAngle = (angles.get(i) > degrees(2*barWidth * barWidth / bpBarArea.get(i)) ? 
              degrees(2*barWidth * barWidth / bpBarArea.get(i)) : angles.get(i));
      bpRadii.add(sqrt(2 * bpBarArea.get(i)/radians(finalAngle)));
      bpThetas.add(finalAngle);
      tempAngle = PI/2 + bpExplRad / bpSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
      transX = centerX + bpSpreadRad * cos(tempAngle);
      transY = centerY + bpSpreadRad * sin(tempAngle) - (bpSpreadRad - bpExplRad);
      bpX1.add(transX);
      bpY1.add(transY + (radius - bpRadii.get(i)));
      bpW1.add(0.0f);
      bpX2.add(bpX1.get(i) + bpRadii.get(i) * cos(HALF_PI + radians(bpThetas.get(i)/2)));
      bpY2.add(bpY1.get(i) + bpRadii.get(i) * sin(HALF_PI + radians(bpThetas.get(i)/2)));
      bpW2.add(radians(bpThetas.get(i)) * bpRadii.get(i));
      currentAngle -= angles.get(i);
    }  
    bpThetas = (ArrayList<Float>)angles.clone();
  }
  
  
  public void moveRect(float barWidth) {
  bpSqChange = false;
  int colorIndex = 0;
  float x1, x2, y1, y2, w1, w2;
  for (int i =0; i < angles.size(); ++i) {
    progress += 0.0005f;
    int c = lerpColor(color(255,255,179), colors[colorIndex], progress);
    fill(c);
    x1 = lerp(bpX.get(i), bpX1.get(i), progress);
    w1 = lerp(barWidth, bpW1.get(i), progress);
    x2 = lerp(bpX.get(i) - barWidth/2, bpX2.get(i), progress);
    w2 = lerp(barWidth, bpW2.get(i), progress);
    y1 = lerp(bpY.get(i), bpY1.get(i), progress);
    y2 = lerp((bpY.get(i) + bpBarArea.get(i) / barWidth), bpY2.get(i), progress);
    
    quad(x1-w1 /2, y1, x1 + w1 /2, y1, x2 + w2, y2, x2,y2);   
    colorIndex = (colorIndex + 1) % colors.length;
    if (progress < 1)
      bpSqChange = true;
   }
 }
 
 public void shrink(float barWidth) {
    bpShrinkChange = false;
    int colorIndex = 0;
    float finalAngle;
    for (int i =0; i < angles.size(); ++i) {
      progress += 0.0005f;
      finalAngle = (angles.get(i) > degrees(2*barWidth * barWidth / bpBarArea.get(i)) ? 
              degrees(2*barWidth * barWidth / bpBarArea.get(i)) : angles.get(i));
      fill(colors[colorIndex]);
      bpY1.set(i, (bpY1.get(i) + (bpRadii.get(i) - lerp(sqrt(2 * bpBarArea.get(i)/radians(finalAngle)), radius, progress))));
      bpRadii.set(i, lerp(sqrt(2 * bpBarArea.get(i)/radians(finalAngle)), radius, progress));
        bpThetas.set(i, lerp(finalAngle, angles.get(i), progress));
        if (progress < 1)
          bpShrinkChange = true;
      arc(bpX1.get(i), bpY1.get(i), 2*bpRadii.get(i), 2*bpRadii.get(i), (HALF_PI - radians(bpThetas.get(i)/2)), (HALF_PI + radians(bpThetas.get(i)/2)),  PIE);
      colorIndex = (colorIndex + 1) % colors.length;
    } 
  }
 
 public void consolidate() {
    float currentAngle = 270;
    int colorIndex = 0;
    float transX, transY, tempAngle;
    for (int i =0; i < angles.size(); ++i) {
      fill(colors[colorIndex]);
      tempAngle = PI/2 + bpExplRad / bpSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
      transX = centerX + bpSpreadRad * cos(tempAngle);
      transY = centerY + bpSpreadRad * sin(tempAngle) - (bpSpreadRad - bpExplRad);
      arc(transX, transY, 2*radius, 2*radius, (tempAngle - radians(angles.get(i)/2)), (tempAngle + radians(angles.get(i)/2)),  PIE);
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    } 
    if (bpSpreadRad >radius/2){
        bpSpreadRad /= 1.03f;
        bpExplRad -= bpSpreadIncrement;
    }
  }
  
  
  public void implode() {
    float currentAngle = 270;
    int colorIndex = 0;
    float transX, transY;
    for (int i =0; i < angles.size(); ++i) {
      progress += 0.001f;
      bpExplRad = lerp(radius/2, 0, progress);
      fill(colors[colorIndex]);
      transX = centerX + bpExplRad * cos(radians(currentAngle - angles.get(i)/2));
      transY = centerY + bpExplRad * sin(radians(currentAngle - angles.get(i)/2));
      arc(transX, transY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    }
  }    
}

class BarToStacked {
  int[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
   
  BarGraph barG;
  StackedBar stackedG;
  float unit, maxValue, zeroY, longestIndex, progress;
  boolean shrinking;
  int tintValue;
  
  BarToStacked(BarGraph barGraph, StackedBar stackedBar) {
    this.barG = barGraph;
    this.stackedG = stackedBar;
    zeroY = height*0.85f;
    bsSetup();
  }
  
  public void bsSetup() {
   progress = 0;
   shrinking = true; 
   tintValue = 255;
  }
  
  public void draw() {
   if(shrinking) {
    shrink();
    if(!shrinking)
      progress = 0;
   }
   else if (progress < 1) {
     fadeIn();
     if(progress >= 1) {
        inTransition = false;
        bar = false;
        stacked = true;
        toStacked = false;
        bsSetup();
   }
  } 
 }
  
  public void shrink() {
    shrinking = false;
    progress += 0.005f;    
    float upperX, upperY, heightB;
    int maxRange = (ceil(stackedG.maxValue) % stackedG.graph.intervalX == 0 ? 
        ceil(stackedG.maxValue) : (ceil(stackedG.maxValue) + (ceil(stackedG.maxValue) % stackedG.graph.intervalX)));
    float tempMax = lerp(barG.getMaxYValue(), maxRange, progress);
    tempMax = tempMax > stackedG.maxValue ? stackedG.maxValue : tempMax;
    float xInterval = width * 0.8f / (PApplet.parseFloat(labels.size()) + 1.0f);
    float tickX = width * 0.1f + xInterval;

    float widthB = barG.getWidth();
    float interval = tempMax / 10.0f;
    float tempUnit = (height*.75f / tempMax) / 1.1f;
    barG.drawAxis();
    barG.drawXTicks();
    barG.drawXLabels();
    for (int i = 0; i < labels.size(); ++i) {
      fill(lerpColor(color(255,255,179), colors[1], progress));
      upperX = tickX-(xInterval*0.9f)/2;
      upperY = zeroY-tempUnit*barG.yData.get(i);
      heightB = tempUnit*barG.yData.get(i);
      rect(upperX, upperY, widthB, heightB);
      tickX+= xInterval;
    }
    textAlign(CENTER, CENTER);
    float halfTick = width * 0.01f;
    for (int i = 0; i*interval *tempUnit < height * 0.74f; i++) {
      line(width*0.1f- halfTick, barG.zeroY-tempUnit*i*interval, width*0.1f+halfTick, barG.zeroY-tempUnit*i*interval);
      fill(0,0,0, tintValue);
      textSize(12);
      text(i*interval, width*0.05f, zeroY-tempUnit*i*interval);
    }
    if (progress < 1)
      shrinking = true;
  }

  
  public void fadeIn() {
   progress += 0.005f;
   int tintVal = PApplet.parseInt(lerp(0, 255, progress));
   stackedG.setTint(tintVal);
   stackedG.draw(tintVal);
 
  }

  
}
  


class Button extends Drawable {

  /* Percentages of screen width instead of absolute locations */
  float xP;
  float yP;
  float wP;
  float hP;
  String txt;
  boolean pressed; /* whether or not the mouse is currently pressed on this button */

  Button(float xP, float yP, float wP, float hP, String txt) {
    this.xP = xP; this.yP = yP;
    this.wP = wP; this.hP = hP;
    this.txt = txt;
  }

  public void draw(float x, float y, float w, float h) {
    //print(x); print(" "); print(y); print(" "); print(w); print(" "); println(h);
    if (pressed) fill(250);
    else fill(150);
    rect(xP*width,yP*height,wP*width,hP*height);
    fill(0);
    textSize(12);
    textAlign(LEFT, TOP);
    text(txt, 1.01f*xP*width, yP*height);
  }

  public boolean contains(int xM, int yM) {
    //println(xM,x,x+w,yM,y,y+h,curr);
    boolean withinX = (xM > xP*width)  && (xM < (xP + wP)*width);
    boolean withinY = (yM > yP*height) && (yM < (yP + hP)*height);
    return withinX && withinY;
  }

  public boolean mousePressed(int xM, int yM) { return (pressed = contains(xM,yM)); }
  public void mouseReleased() { pressed = false; }

}

public abstract class Drawable {
  public abstract void draw(float x0, float y0, float w, float h); /* Draw this drawable thing */
  /* Whether or not this drawable things "contains" the mouse */
  public boolean contains(int xM, int yM) { return false; }
  public void draw() { this.draw(0,0,width,height); } /* Default to drawing on entire screen */
}



class Graph extends Drawable {
  
  ArrayList<String> xData;
  ArrayList<Float> yData;
  float unit;
  float zeroY;
  int longestIndex;
  int maxRange, topRange, lowRange;
  int intervalX;
  boolean isDragged;
  int tintValue;
  
  Graph(ArrayList<String> xData, ArrayList<Float> yData) {
    this.xData = xData;
    this.yData = yData;
    longestIndex = getLongestXValueIndex();
    tintValue = 255;
    if (getMinYValue() < 0) {
      intervalX = ceil((getMaxYValue() - getMinYValue()) / 10.0f);
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
    if (getMinYValue()<0) {
      unit = (height*0.75f  /(maxRange))/1.1f;
      zeroY = height*0.85f + lowRange*unit;
    }
    else {
      unit = (height*0.75f / (maxRange))/1.1f;
      zeroY = height*0.85f;
    }
  }
  public void setTint(int tint) {
    tintValue = tint;
  }
  
  public void draw(float x, float y, float w, float h) {
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
      fill(0, tintValue);
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
    for (int i = lowRange; i*unit < height * 0.74f; i+= intervalX) {
      line(width*0.1f- halfTick, zeroY-unit*i, width*0.1f+halfTick, zeroY-unit*i);
      fill(0,0,0, tintValue);
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
  
  public float getUnit() {
    return (height*0.75f  /(maxRange))/1.1f;
  }
}



class LineGraph extends Graph {
  
  LineGraph(ArrayList<String> xData, ArrayList<Float> yData) {
    super(xData, yData);
  }
  
  public void draw(float x, float y, float w, float h) {
    this.draw(255);
  }
  
  public void draw(int tintVal) {
    if (tintVal == 255) {
      super.draw(0,0,width,height);
    }
    drawLines(tintVal);
    drawDots(tintVal);
  }
  
  public boolean testToolTip(float centerX, float centerY, float radius, int tintVal) {
    float distance = sqrt((mouseX - centerX) * (mouseX - centerX) + (mouseY - centerY) * (mouseY - centerY));
    if (distance <= radius) {
      fill(230,230,161, tintVal);
      return true;
    }
    fill (255,255,179, tintVal);
    return false;
  }
  
  public void drawDots(int tintVal) {
    float x,y;
    float xInterval = width*0.8f / (PApplet.parseFloat(xData.size()) + 1.0f);
    String tooltip = "";
    x = width*0.1f + xInterval;
    for (int i = 0; i < xData.size(); i++) {
      y = zeroY - unit * yData.get(i);
      //if (i == 23) println(y);
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
      stroke(0, tintVal);
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
class LineToBar extends Animation {

	LineGraph fromGraph;
	BarGraph  toGraph;
	float xInterval, fadeProg;
	boolean reduceDotsFinished, isFinished;

	LineToBar(LineGraph l, BarGraph b) {
		this.fromGraph = l;
		this.toGraph = b;
		this.progressInterval = 0.01f;
		this.xInterval = width*0.8f / (PApplet.parseFloat(this.toGraph.xData.size()) + 1.0f);
		this.reduceDotsFinished = false;
		this.isFinished = false;
		this.fadeProg = 0.0f;
	}

	public void draw(float x, float y, float w, float h) {
		this.xInterval = width*0.8f / (PApplet.parseFloat(this.toGraph.xData.size()) + 1.0f);
                animate(x,y,w,h);

		if (isFinished) {
			fadeBarIn();
			if (fadeProg >= 1) {
				inTransition = false;
				bar = true;
				line = false;
                                toBar = false;
				progress = 0.0f;
				reduceDotsFinished = false;
				isFinished = false;
				fadeProg = 0.0f;
			}
		}
		progress += progressInterval;
	}

	public void animate(float x, float y, float w, float h) {
		float tickX = width*0.1f + xInterval;
		float widthB = xInterval*0.9f;
		float upperY, heightB;
		float upperX = tickX;
		float prevX = upperX;
		float prevY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(0);

		if (!reduceDotsFinished) {
			for (int i=0; i<toGraph.xData.size(); i++) {
	      		upperY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(i);

	      		float dotWidth = 0.015f*width;
	  			float newY = upperY-(lerp(prevY,upperY, progress)-prevY);
	  			float newX = upperX-(lerp(prevX,upperX, progress)-prevX);
	  			if (newX > prevX){
	      			line(prevX, prevY, newX, newY);
	      			prevX = upperX;
					prevY = upperY;
					fill(255,255,179);
					if (i==1) {
						float firstX = width*0.1f + xInterval;
						float firstY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(0);
						ellipse(firstX, firstY, dotWidth, dotWidth);
						ellipse(upperX, upperY, dotWidth, dotWidth);
					} else {
						ellipse(upperX, upperY, dotWidth, dotWidth);
					}
				} else if (newX < prevX) {
					float dotInterval = lerp(0, dotWidth, progress);
					float dot = dotWidth*2 - dotInterval;
					fill(255,255,179);
					if (i==1) {
						float firstX = width*0.1f + xInterval;
						float firstY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(0);
						ellipse(firstX, firstY, dot, dot);
						ellipse(upperX, upperY, dot, dot);
					}
					else
						ellipse(upperX, upperY, dot, dot);
				}
	      		upperX += xInterval;
			}
			if (progress >= 2.0f) {
				progress = 0.0f;
				reduceDotsFinished = true;
			}
		} else {
			for (int i=0; i<toGraph.xData.size(); i++) {
				upperY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(i);
				upperX = tickX-(xInterval*0.9f)/2;
				heightB = fromGraph.unit * fromGraph.yData.get(i);
				fill(255,255,179);
				float wInterval = lerp(0, widthB, progress);
				float hInterval = lerp(0, heightB, progress);
				float newUpperX = lerp(upperX, upperX + widthB/2, progress);
				if (hInterval <= heightB) {
					rect(upperX, upperY, wInterval , hInterval);
				} else {
					isFinished = true;
				}

				tickX += xInterval;
			}
		}
	}

	public void fadeBarIn() {
		fadeProg += 0.01f;
		toGraph.setTint(PApplet.parseInt(lerp(0,255,fadeProg)));
		fill(0, PApplet.parseInt(lerp(0,255,fadeProg)));
		toGraph.drawAxis();
		toGraph.drawYTicks();
		toGraph.drawXTicks();
		toGraph.drawXLabels();
		toGraph.drawBars(255);
	}

};







class PieGraph extends Graph implements Cloneable {
  int[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
    int highlight = color(255, 255, 0);
  
  ArrayList<String> categories;
  ArrayList<Float> peoplePerCat;
  ArrayList<Float> angles;
  int totalNumPeople, tintVal;
  String toolTip;
  boolean lastLevel;
  float centerX, centerY, radius;
    
  PieGraph(ArrayList<String> categories, ArrayList<Float> peoplePerCat, boolean lastLevel) {
    super(categories, peoplePerCat);
    this.categories = categories;
    this.peoplePerCat = peoplePerCat;
    angles = new ArrayList<Float>();
    calcTotalNum();
    calcAngles();
    toolTip = "";
    this.lastLevel = lastLevel;
    tintVal = 255;
  }
  
  public String getSelectedCategory() {
    float currentAngle = 270;
    for (int i = 0; i < angles.size(); ++i) {
      if(testIntersect(centerX, centerY, radius, (currentAngle - angles.get(i)), currentAngle)) {
        return categories.get(i);
      }
      currentAngle -= angles.get(i);
    }
    return "";
  }
  
  public void calcTotalNum() {
    totalNumPeople = 0;
    for (int i=0; i<peoplePerCat.size(); ++i) {
      totalNumPeople += peoplePerCat.get(i);
    }
  }
  
  public void calcAngles() {
    for (int i = 0; i<peoplePerCat.size(); ++i) {
      angles.add(((float)peoplePerCat.get(i) / (float)totalNumPeople) * 360.0f);
    }
  }
  
  public void draw(float x, float y, float w, float h) {
    draw((x + w)/2.0f, (y + h)/2.0f, w < h ? 0.9f*(w/2) : 0.9f*(h/2));
  }

  public void draw(float centerX, float centerY, float radius) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    float currentAngle = 270;
    toolTip = "";
    int colorIndex = 0;
    for (int i =0; i < angles.size(); ++i) {
      if(testIntersect(centerX, centerY, radius, (currentAngle - angles.get(i)), currentAngle)) {
        fill(highlight);
        toolTip = categories.get(i) + " - " + peoplePerCat.get(i);
      }
      else {
        fill(colors[colorIndex]);
      }
      stroke(0);
      arc(centerX, centerY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    }
    drawLabels(255);
    if (toolTip != "") {
      textSize(15);
      textAlign(LEFT);
      float textW = textWidth(toolTip);
      fill(255);
      rect(mouseX, mouseY-40, textW*1.1f, 45);
      fill(0);
      text(toolTip, mouseX+ textW*0.05f, mouseY-23);
      textAlign(CENTER, BOTTOM);
    }
  }
  
  public boolean testIntersect(float centerX, float centerY, float radius, float lowerAngle, float upperAngle) {
    float distance = sqrt((mouseX - centerX) * (mouseX - centerX) + (mouseY - centerY) * (mouseY - centerY));
    if (distance > radius) 
      return false;
    float mouseAngle = degrees(atan2((mouseY - centerY),(mouseX - centerX)));
    if (mouseAngle < 0) 
      mouseAngle += 360.0f;
    if (lowerAngle < 0 && upperAngle < 0) {
      lowerAngle += 360;
      upperAngle += 360;
    }
    else if (lowerAngle < 0) {
      lowerAngle += 360;
      if (lowerAngle > upperAngle)
        return (! (upperAngle < mouseAngle && mouseAngle < lowerAngle));
    }
    return (lowerAngle < mouseAngle && mouseAngle < upperAngle);
  }  
  
  public void drawLabels(int tintValue) {
    this.tintVal = tintValue;
    drawLabels();
  }
  
  public void drawLabels() {
    float currentAngle = 270;
    float startX, startY, endX, endY, lineAngle;
    for (int i =0; i < angles.size(); ++i) {
      stroke(0, tintVal);
      fill(0, tintVal);
      lineAngle = currentAngle - angles.get(i)/2.0f;
      startX = centerX + radius * cos(radians(lineAngle));
      startY = centerY + radius * sin(radians(lineAngle));
      endX = centerX + 1.5f * radius * cos(radians(lineAngle));
      endY = centerY + 1.5f * radius * sin(radians(lineAngle));
      line(startX, startY, endX, endY);
      if (lineAngle < 270 && lineAngle > 180)
        textAlign(RIGHT, BOTTOM);
      else if (lineAngle < 180 && lineAngle > 90)
        textAlign(RIGHT, TOP);
      else if (lineAngle < 90 && lineAngle > 0)
        textAlign(LEFT, TOP);
      else
        textAlign(LEFT, BOTTOM);
      text(categories.get(i), endX, endY);
      currentAngle -= angles.get(i);
    }
  }
    
}

class PieToBar implements  Cloneable {
  BarGraph barGraph;
  PieGraph pieGraph;
  int[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
  boolean pbGrowChange, pbSqChange, pbMoved;
  float centerX, centerY, radius, barWidth, pbExplRad, pbSpreadRad, pbSqRad, pbSpreadIncrement, progress, fadeProg;
  ArrayList<Float> angles, pbRadii, pbThetas, pbX, pbX1, pbX2, pbY, pbY1, pbY2, pbW1, pbW2, pbBarArea;
   
  PieToBar(PieGraph pie, BarGraph bar) {
    this.pieGraph = pie;
    this.barGraph = bar;
    pbSetup();
  }
  
  public void pbSetup(){
    this.angles = (ArrayList<Float>)pieGraph.angles.clone();
    pbExplRad = progress = fadeProg = 0;
    pbGrowChange = pbSqChange = true;
    pbMoved = false;
  }
  
  public void pbTransform(float centerX, float centerY, float radius, float barWidth) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    this.barWidth = barWidth;
    
    if (pbExplRad  < radius /2) {
      explode();
      if (pbExplRad >= radius/2) {
        pbSpreadRad = pbExplRad;
        pbSpreadIncrement = (radius * 1.2f - pbExplRad)/ (log((100 * radius)/ pbExplRad) / log(1.03f));
        progress = 0;
      }
    }
    else if (pbSpreadRad <= 100 *radius){
      spread();
      if (pbSpreadRad > 100*radius) {
        pbSqRad = pbSpreadRad;
        pbSqStartCond();
        progress = 0;
      }
    }
    else if (pbGrowChange) {
      grow();
      if (! pbGrowChange) {
        getXYW();
        progress = 0;
      }
    }
    else if (pbSqChange) {
      moveRect();
    }
    else if (fadeProg < 1) {
      fadeBarIn(); 
      if (fadeProg >= 1)  {
        inTransition = false;
        pie = false;
        bar = true;
        toBar = false;
        pbSetup();
      }   
    }
  }
    
  public void explode() {
    float currentAngle = 270;
    int colorIndex = 0;
    float transX, transY;
    for (int i =0; i < angles.size(); ++i) {
      progress += 0.001f;
      pbExplRad = lerp(0, radius/2, progress);
      fill(colors[colorIndex]);
      transX = centerX + pbExplRad * cos(radians(currentAngle - angles.get(i)/2));
      transY = centerY + pbExplRad * sin(radians(currentAngle - angles.get(i)/2));
      arc(transX, transY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    }
  }  
  
  public void spread() {
    float currentAngle = 270;
    int colorIndex = 0;
    float transX, transY, tempAngle;
    for (int i =0; i < angles.size(); ++i) {
      fill(colors[colorIndex]);
      tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
      transX = centerX + pbSpreadRad * cos(tempAngle);
      transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
      arc(transX, transY, 2*radius, 2*radius, (tempAngle - radians(angles.get(i)/2)), (tempAngle + radians(angles.get(i)/2)),  PIE);
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    } 
    if (pbSpreadRad < 100 *radius){
        pbSpreadRad *= 1.03f;
        pbExplRad += pbSpreadIncrement;
    }
  }
  
  public void pbSqStartCond() {
    pbRadii = new ArrayList<Float>();
    pbX = new ArrayList<Float>();
    pbY = new ArrayList<Float>();
    pbBarArea = new ArrayList<Float>();
    float currentAngle = 270;
    
    float transX, transY, tempAngle;
    for (int i = 0; i < angles.size(); ++i) {
      pbRadii.add(radius);
      tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
      transX = centerX + pbSpreadRad * cos(tempAngle);
      transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
      pbX.add(transX);
      pbY.add(transY);
      currentAngle -= angles.get(i);
      pbBarArea.add(barGraph.getUnit() * barWidth * barGraph.yData.get(i));
    }  
    pbThetas = (ArrayList<Float>)angles.clone();
  }
  
  public void grow() {
    pbGrowChange = false;
    int colorIndex = 0;
    float finalAngle;
    for (int i =0; i < angles.size(); ++i) {
      progress += 0.0005f;
      finalAngle = (angles.get(i) > degrees(2*barWidth * barWidth / pbBarArea.get(i)) ? 
              degrees(2*barWidth * barWidth / pbBarArea.get(i)) : angles.get(i));
      fill(colors[colorIndex]);
      pbY.set(i, (pbY.get(i) + (pbRadii.get(i) - lerp(radius, sqrt(2 * pbBarArea.get(i)/radians(finalAngle)), progress))));
      pbRadii.set(i, lerp(radius, sqrt(2 * pbBarArea.get(i)/radians(finalAngle)), progress));
        pbThetas.set(i, lerp(angles.get(i), finalAngle , progress));
        if (progress < 1)
          pbGrowChange = true;
      arc(pbX.get(i), pbY.get(i), 2*pbRadii.get(i), 2*pbRadii.get(i), (HALF_PI - radians(pbThetas.get(i)/2)), (HALF_PI + radians(pbThetas.get(i)/2)),  PIE);
      colorIndex = (colorIndex + 1) % colors.length;
    } 
  }
  
  public void getXYW() {
    float xInterval = width*0.8f / (PApplet.parseFloat(angles.size()) + 1.0f);
    float tickX = width*0.1f + xInterval;
    float unit = barGraph.getUnit();
    float zeroY = height*0.85f + barGraph.lowRange*unit;
    
    pbX1 = new ArrayList<Float>();
    pbY1 = new ArrayList<Float>();
    pbW1 = new ArrayList<Float>();
    pbX2 = new ArrayList<Float>();
    pbY2 = new ArrayList<Float>();
    pbW2 = new ArrayList<Float>();
    for (int i = 0; i < angles.size(); ++i) {
      pbX1.add(pbX.get(i));
      pbY1.add(pbY.get(i));
      pbW1.add(0.0f);
      pbX2.add(pbX.get(i) + pbRadii.get(i) * cos(HALF_PI + radians(pbThetas.get(i) / 2)));
      pbY2.add(pbY.get(i) + pbRadii.get(i) * sin(HALF_PI + radians(pbThetas.get(i) / 2)));
      pbW2.add(radians(pbThetas.get(i)) * pbRadii.get(i));
      pbX.set(i, tickX);
      pbY.set(i, zeroY-unit*barGraph.yData.get(i));
      tickX+= xInterval;
   }
  }
  
 public void moveRect() {
  pbSqChange = false;
  int colorIndex = 0;
  float x1, x2, y1, y2, w1, w2;
  for (int i =0; i < angles.size(); ++i) {
    progress += 0.0005f;
    int c = lerpColor(colors[colorIndex], color(255,255,179), progress);
    fill(c);
    x1 = lerp(pbX1.get(i), pbX.get(i), progress);
    w1 = lerp(pbW1.get(i), barWidth, progress);
    x2 = lerp(pbX2.get(i), pbX.get(i) - barWidth/2, progress);
    w2 = lerp(pbW2.get(i), barWidth, progress);
    y1 = lerp(pbY1.get(i), pbY.get(i), progress);
    y2 = lerp(pbY2.get(i), (pbY.get(i) + pbBarArea.get(i) / barWidth), progress);
    
    quad(x1-w1 /2, y1, x1 + w1 /2, y1, x2 + w2, y2, x2,y2);   
    colorIndex = (colorIndex + 1) % colors.length;
    if (progress < 1)
      pbSqChange = true;
   }
 }
  public void fadeBarIn() {
    fadeProg += 0.01f;
    barGraph.setTint(PApplet.parseInt(lerp(0, 255, fadeProg)));
    fill(0, PApplet.parseInt(lerp(0, 255, fadeProg)));
    barGraph.drawAxis();
    barGraph.drawYTicks();
    barGraph.drawXTicks();
    barGraph.drawXLabels();
    for (int i = 0; i < angles.size(); ++i) {
      fill(255,255,179);
      rect(pbX.get(i) - barWidth/2, pbY.get(i), barWidth, pbBarArea.get(i) / barWidth);
    }
  }
}

class PieToRose implements Cloneable {
 int[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
   int highlight = color(255, 255, 0);
  
 PieGraph pieG;
 RoseChart roseG;
 float centerX, centerY, rPie, rRose, rUnit, rAngle, progress;
 boolean shifting;
 ArrayList<Float> angles;
 ArrayList<ArrayList<Float>> values;
  
 PieToRose(PieGraph pie, RoseChart rose) {
   this.pieG = pie;
   this.roseG = rose;
   this.angles = (ArrayList<Float>)pieG.angles.clone();
   this.values = (ArrayList<ArrayList<Float>>)roseG.values.clone();
   rAngle = 360.0f / angles.size();
   prSetup();
 }
 
 public void prSetup() {
  progress = 0; 
  shifting = true; 
  roseG.setTint(255);
 }
 
 public void draw(float centerX, float centerY, float rPie, float rRose) {
   if (shifting) {
     shiftPie(centerX, centerY, rPie, rRose);
     if (!shifting)
       progress = 0;
   }
   else if (progress < 1) {
     fadeIn(centerX, centerY, rRose);
     if(progress >= 1) {
       inTransition = false;
       pie = false;
       rose = true;
       toRose = false;
       prSetup();
     }
   }
 }
 
 public void shiftPie(float centerX, float centerY, float rPie, float rRose) {
   shifting = false;
   float currentAngle = 270;
   int colorIndex = 0;
   roseG.maxRadius = rRose;
   roseG.calcAxisVals();
   float unit = roseG.unit;
   float tempAngle, tempR;
   
   for (int i = 0; i < angles.size(); ++i) {
     progress += 0.0005f;
     fill(lerpColor(colors[colorIndex], colors[1], progress));
     tempR = lerp(rPie, unit * values.get(0).get(i), progress);
     tempAngle = lerp(angles.get(i), rAngle, progress);
     arc(centerX, centerY, 2* tempR, 2* tempR, radians(currentAngle - tempAngle), radians(currentAngle), PIE);
     currentAngle -= tempAngle;
     colorIndex = (colorIndex + 1) % colors.length;
     if (progress < 1)
       shifting = true;
   }
 }
 
 public void fadeIn(float centerX, float centerY, float radius) {
   progress += 0.01f;
   int tintVal = PApplet.parseInt(lerp(0, 255, progress));
   roseG.setTint(tintVal);
   roseG.draw(centerX, centerY, radius);
 }
 
}


class RoseChart implements Cloneable {
  int[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
//    color(, 0, 255), color(0, 255, 0), color(255, 0, 0), color(0, 255, 255), color(255, 0, 255)};
  int highlight = color(255, 255, 0);
  
  ArrayList<String> labels;
  ArrayList<ArrayList<Float>> values;
  ArrayList<Float> valuesPerCat;
  int totalNumPeople;
  String toolTip;
  boolean lastLevel;
  float centerX, centerY, maxRadius, angle, unit, maxValue;
  int interval, tintValue;
    
  RoseChart(ArrayList<String> labels, ArrayList<ArrayList<Float>> values) {
    this.labels = labels;
    this.values = values;
    angle = 360.0f / labels.size();
    valuesPerCat = new ArrayList<Float>();
    calcValPerCat();
    toolTip = "";
    this.lastLevel = lastLevel;
    this.maxValue = getMaxValue();
    tintValue = 255;
  }
   
  public void calcValPerCat() {
    for (int i = 0; i<values.get(0).size(); ++i) {
       valuesPerCat.add(0.0f);
    } 
    for (int i = 0; i<values.size(); ++i) 
      for (int j = 0; j< values.get(i).size(); ++j)
        valuesPerCat.set(j, valuesPerCat.get(j) + values.get(i).get(j));
  }

  
  public float getMaxValue() {
   int maxIndex = valuesPerCat.indexOf(Collections.max(valuesPerCat));
   return valuesPerCat.get(maxIndex);
  }
  
  public void draw(float centerX, float centerY, float radius) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.maxRadius = radius;
    float currentAngle = 270.0f;
    ArrayList<Float> clonedVals = (ArrayList<Float>)valuesPerCat.clone();
    calcAxisVals();
    toolTip = "";
    int colorIndex = 0; //values.size() % colors.length;
    for (int i = 0; i < valuesPerCat.size(); ++i) {
      for (int j =values.size() -1; j >=0; --j) {
        fill(colors[colorIndex], (j == 0? 255 : tintValue));
        if (j != 0)
          stroke(0, tintValue);
        else
          stroke(0);
        arc(centerX, centerY, 2* unit * clonedVals.get(i), 2* unit * clonedVals.get(i), radians(currentAngle - angle), radians(currentAngle),  PIE);
        clonedVals.set(i, clonedVals.get(i) - values.get(j).get(i));
        colorIndex = j % colors.length;
      }
      currentAngle -= angle;
    }
    drawLabels();
  }
  
  public void drawLabels(int tintVal) {
   this.tintValue = tintVal;
   drawLabels(); 
  }
  
  public void drawLabels() {
    float currentAngle = 270;
    calcAxisVals();
    float endX, endY;
    int intervalY = ceil(maxValue / 10.0f);
    for (int i = 0; i < labels.size(); ++i) {
      endX = centerX + maxRadius * cos(radians(currentAngle));
      endY = centerY + maxRadius * sin(radians(currentAngle));
      stroke(0, tintValue);
      line(centerX, centerY, endX, endY);
      currentAngle -= angle;
    }
    for (int i = 1; i < 11; ++i) {
      noFill();
      ellipse(centerX, centerY, 2*i*intervalY * unit, 2*i*intervalY * unit);
      fill(0, tintValue);
      textAlign(TOP);
      text(i*intervalY, centerX, centerY - i*intervalY * unit);
    }
  }
  public void setTint(int tint) {
    tintValue = tint;
  }
  
  public void calcAxisVals() {
    unit = (height/3 / maxValue)/1.1f;
    interval = ceil(maxValue/10.0f);
  }
}

class RoseToPie implements Cloneable {
 int[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
 int highlight = color(255, 255, 0);
  
 PieGraph pieG;
 RoseChart roseG;
 float centerX, centerY, rPie, rRose, rUnit, rAngle, progress;
 boolean fading;
 ArrayList<Float> angles;
 ArrayList<ArrayList<Float>> values;
  
 RoseToPie(PieGraph pie, RoseChart rose) {
   this.pieG = pie;
   this.roseG = rose;
   this.angles = (ArrayList<Float>)pieG.angles.clone();
   this.values = (ArrayList<ArrayList<Float>>)roseG.values.clone();
   rAngle = 360.0f / angles.size();
   rpSetup();
 }
 
 public void rpSetup() {
  progress = 0; 
  fading = true; 
  roseG.setTint(255);
 }
 
 public void draw(float centerX, float centerY, float rPie, float rRose) {
   if (fading) {
     fadeOut(centerX, centerY, rRose);
     if (!fading)
       progress = 0;
   }
   else if (progress < 1) {
     shiftPie(centerX, centerY, rPie, rRose);
     if(progress >= 1) {
       inTransition = false;
       rose = false;
       pie = true;
       toPie = false;
       rpSetup();
     }
   }
 }
 
 public void shiftPie(float centerX, float centerY, float rPie, float rRose) {
   float currentAngle = 270;
   int colorIndex = 0;
   roseG.maxRadius = rRose;
   roseG.calcAxisVals();
   float unit = roseG.unit;
   float tempAngle, tempR;
   
   for (int i = 0; i < angles.size(); ++i) {
     progress += 0.0005f;
     fill(lerpColor(colors[1], colors[colorIndex], progress));;     tempR = lerp(unit * values.get(0).get(i), rPie, progress);
     tempAngle = lerp(rAngle, angles.get(i), progress);;
     stroke(0);
     arc(centerX, centerY, 2* tempR, 2* tempR, radians(currentAngle - tempAngle), radians(currentAngle), PIE);
     currentAngle -= tempAngle;
     colorIndex = (colorIndex + 1) % colors.length;
    }
 }
 
 public void fadeOut(float centerX, float centerY, float radius) {
   progress += 0.01f;
   int tintVal = PApplet.parseInt(lerp(255, 0, progress));
   roseG.setTint(tintVal);
   roseG.draw(centerX, centerY, radius);
   if (progress >= 1)
     fading = false;
 }
 
}




class StackedBar {
  int[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
  int highlight = color(255, 255, 0);
  
  ArrayList<String> labels;
  ArrayList<ArrayList<Float>> values;
  ArrayList<Float> valuesPerCat;
  Graph graph;
  int totalNumPeople;
  String toolTip;
  boolean lastLevel;
  float unit, maxValue, zeroY, longestIndex;
  int interval, tintValue;

  StackedBar(ArrayList<String> labels, ArrayList<ArrayList<Float>> values) {
    this.labels = labels;
    this.values = values;
    valuesPerCat = new ArrayList<Float>();
    calcValPerCat();
    maxValue = getMaxValue();
    graph = new Graph(labels, valuesPerCat);
    calcAxisVals();
    tintValue = 255;
  }
  
  public void calcValPerCat() {
    for (int i = 0; i<values.get(0).size(); ++i) {
       valuesPerCat.add(0.0f);
    } 
    for (int i = 0; i<values.size(); ++i) 
      for (int j = 0; j< values.get(i).size(); ++j)
        valuesPerCat.set(j, valuesPerCat.get(j) + values.get(i).get(j));
  }
 
 public float getMaxValue() {
   int maxIndex = valuesPerCat.indexOf(Collections.max(valuesPerCat));
   return valuesPerCat.get(maxIndex);
  }
 
  public void draw(int tintVal) {
    graph.draw(0,0,width,height);
    drawBars(tintVal);
  }

  public void drawBars(int tintVal){
    zeroY = graph.zeroY;
    unit = graph.unit;
    float xInterval = width*0.8f / (PApplet.parseFloat(labels.size()) + 1.0f);
    float tickX = width*0.1f + xInterval;
    float upperX, upperY, widthB, heightB;
    int colorIndex = 0; 
       
    for (int i = 0; i < valuesPerCat.size(); ++i) {
      upperX = tickX-(xInterval*0.9f)/2;
      upperY = zeroY-unit*valuesPerCat.get(i);
      widthB = xInterval*0.9f;
      heightB = unit*valuesPerCat.get(i);
      for (int j =values.size() -1; j >=0; --j) {
        if (j != 0)
          stroke(0, tintValue);
        else
          stroke(0);
        fill(colors[colorIndex], (j == 0? 255 : tintValue));
        rect(upperX, upperY, widthB, heightB);
        upperY += values.get(j).get(i)*unit;
        heightB -= values.get(j).get(i) *unit;
        colorIndex = j % colors.length;
      }
    
      tickX+= xInterval;
      
    } 
  }
  
  public float getWidth() {
    return width*0.8f / (PApplet.parseFloat(labels.size()) + 1.0f) * 0.9f;
  }
  public float getUnit() {
    return (height*0.75f  /(maxValue))/1.1f;
  }
  public void setTint(int tint) {
    tintValue = tint;
  }
  
  
  public void calcAxisVals() {
    unit = graph.unit;
    interval = ceil(maxValue/10.0f);
  }
}

class StackedToBar {
  int[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
   
  BarGraph barG;
  StackedBar stackedG;
  float unit, maxValue, zeroY, longestIndex, progress;
  boolean fading;
  int tintValue;
  
  StackedToBar(BarGraph barGraph, StackedBar stackedBar) {
    this.barG = barGraph;
    this.stackedG = stackedBar;
    zeroY = height*0.85f;
    sbSetup();
  }
  
  public void sbSetup() {
   progress = 0;
   fading = true; 
   tintValue = 255;
  }
  
  public void draw() {
   if(fading) {
    fadeOut();
    if(!fading)
      progress = 0;
   }
   else if (progress < 1) {
     grow();
     if(progress >= 1) {
        inTransition = false;
        stacked = false;
        bar = true;
        toBar = false;
        sbSetup();
   }
  } 
 }
  
  public void grow() {
    progress += 0.005f;    
    float upperX, upperY, heightB;
    int maxRange = (ceil(stackedG.maxValue) % stackedG.graph.intervalX == 0 ? 
        ceil(stackedG.maxValue) : (ceil(stackedG.maxValue) + (ceil(stackedG.maxValue) % stackedG.graph.intervalX)));
    float tempMax = lerp(maxRange, barG.getMaxYValue(), progress);
    tempMax = tempMax > stackedG.maxValue ? stackedG.maxValue : tempMax;
    float xInterval = width * 0.8f / (PApplet.parseFloat(labels.size()) + 1.0f);
    float tickX = width * 0.1f + xInterval;

    float widthB = barG.getWidth();
    float interval = tempMax / 10.0f;
    float tempUnit = (height*.75f / tempMax) / 1.1f;
    barG.drawAxis();
    barG.drawXTicks();
    barG.drawXLabels();
    for (int i = 0; i < labels.size(); ++i) {
      fill(lerpColor(color(255,255,179), colors[1], progress));
      upperX = tickX-(xInterval*0.9f)/2;
      upperY = zeroY-tempUnit*barG.yData.get(i);
      heightB = tempUnit*barG.yData.get(i);
      rect(upperX, upperY, widthB, heightB);
      tickX+= xInterval;
    }
    textAlign(CENTER, CENTER);
    float halfTick = width * 0.01f;
    for (int i = 0; i*interval *tempUnit < height * 0.74f; i++) {
      line(width*0.1f- halfTick, barG.zeroY-tempUnit*i*interval, width*0.1f+halfTick, barG.zeroY-tempUnit*i*interval);
      fill(0,0,0, tintValue);
      textSize(12);
      text(i*interval, width*0.05f, zeroY-tempUnit*i*interval);
    }
    }

  
  public void fadeOut() {
   fading = false;
   progress += 0.005f;
   int tintVal = PApplet.parseInt(lerp(255, 0, progress));
   stackedG.setTint(tintVal);
   stackedG.draw(tintVal);
   if (progress < 1)
      fading = true;
  
  }

  
}
  

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "a2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
