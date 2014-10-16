import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.lang.Object; 
import java.util.Arrays; 
import java.util.Collections; 
import java.util.Collections; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Lab_Experiment extends PApplet {





final int NUM_REP = 20;

int chartType;
ArrayList<Integer> visType;
Data d = null;
BarGraph bg;
PieGraph pg;
StackedBar sb;
SqTreeMap sm;

public void setup() {
    totalWidth = displayWidth;
    totalHeight = displayHeight;
    chartLeftX = totalWidth / 2.0f - chartSize / 2.0f;
    chartLeftY = totalHeight / 2.0f - chartSize / 2.0f - margin_top;
    visType = new ArrayList<Integer>();
    for (int i = 0; i < vis.length; ++i) {
      for (int j = 0; j < NUM_REP; ++j)
        visType.add(i);
    }
    
    size((int) totalWidth, (int) totalHeight);
    //if you have a Retina display, use the line below (looks better)
    //size((int) totalWidth, (int) totalHeight, "processing.core.PGraphicsRetina2D");

    background(255);
    frame.setTitle("Comp150-07 Visualization, Lab 5, Experiment");

    cp5 = new ControlP5(this);
    pfont = createFont("arial", fontSize, true); 
    textFont(pfont);
    page1 = true;

    d = new Data();
    int tempIndex;
    tempIndex = PApplet.parseInt(random(0, visType.size()));
    chartType = visType.get(tempIndex);
    visType.remove(tempIndex);
    
    int year, month, day, hour, min;
    year = year();
    month = month();
    day = day();
    hour = hour();
    min = minute();

    partipantID = String.valueOf(year) + "-" + String.valueOf(month) + "-" + String.valueOf(day) + "-" + String.valueOf(hour) + "-" + String.valueOf(min);
}

public void draw() {
    textSize(fontSize);
    if (index < 0 && page1) {
        drawIntro();
        page1 = false;
    } else if (index >= 0 && index < vis.length* NUM_REP) {
        if (index == 0 && page2) {
            clearIntro();
            drawTextField();
            drawInstruction();
            page2 = false;
        }
        noStroke();
        fill(255);
        rect(chartLeftX, chartLeftY-23, 300, 22);
        fill(0);
        textSize(20);
        textAlign(LEFT);
        text(index+1 + "/100", chartLeftX, chartLeftY-3); 
        
        switch (chartType) {
            case 0:
                 pg = new PieGraph(d);
                 stroke(0);
                 strokeWeight(1);
                 fill(255);
                 rectMode(CORNER);
                 rect(chartLeftX, chartLeftY, chartSize, chartSize);
                 pg.draw(chartLeftX + chartSize/2, chartLeftY + chartSize/2, chartSize*0.9f);
                 cp5.get(Textfield.class, "answer").setFocus(true);
                 break;
            case 1:
                 bg = new BarGraph(d);
                 stroke(0);
                 strokeWeight(1);
                 fill(255);
                 rectMode(CORNER);
                 rect(chartLeftX, chartLeftY, chartSize, chartSize);
                 bg.draw(chartLeftX, chartLeftY, chartSize, chartSize, true);
                 cp5.get(Textfield.class, "answer").setFocus(true);
                 break;
            case 2:
                 sb = new StackedBar(d);
                 stroke(0);
                 strokeWeight(1);
                 fill(255);
                 rectMode(CORNER);
                 rect(chartLeftX, chartLeftY, chartSize, chartSize);
                 sb.draw(chartLeftX, chartLeftY, chartSize, chartSize);
                 cp5.get(Textfield.class, "answer").setFocus(true);
                 break;
            case 3:
                 bg = new BarGraph(d);
                 stroke(0);
                 strokeWeight(1);
                 fill(255);
                 rectMode(CORNER);
                 rect(chartLeftX, chartLeftY, chartSize, chartSize);
                 bg.draw(chartLeftX, chartLeftY, chartSize, chartSize, false);
                 cp5.get(Textfield.class, "answer").setFocus(true);
                 break;
            case 4:
                 sm = new SqTreeMap(d);
                 stroke(0);
                 strokeWeight(1);
                 fill(255);
                 rectMode(CORNER);
                 rect(chartLeftX, chartLeftY, chartSize, chartSize);
                 sm.draw(chartLeftX, chartLeftY, chartSize, chartSize);
                 cp5.get(Textfield.class, "answer").setFocus(true);
                 break;
        }

        drawWarning();

    } else if (index > vis.length - 1 && pagelast) {
        drawThanks();
        drawClose();
        pagelast = false;
    }
}

/**
 * This method is called when the participant clicked the "NEXT" button.
 */
public void next() {
    String str = cp5.get(Textfield.class, "answer").getText().trim();
    float num = parseFloat(str);
    /*
     * We check their percentage input for you.
     */
    if (!(num >= 0)) {
        warning = "Please input a number!";
        if (num < 0) {
            warning = "Please input a non-negative number!";
        }
    } else if (num > 100) {
        warning = "Please input a number between 0 - 100!";
    } else {
        if (index >= 0 && index < vis.length*NUM_REP) {
            float ans = parseFloat(cp5.get(Textfield.class, "answer").getText());

            float val1 = d.getMarkedVal(0).getValue();
            float val2 = d.getMarkedVal(1).getValue();
            truePerc = val1 > val2? val2/val1 : val1/val2;
            reportPerc = ans / 100.0f; // this is the participant's response
            
            error = log(abs(reportPerc - truePerc)*100.0f + 1/8.0f) / log(2);

            saveJudgement();
        }

        
    
        cp5.get(Textfield.class, "answer").clear();
        index++;

        if (index == vis.length*NUM_REP - 1) {
            pagelast = true;
        }
        else {
          d = new Data();
         
          int tempIndex;
          tempIndex = PApplet.parseInt(random(0, visType.size()));
          chartType = visType.get(tempIndex);
          visType.remove(tempIndex);
        }
    }
}

/**
 * This method is called when the participant clicked "CLOSE" button on the "Thanks" page.
 */
public void close() {
    saveExpData();
    exit();
}

public void keyPressed() {
  if((index < vis.length * NUM_REP) && (key == ENTER || key == RETURN)) {
    next();
  }
}

/**
 * Calling this method will set everything to the intro page. Use this if you want to run multiple participants without closing Processing (cool!). Make sure you don't overwrite your data.
 */
public void reset(){
    int year, month, day, hour, min;
    year = year();
    month = month();
    day = day();
    hour = hour();
    min = minute();

    partipantID = String.valueOf(year) + "-" + String.valueOf(month) + "-" + String.valueOf(day) + "-" + String.valueOf(hour) + "-" + String.valueOf(min);

    d = new Data();

    /**
     ** Don't worry about the code below
     **/
    background(255);
    cp5.get("close").remove();
    page1 = true;
    page2 = false;
    pagelast = false;
    index = -1;
}


class BarGraph {
  Data values;
  float unit;
  float zeroY, zeroX, x, y, w, h;
  float maxRange;
  
  BarGraph(Data values) {
    this.values = values;
    setMaxRange();
  }
  
  public void draw(float x, float y, float w, float h, boolean vertical) {
    this.x = x;
    this.y = y; 
    this.w = w-2;
    this.h = h-2;
    setUnit();
    if (vertical)
      drawBarsVertical();
    else
      drawBarsHorizontal();
  }

  
  public void drawBarsVertical(){
    zeroY = y + this.h;
    float xInterval = w / (PApplet.parseFloat(values.getSize()));
    float tickX = x + xInterval/2.0f;
    float upperX, upperY, widthB, heightB;
    
    for (int i = 0; i < values.getSize(); ++i) {
      fill(255);
      upperX = tickX-(xInterval*0.8f)/2;
      upperY = zeroY-unit*values.getValue(i);
      widthB = xInterval*0.8f;
      heightB = unit*values.getValue(i);
      rect(upperX, upperY, widthB, heightB);
      if (values.isMarked(i)) {
        fill(0);
        ellipse(tickX, zeroY - w*0.02f, w*0.01f, w*0.01f);
      }
      tickX+= xInterval;
    }
 }
 
 public void drawBarsHorizontal(){
    zeroX = x;
    float yInterval = h / (PApplet.parseFloat(values.getSize()));
    float tickY = y + yInterval/2.0f;
    float upperX, upperY, widthB, heightB;
    
    for (int i = 0; i < values.getSize(); ++i) {
      fill(255);
      upperY = tickY-(yInterval*0.8f)/2;
      upperX = x;
      heightB = yInterval*0.8f;
      widthB = unit*values.getValue(i);
      rect(upperX, upperY, widthB, heightB);
      if (values.isMarked(i)) {
        fill(0);
        ellipse(zeroX + w*0.02f, tickY, w*0.01f, w*0.01f);
      }
      tickY+= yInterval;
    }
 }
 
  public void setUnit() {
     unit = h /maxRange/1.1f;
  } 
  
  public void setMaxRange() {
     float max = 0.0f;
     for (int i = 0; i < values.getSize(); ++i) {
        if (values.getValue(i) > max) 
          max = values.getValue(i);
     }
     maxRange = max;
  }
}

class Data {
    /* Public indices of the "chosen" marked values */
    public int m1;
    public int m2;

    class DataPoint {
        private float value = -1;
        private boolean marked = false;

        DataPoint(float f, boolean m) {
            this.value = f;
            this.marked = m;
        }

        public boolean isMarked() {
            return marked;
        }

        public void setMark(boolean b) {
            this.marked = b;
        }

        public float getValue() {
            return this.value;
        }
    }

    private DataPoint[] data = null;

    Data() {
        // NUM is a global varibale in support.pde
        data = new DataPoint[NUM];
        for(int i = 0; i < NUM; i++) {
            data[i] = new DataPoint(random(0.0f, 100.0f), false);
        }

        m1 = PApplet.parseInt(random(0, PApplet.parseInt(NUM)));
        m2 = PApplet.parseInt(random(0, PApplet.parseInt(NUM)));
        /* No repeat indices */
        while(m2 == m1) {
            m2 = PApplet.parseInt(random(0, NUM));
        }
        
        data[m1].setMark(true);
        data[m2].setMark(true);
    }

    /* Pass either 0 for the first marked, and 1 for the other 
     *  Returns the value of the passed index. 
     *  Will need this to get "truePerc" in Lab_Experiment"
     */
    public DataPoint getMarkedVal(int num) {
        if(num != 0) {
            return data[m1];
        } else {
            return data[m2];
        }
    }
    
    public float getValue(int i) {
        return data[i].getValue();
    }
    
    public boolean isMarked(int i) {
        return data[i].isMarked();
    }
    
    public int getSize() {
      return data.length;
    }
    
        /**
         ** finish this: the rest methods and variables you may want to use
         ** 
         **/
}

class Canvas {
  float x0, y0; // Upper-left corner of canvas
  float w, h; // Width and height of canvas
  float VA_ratio; // (total_value / canvas_area)
  Canvas(float x0, float y0, float w, float h) {
    this.x0 = x0;
    this.y0 = y0;
    this.w = w;
    this.h = h;
  }

  public Canvas clone() {
    Canvas c = new Canvas(x0,y0,w,h);
    c.VA_ratio = VA_ratio;
    return c;
  }

}

class Node {
  
  float value;
  boolean marked;
  float x, y, w, h;

  Node(float value, boolean marked) {
    this.value = value;
    this.marked = marked;
  }
}


class SqTreeMap  {
  ArrayList<Node> values;
  float totalVal;
  float overallWidth;
  
  SqTreeMap(Data d) {
    values = new ArrayList<Node>();
    setMembers(d);
    sortValues();
  }
  
  public void setMembers(Data d) {
    float total = 0.0f;
    Node temp;
    for (int i = 0; i < d.getSize(); ++i) {
      total += d.getValue(i);
      temp = new Node(d.getValue(i), d.isMarked(i));
      values.add(temp);
    }
    totalVal = total;
  }
  
  public void sortValues() {
    int j;
    Node temp;
    for (int i = 1; i < values.size(); ++i) {
      j = i-1;
      while (j >=0 && values.get(i).value > values.get(j).value) 
        j--;
      if (i != (j+1)) {
        temp = values.get(i);
        values.remove(i);
        values.add(j+1, temp);
      }
    }
  }
  
  public void draw(float x0, float y0, float w, float h) {
    overallWidth = w;
    Canvas canvas = new Canvas(x0, y0, w, h);
    canvas.VA_ratio = (canvas.w * canvas.h) / totalVal ;
    rec_draw((ArrayList<Node>)(values).clone(), canvas, totalVal);
  }

  public void rec_draw(ArrayList<Node> children, Canvas c, float area) {
    int cIndex = 0; 
    ArrayList<Node> row = new ArrayList<Node>();
    boolean rowVertical = (c.h < c.w);
    float rowLength = c.h < c.w ? c.h : c.w;
    float rowArea = 0, rowWidth = 0;
    float currentRatio = 0;
    float tempRatio;
    
    while (children.size () > 0) {
      row.add(children.get(0));
      tempRatio = worstRatio(row, (rowArea + children.get(0).value * c.VA_ratio) / rowLength, c.VA_ratio);
      if (tempRatio >= currentRatio) {
        rowArea += children.get(0).value * c.VA_ratio;
        rowWidth = rowArea / rowLength;
        children.remove(0);
        currentRatio = tempRatio;
      } else {
        row.remove(children.get(0));
        break;
      }
    } 
    drawRow(row, c, rowVertical, rowArea, rowWidth);
    if (! children.isEmpty()) {
      Canvas newC;
      if (rowVertical) {
        newC = new Canvas((c.x0 + rowWidth), c.y0, (c.w - rowWidth), c.h);
      } else {
        newC = new Canvas(c.x0, (c.y0 + rowWidth), c.w, (c.h - rowWidth));
      }
      newC.VA_ratio = (newC.w * newC.h) / (area - rowArea/c.VA_ratio);
      rec_draw((ArrayList<Node>)children, newC, (area - rowArea/c.VA_ratio));
    }
  }
  
  public void framerect(float x, float y, float w, float h) {
    float f = 0.000f*width;
    rect(x + f, y + f, w - 2*f, h - 2*f);
  } 

  public void drawRow(ArrayList<Node> row, Canvas c, boolean rowVertical, float rowArea, float rowWidth) {
    float tempArea = 0;
    for (int i = 0; i < row.size (); i++) {
        fill(255);
        if (rowVertical) {
          rect(c.x0, (c.y0 + tempArea / rowWidth), rowWidth, (row.get(i).value * c.VA_ratio/ rowWidth));
          if (row.get(i).marked) {
            fill(0);
             ellipse(c.x0 + rowWidth / 2, (c.y0 + tempArea/ rowWidth) + (row.get(i).value * c.VA_ratio/ rowWidth) /2, 
                 overallWidth*0.02f, overallWidth*0.02f);
          }
        } else {
          rect((c.x0 + tempArea / rowWidth), c.y0, (row.get(i).value * c.VA_ratio / rowWidth), rowWidth);
          if (row.get(i).marked) {
            fill(0);
            ellipse((c.x0 + tempArea / rowWidth) + (row.get(i).value * c.VA_ratio / rowWidth) / 2, c.y0 + rowWidth/2, 
                overallWidth*0.02f, overallWidth*0.02f);
          }
        } 
      tempArea += row.get(i).value * c.VA_ratio;
    }
  }
  
  
  public float worstRatio(ArrayList<Node> row, float rowLength, float ratio) {
    float currentRatio = min((row.get(0).value * ratio / rowLength), rowLength) / 
    max((row.get(0).value * ratio / rowLength), rowLength);
    float tempRatio;
    for (int i=1; i < row.size (); i++) {
      tempRatio = min((row.get(i).value *ratio/ rowLength), rowLength) / 
      max((row.get(i).value*ratio / rowLength), rowLength); 
      if (tempRatio < currentRatio) {
        currentRatio = tempRatio;
      }
    }
    return abs(currentRatio);
  }

}

class PieGraph {
  
  Data values;
  ArrayList<Float> angles;
  float totalVal;
  float centerX, centerY, radius;
    
  PieGraph(Data values) {
    this.values = values;
    angles = new ArrayList<Float>();
    calcTotalNum();
    calcAngles();
  }
  
  public void calcTotalNum() {
    totalVal = 0;
    for (int i=0; i<values.getSize(); ++i) {
      totalVal += values.getValue(i);
    }
  }
  
  public void calcAngles() {
    for (int i = 0; i<values.getSize(); ++i) {
      angles.add(((float)values.getValue(i) / (float)totalVal) * 360.0f);
    }
  }
  
  public void draw(float centerX, float centerY, float radius) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    float currentAngle = 270;
    float tempX, tempY;
    for (int i =0; i < angles.size(); ++i) {
      stroke(0);
      fill(255);
      arc(centerX, centerY, radius, radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
      if (values.isMarked(i)) {
        tempX = centerX + radius /4 * cos(radians(currentAngle - angles.get(i)/2));
        tempY = centerY + radius /4 * sin(radians(currentAngle - angles.get(i)/2));
        fill (0);
        ellipse(tempX, tempY, chartSize*0.02f, chartSize * 0.02f);
      }
      currentAngle -= angles.get(i);
    }
  }
  
}

/**
 * These five variables are the data you need to collect from participants.
 */
String partipantID = "";
int index = -1;
float error = -1;
float truePerc = -1;
float reportPerc = -1;

/**
 * The table saves information for each judgement as a row.
 */
Table expData = null;

/**
 * The visualizations you need to plug in.
 * You can change the name, order, and number of elements in this array.
 */

String[] vis = {
    "PieChart", "BarChart", "StackedBarChart", "BarChart(horizontal)", "TreeMap"
};

/**
 * add the data for this judgement from the participant to the table.
 */ 
public void saveJudgement() {
    if (expData == null) {
        expData = new Table();
        expData.addColumn("PartipantID");
        expData.addColumn("Index");
        expData.addColumn("Vis");
        expData.addColumn("Error");
        expData.addColumn("TruePerc");
        expData.addColumn("ReportPerc");
    }

    TableRow newRow = expData.addRow();
    newRow.setString("PartipantID", partipantID);
    newRow.setInt("Index", index);

    /**
     ** finish this: decide the current visualization
     **/
    newRow.setString("Vis", vis[chartType]);

    newRow.setFloat("Error", error);
    newRow.setFloat("TruePerc", truePerc);
    newRow.setFloat("ReportPerc", reportPerc);
}

/**
 * Save the table
 * This method is called when the participant reaches the "Thanks" page and hit the "CLOSE" button.
 */
public void saveExpData() {
    /**
     ** Change this if you need 
     **/
    String filename = partipantID + ".csv";
    saveTable(expData, filename);
}


class StackedBar {
  Data values;
  float unit;
  float zeroY, x, y, w, h;
  float maxRange, totalVal;

  StackedBar(Data values) {
    this.values = values;
    setMaxRange();
  }
  
  
  public void draw(float x, float y, float w, float h) {
    this.x = x;
    this.y = y; 
    this.w = w-2;
    this.h = h-2;
    zeroY = y + this.h;
    setUnit();
    drawBars();
  }

  public void drawBars(){
    float upperX, upperY, widthB, heightB;
    float currVal = maxRange;
    
    widthB = w * 0.1f;
    upperX = x + w/2 -widthB/2;
    for (int i = 0; i < values.getSize(); ++i) {
      upperY = zeroY - unit * currVal;
      heightB = unit*currVal;
      fill(255);
      rect(upperX, upperY, widthB, heightB);
      if(values.isMarked(i)) {
        fill(0);
        ellipse(upperX + widthB /2, upperY + values.getValue(i)*unit - w*0.008f, w* 0.01f, w*0.01f);
      }
      currVal -= values.getValue(i);  
    
    } 
  }
  
  
  public void setUnit() {
     unit = h /maxRange/1.1f;
  } 
  
  public void setMaxRange() {
     float max = 0.0f;
     for (int i = 0; i < values.getSize(); ++i) {
        max += values.getValue(i);
     }
     maxRange = max;
  }
}

/********************************************************************************************/
/********************************************************************************************/
/********************************************************************************************/
/************************ Don't worry about the code in this file ***************************/
/********************************************************************************************/
/********************************************************************************************/
/********************************************************************************************/

float margin = 50, margin_small = 20, margin_top = 40, chartSize = 300, answerHeight = 100;
float totalWidth = -1, totalHeight = -1;
float chartLeftX = -1, chartLeftY = -1;
int NUM = 10;

int fontSize = 14, fontSizeBig = 20;
int textFieldWidth = 200, textFieldHeight = 30;
int buttonWidth = 60;
int totalMenuWidth = textFieldWidth + buttonWidth + (int) margin_small;

String warning = null;

ControlP5 cp5 = null;
Textarea myTextarea = null;
PFont pfont = null; 
boolean page1 = false, page2 = false, pagelast = false;

public void drawWarning() {
    fill(255);
    noStroke();
    rectMode(CORNER);
    rect(0, totalHeight / 2.0f + chartSize, totalWidth, fontSize * 3);
    if (warning != null) {
        fill(color(255, 0, 0));
        textSize(fontSize);
        textAlign(LEFT);
        text(warning, totalWidth / 2.0f - chartSize / 2.0f, 
        totalHeight / 2.0f + chartSize + fontSize * 1.5f);
    }
}

public void drawInstruction() {
    fill(0);
    textAlign(CENTER);
    textSize(fontSize);
    text("Two values are marked with dots. \n " 
      + "What percentage is the smaller of the larger? \n" 
      + "Please put your answer below. \n" 
      + "e.g. If you think the smaller is exactly a half of the larger, \n" 
      + "please input \"50\"."
      , totalWidth / 2.0f, totalHeight / 2.0f + chartSize / 2.0f);
}

public void clearInstruction() {
    fill(255);
    noStroke();
    rectMode(CORNER);
    rect(0, chartSize, totalWidth, margin);
}

public void drawTextField() {
    cp5.addTextfield("answer")
        .setPosition(totalWidth / 2.0f - chartSize / 2.0f, totalHeight / 2.0f + chartSize / 2.0f + margin * 2)
        .setSize(textFieldWidth, textFieldHeight)
        .setFocus(true)
        .setColorCaptionLabel(color(0, 0, 0))
        .setFont(createFont("arial", 14))
        .setAutoClear(true);

    cp5.addBang("next")
        .setPosition(totalWidth / 2.0f + chartSize / 2.0f - buttonWidth, totalHeight / 2.0f + chartSize / 2.0f + margin * 2)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);
}

public void drawIntro() {
    fill(0);
    textSize(fontSizeBig);
    textAlign(CENTER);
    text("In this experiment, \n" 
          + "you are asked to judge \n" 
          + "ratios between graphical elements " 
          + "in serveral charts. \n\n" 
          + "We won't record any other information from you except your answers.\n" 
          + "Click the \"agree\" button to begin. \n\n" 
          + "Thank you!", totalWidth / 2.0f, chartLeftY + chartSize / 4.0f);

    cp5.addBang("agree")
        .setPosition(totalWidth / 2.0f + margin * 2, totalHeight / 2.0f + chartSize / 2.0f)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);

    cp5.addBang("disagree")
        .setPosition(totalWidth / 2.0f - margin * 3, totalHeight / 2.0f + chartSize / 2.0f)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);
}

public void clearIntro() {
    background(color(255));
    cp5.get("agree").remove();
    cp5.get("disagree").remove();
}

public void agree() {
    index++;
    page2 = true;
}

public void disagree() {
    exit();
}

public void mouseMoved() {
    warning = null;
}

public void drawThanks() {
    background(255, 255, 255);
    fill(0);
    textSize(60);
    cp5.get(Textfield.class, "answer").remove();
    cp5.get("next").remove();
    textAlign(CENTER);
    text("Thanks!", totalWidth / 2.0f, totalHeight / 2.0f);
}

public void drawClose() {
    cp5.addBang("close")
        .setPosition(totalWidth / 2.0f - buttonWidth / 2.0f, totalHeight / 2.0f + margin_top + margin)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Lab_Experiment" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
