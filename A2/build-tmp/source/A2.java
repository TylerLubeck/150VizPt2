import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.LinkedHashMap; 
import java.util.HashMap; 
import java.util.Map.Entry; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class A2 extends PApplet {

final String FILE_NAME = "Dataset1.csv";
String[] columnNames;
LinkedHashMap<String, HashMap<String, Float>> labelToAttrib;
HashMap<String, Float> totalSums;
String XAxis;
BarGraph barGraph;
LineGraph lineGraph;
XYAxis axis;
pieChart pie;
int currentGraph;
int transitionGraph;  
Button[] buttons;
Integer PIE = 0;
int LINE = 1;
int BAR = 2; 
boolean currentlyAnimating = false;
float lineToPieStepAmount = 0.0f;
float pieToLineStepAmount = 0.0f;
float lineToBarStepAmount = 0.0f; 
float barToLineStepAmount = 0.0f;
float stepHeight = 3; 
float reverseStepHeight = -3;

public void setup() {
  frame.setResizable(true); 
  size(700, 700);
  currentGraph = 1; 
  transitionGraph = 1; 
  buttons = new Button[3]; 
  Parser p = new Parser(FILE_NAME, /*debug*/ false);
  columnNames = p.getColumnNames();
  labelToAttrib = p.getLabelToAttribMap();
  totalSums = p.getTotalSums();
  XAxis = p.getXTitle();

  /* Create a Bar Chart */
  barGraph = new BarGraph(3*width/4, height);
  for (int i = 1; i < 2; i++) {
    for (Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet ()) {
      barGraph.addBar(e.getKey(), PApplet.parseInt(e.getValue().get(columnNames[i])));
    }
  }
  barGraph.doneAddingBars();

  /* Create a Line Graph */
  //lineGraph = new LineGraph(2.0,5.0);
  lineGraph = new LineGraph(width, height); 
  for (int i = 1; i < 2; i++) {
    for (Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet ()) {
      lineGraph.addPoint(e.getKey(), PApplet.parseInt(e.getValue().get(columnNames[i])));
    }
  }

  /* Create a Pie Chart */
  pie = new pieChart(width/2); 
  for (int i = 1; i < 2; i++) {
    for (Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet ()) {
      pie.addAngle(e.getValue().get(columnNames[i]) / totalSums.get(columnNames[i]));
    }
  }
}

public void draw() {
  background(255); 
  drawButtonContainer(); 
  for (Button b : buttons) {
    changeColorOnHover(b);
  }
  transitionBetweenGraphs(); 
}

public void transitionBetweenGraphs() {
  switch (currentGraph) {
  case 0: //PIE
    pie.render(); 
    if (transitionGraph == LINE) {
      if (pieToLineStepAmount < 1.0f) {
        pie.shrink(pieToLineStepAmount); 
        pieToLineStepAmount += 0.012f;
      } else if (pieToLineStepAmount < 2.0f) {
        background(255);
        drawButtonContainer();
        pie.makeLine(pieToLineStepAmount-1.0f, lineGraph);
        pieToLineStepAmount += 0.012f;
      } else if (pieToLineStepAmount < 3.0f) {
        background(255);
        drawButtonContainer();
        float localStepTwo = pieToLineStepAmount -2.0f;
        pie.makeLine(1.0f, lineGraph); //Keep the dots on the screen
        lineGraph.connectTheDots(localStepTwo); 
        pieToLineStepAmount += 0.012f;
      } else {
        background(255);
        drawButtonContainer();
        pie.reset();
        pieToLineStepAmount = 0.0f;
        currentGraph = 1;
      }
    } else if (transitionGraph == BAR) {
      //transition pie to bar
      currentGraph = 2;
    }
    break;
  case 1: //LINE
    lineGraph.render(barGraph);
    if ( transitionGraph == BAR) {
      if ( lineToBarStepAmount < 1.0f) {
        float localStep = lineToBarStepAmount % 1.0f;
        lineGraph.drawPoints(barGraph); 
        lineGraph.disconnectTheDots(localStep); 
        lineToBarStepAmount += 0.012f; 
      } else if (lineToBarStepAmount < 3.0f) {
        background(255);
        drawButtonContainer(); 
        lineGraph.drawBars(barGraph, lineToBarStepAmount, stepHeight); 
        lineToBarStepAmount += 0.012f; 
        stepHeight += 3; 
      } else {
        background(255); 
        drawButtonContainer(); 
        currentGraph = 2;
        lineToBarStepAmount = 0; 
        stepHeight = 0; 
      }
    } else if (transitionGraph == PIE) {
        // transition line to pie
        if ( lineToPieStepAmount < 1.0f ) {
          float localStep = lineToPieStepAmount % 1.0f; 
          // old version is disconnectTheDotsTest w/out localStep 
          lineGraph.disconnectTheDots(localStep);
          lineToPieStepAmount += 0.012f; //TODO: Switch back to 0.012
        } else if (lineToPieStepAmount < 2.0f ) {
           background(255);
           drawButtonContainer();
           float lineToPieLocal = lineToPieStepAmount - 1.0f;
           lineGraph.moveDotsTo(pie.startX, pie.startY, lineToPieLocal);
           lineToPieStepAmount += 0.012f;
        } else if (lineToPieStepAmount < 3.0f) {
           background(255);
           drawButtonContainer();
           float lineToPieLocal = lineToPieStepAmount - 2.0f;
           pie.grow(lineToPieLocal);
           lineToPieStepAmount += 0.012f; //TODO: Switch back to 0.012
           pie.render();
        } else {
          background(255);
          drawButtonContainer();
          lineToPieStepAmount = 0.0f;
          lineGraph.reset();
          currentGraph = 0;
        }
    }
    break;
  case 2: //BAR
    barGraph.render();
    if (transitionGraph == LINE) {
        if (barToLineStepAmount < 1.0f) {
            float localStep = lineToBarStepAmount % 1.0f;
            background(255);
            drawButtonContainer();
            lineGraph.drawBarsUp(barGraph, barToLineStepAmount, reverseStepHeight);
            barToLineStepAmount += 0.012f;
            reverseStepHeight -= 3;
        } else if (barToLineStepAmount < 2.0f) {
            background(255);
            drawButtonContainer();
            float localStep = barToLineStepAmount - 1.0f;
            lineGraph.drawPoints(barGraph);
            lineGraph.connectTheDots(localStep);
            barToLineStepAmount += 0.012f;
        } else {
          background(255);
          drawButtonContainer();
          barToLineStepAmount = 0.0f;
          reverseStepHeight = -3;
          currentGraph = 1;
        }
    } else if (transitionGraph == PIE) {
      //transition bar to pie
      barGraph.AnimateToPie(pie);
      //currentGraph = 0;
    }
    break;
  }
}

public void changeColorOnHover(Button button) {
  if (button.intersect(mouseX, mouseY)) {
    button.setColor(color(80, 50, 70)); 
    button.render();
  }
}

public void drawButtonContainer() {
  int b_width = width - width/4; 
  fill(255);
  rect(b_width, 0, width/4, height, 7);
  buttons[0] = new Button(b_width, height, b_width, 0, "Pie Chart"); 
  buttons[1] = new Button(b_width, height, b_width, height/3, "Line Graph");  
  buttons[2] = new Button(b_width, height, b_width, height - height/3, "Bar Graph");  
  for ( Button b : buttons) {
    b.render();
  }
}

public void mousePressed() {
  for (int i = 0; i < 3; i++) {
    if (buttons[i].intersect(mouseX, mouseY)) {
      transitionGraph = i; 
    }
  }
}
class Bar {
  float value;
  float xCoord, yCoord, pointX, pointY;
  float bWidth, bHeight;
  String label;
  int fill, stroke;

  Bar() {
    value = 0;
    label = "";
  }
  Bar( String l, float val, int f, int s) {
    value = val;
    label = "(" + l + "," + value + ")";
    fill = f;
    stroke = s;
  }

  public void SetGeometry( float xC, float yC, float w, float h) {
    pointX = xC + w/2;
    pointY = yC;
    xCoord = xC;
    yCoord = yC;
    bWidth = w;
    bHeight = h;
  }

  public void render() {
    stroke(stroke);
    fill(fill);
    rect( xCoord, yCoord, bWidth, bHeight );
  }

  public void intersect(int posx, int posy) {
    if ( posx >= xCoord && posx <= bWidth + xCoord &&
      posy >= yCoord && posy <= (yCoord+ bHeight)) {
      fill(color(255, 0, 0));
      text( label, xCoord - bWidth - 10, yCoord - 2);
      fill(color(0));
    }
  }
}


class BarGraph {
  ArrayList<Bar> bars;
  float sumBarValues;
  int fill, stroke;
  float w, h;
  float leftSpacing;
  float rightSpacing;
  float paddedHeight;
  float pad;
  boolean[] barIsAnimating;
  float barWidth; 
  boolean barsHidden;

  BarGraph(float w, float h) {
    bars = new ArrayList<Bar>();
    fill = color(155, 161, 163);
    stroke = color(216, 224, 227);
    this.w = w;
    this.h = h;
    //Need to make spacing dynamic
    this.leftSpacing = 20;
    this.rightSpacing = 20; 
    this.paddedHeight = height - 100;
    this.sumBarValues = 0;
    barsHidden = false;
  }

  public void addBar( String lbl, float val) {
    Bar b = new Bar( lbl, val, this.fill, this.stroke);
    bars.add(b);
  }

  public void doneAddingBars() {
    this.setGeometry();
    for (Bar b : bars) {
      this.sumBarValues += b.value;
    }
    float masterBarHeight = 3* (paddedHeight / 4);

    //create array
    barIsAnimating = new boolean[this.bars.size()];
    setBarsAreAnimatingToFalse();
    setGeometry();
  }

  public void setGeometry() {
    //calculate appropriate width/height and spacing for each bar
    int numBars = bars.size();
    float barSpacing = 5.0f;
    float totalSpacing = (numBars + 1) * barSpacing;
    float availableWidth = this.w - totalSpacing - this.leftSpacing - this.rightSpacing;
    this.barWidth = availableWidth / numBars;
    float yFactor = 2.0f;

    //set up starting coords
    float startPosX = this.leftSpacing + barSpacing;

    for (int i=0; i< bars.size (); i++) {
      float barHeight = bars.get(i).value * yFactor;
      bars.get(i).SetGeometry(startPosX, 
      paddedHeight - barHeight, 
      this.barWidth, 
      barHeight);
      startPosX+=this.barWidth + barSpacing;
    }
  }

  public void render() { 
    if (!barsHidden) {
      for (Bar b : bars) {
        b.render();
      }
    }
  }

  public boolean barsAreDoneAnimating() {
    for (boolean b : this.barIsAnimating) {
      if (b) {
        return false;
      }
    }
    return true;
  }

  public void setBarsAreAnimatingToFalse() {
    for (int i=0; i<this.barIsAnimating.length; i++) {
      this.barIsAnimating[i] = false;
    }
  }

  public void AnimateToPie(pieChart pie) {

    //Step 1: shrink bars to their pointX, pointY
    //Their heights will be proporionate to each other in terms of "masterBarHeight"
    shrink();

    if (barsAreDoneAnimating()) {
      //setBarsAreAnimatingToFalse();
      //Step 2: Move all the bars to one stacked column in middle of screen
      stackBars(); //SO LONG MY FRIEND
      //barsToWedges(pie);
    }
    if (barsAreDoneAnimating()) {
      moveUp();
    }
  }

  public void barsToWedges(pieChart pie) {
    barsHidden = true;
    for (int i=0; i<bars.size (); i++) {
      Bar bar = bars.get(i);
      //make a wedge
      beginShape();
      vertex(bar.xCoord, bar.yCoord + bar.bHeight);
      vertex(bar.xCoord + bar.bWidth, bar.yCoord + bar.bHeight);
      vertex(bar.pointX, bar.pointY);
      endShape();
    }
  }


  public void shrink() {
    float pxShrink = 2;
    float masterBarHeight = 3* (paddedHeight / 4);
    for (int i=0; i<bars.size (); i++) {
      float finalBarHeight = ( bars.get(i).value / this.sumBarValues ) * masterBarHeight;
      if ((paddedHeight - bars.get(i).yCoord) > finalBarHeight) {
        bars.get(i).yCoord += pxShrink;
        bars.get(i).bHeight -= pxShrink;
        this.barIsAnimating[i] = true;
      } else {
        this.barIsAnimating[i] = false;
      }
    }
  }

  public void stackBars() {
    //find middle bar
    int iMiddle = bars.size()/2;
    //move to middle
    moveToMiddle(iMiddle);
    int yCoord = (int)bars.get(0).yCoord - 10;
    //iterate outward in both directions and move to middle
    int iRight = iMiddle + 1;
    int iLeft = iMiddle - 1;
    int iCur = iRight;
    for (int i=0; i< bars.size () - 1; i++) {
      //only increment when current is done
      if (!barIsAnimating[iCur]) {
        if ( i%2 == 0 ) {
          iCur = iLeft;
          iLeft--;
        } else {
          iCur = iRight;
          iRight++;
        }
        moveToMiddle(iCur);
      }
    }
  }

  public void moveUp() {
    int middlePosY = Math.round(this.h / 2) - Math.round(bars.get(0).bHeight / 2);
    float pxMove = 5;
    for (int i=0; i< bars.size (); i++) {
      int barPosY = (int)bars.get(i).yCoord;
      if (barPosY > middlePosY) {
        bars.get(i).yCoord -= pxMove;
        this.barIsAnimating[i]=true;
      } else {
        this.barIsAnimating[i]=false;
      }
    }
  }

  //move bar.get(i) to middle and move it to appropriate height
  public void moveToMiddle(int i) {
    //casting everything to ints to avoid infinite loop of trying to become center
    //i.e. bar's xPos is 10.7px and middleX is 10px

    int middlePosX = Math.round(this.w / 2) - Math.round(bars.get(0).bWidth / 2);
    float pxMove = 5;
    int barPosX = (int)bars.get(i).xCoord;
    int barPosY = (int)bars.get(i).yCoord;
    int y = (int)(this.paddedHeight) - 200;
    if (barPosX < middlePosX) {
      bars.get(i).xCoord += pxMove;
      this.barIsAnimating[i]=true;
    } else if (barPosX > middlePosX) {//if right of middleX, move left
      bars.get(i).xCoord -= pxMove;
      this.barIsAnimating[i]=true;
    } else {
      this.barIsAnimating[i]=false;
    }
  }
  
  
}

class Button {
  boolean m_isWithin;
  int c; 
  float m_width, m_height;
  float m_posX, m_posY;
  String text; 
  
  Button(int w, int h, int x, int y, String t) {
      m_width = w/3;
      m_height = h/3;
      m_posX = x;
      m_posY = y;
      text = t;
      this.c = color(209, 190, 194); 
  }
    
  public void render(){
    fill(this.c);
    stroke(color(216, 224, 227));
    strokeWeight(0); 
    rect(m_posX, m_posY, m_width, m_height, 5);
    fill(0); 
    textSize(20); 
    text(this.text, m_posX + (m_width/4), m_posY + m_height / 2);
  }
  
  public boolean intersect( int mousex, int mousey ){
    setWithin(mousex,mousey);
    return isWithin();
  }
  
  public void setWithin( int mousex, int mousey ) {
    if( mousex >= m_posX && mousex <= (m_posX + m_width) &&
        mousey >= m_posY && mousey <= (m_posY + m_height) ) {
        m_isWithin = true;
    }
    else {
      m_isWithin = false;
    }
  }
  
  public void setWidth( float w ) {
    m_width = w;
  }
  
  public void setHeight( float h ) {
    m_height = h;
  }
  
  public void setPosX( float x ) {
    m_posX = x;
  }
  
  public void setPosY( float y ) {
    m_posY = y;
  }
  
  public void setText( String t ) {
    text = t;
  }
  
  public void setColor(int c) {
    this.c = c; 
  }
  
  public boolean isWithin() {return m_isWithin;}
  public float getPosX() {return m_posX;}
  public float getPosY() {return m_posY;}
  public float getWidth() {return m_width;}
  public float getHeight() {return m_height;}
  public String getText() {return text;}
}
class MyCircle {
  boolean isect;
  float radius;
  float posx, posy;
  int c;
  
  MyCircle() {
     isect = false;
     radius = random(10, 100);
     posx = random(radius, width-radius);
     posy = random(radius, height-radius);
     //c = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
     c = color(80, 50, 70);
  }

  MyCircle(MyCircle circle) {
    this.isect = circle.isect;
    this.radius = circle.radius;
    this.posx = circle.posx;
    this.posy = circle.posy;
    this.c = circle.c;
  }
  
  public boolean intersect (int mousex, int mousey) {
    float distance = sqrt((mousex - posx) * (mousex - posx) + 
                          (mousey - posy) * (mousey - posy));
    if (distance < radius) {
      isect = true;
    }
    else {
      isect = false;
    }
    return isect;
  }
  
  public void setSelected (boolean s) {
    isect = s;
  }

  public void setPos(float x, float y) {
    posx = x;
    posy = y;
  }
  
  public void setColor (int r, int g, int b) {
    c = color (r, g, b);
  }
  
  public void setRadius ( float r ) { radius = r; }
  
  public void render() {
    fill(c);
    ellipse(posx, posy, radius * 2, radius * 2 );
  }
  
  
}
class LineGraph {
  //XYAxis axis;
  ArrayList<Point> points;
  ArrayList<Point> backupPoints;
  float w, h;
  float leftSpacing;
  float rightSpacing;
  float paddedHeight;
  float min, max; 
  ArrayList<Boolean> isAnimating;
  float xDelta, yDelta;
  boolean firstRender = true;

  LineGraph(float w, float h) {
    this.xDelta = 12.5f;
    this.yDelta = 12.5f;
    this.w = w;
    this.h = h - 100;
    this.leftSpacing = 40;
    this.rightSpacing = width/4;
    this.paddedHeight = height - 100;
    this.points = new ArrayList<Point>(); 
    this.backupPoints = new ArrayList<Point>(); 
    this.isAnimating = new ArrayList<Boolean>();
  } 

  public void setAxis( XYAxis a) {
    axis = a;
  }

  public void addPoint( String lbl, int val) {
    Point p = new Point(lbl, val);
    Point p2 = new Point(lbl, val);
    points.add(p);
    this.backupPoints.add(p2);
    this.isAnimating.add(false);
  }

  public void setGeometry(BarGraph barGraph) { 
    float numPoints = this.points.size(); 
    float totalSpacing = numPoints - 1;
    float xInterval = (width - this.leftSpacing - width/4) / numPoints; 
    float yInterval = 2.0f; 
    barGraph.setGeometry(); 
    if (this.firstRender) {
      for (int i = 0; i < numPoints; i++) {
          //*
        this.points.get(i).setCoord(barGraph.bars.get(i).pointX, 
                               barGraph.bars.get(i).pointY); 
        this.backupPoints.get(i).setCoord(barGraph.bars.get(i).pointX, 
                                     barGraph.bars.get(i).pointY);
        //*/
      }
      this.firstRender = false;
    }
  }

  public void connectTheDots(float stepVal) {
    for (int i = 0; i < this.points.size () - 1; i++) {
      fill(color(0));
      strokeWeight(2);
      float newX = lerp(this.backupPoints.get(i).getPosX(), 
      this.backupPoints.get(i+1).getPosX(), 
      stepVal);
      float newY = lerp(this.backupPoints.get(i).getPosY(), 
      this.backupPoints.get(i+1).getPosY(), 
      stepVal);
      line(this.backupPoints.get(i).getPosX(), 
      this.backupPoints.get(i).getPosY(), 
      newX, 
      newY);
    }
  }

  public void connectTheDots() {
    for (int i = 0; i < this.points.size () - 1; i++) {                     
      fill(color(0));
      strokeWeight(2); 
      line(this.points.get(i).getPosX(), 
      this.points.get(i).getPosY(), 
      this.backupPoints.get(i+1).getPosX(), 
      this.backupPoints.get(i+1).getPosY());
    }
  }

  /* bit of a cop out, but should look better with some coloring tweaks */
  public void disconnectTheDots(float stepVal) {
    for (int i = 0; i < this.points.size () - 1; i++) {
      fill(color(255));
      stroke(color(255)); 
      strokeWeight(2);
      float newX = lerp(this.backupPoints.get(i).getPosX(), 
      this.backupPoints.get(i+1).getPosX(), 
      stepVal);
      float newY = lerp(this.backupPoints.get(i).getPosY(), 
      this.backupPoints.get(i+1).getPosY(), 
      stepVal);
      line(this.backupPoints.get(i).getPosX(), 
      this.backupPoints.get(i).getPosY(), 
      newX, 
      newY);
    }
  }
  public boolean isSafeToAnimate() {
    for (boolean b : this.isAnimating) if (b) return false;
    return true;
  }

  public void startAnimating() {
    for (int i = 0; i < this.isAnimating.size (); i++) {
      this.isAnimating.set(i, true);
    }
  }

  /* old disconnect the dots */
  public void disconnectTheDotsTest(float stepVal) {
    stroke(color(255, 0, 0));
    fill(color(255, 0, 0));
    strokeWeight(2); 
    for (int i = 0; i < this.points.size () - 1; i++) {
      Point thisPoint = this.points.get(i);
      Point thisPointBack = this.backupPoints.get(i);
      Point thatPoint = this.backupPoints.get(i+1);
      float newX = lerp(thisPointBack.getPosX(), thatPoint.getPosX(), stepVal);
      float newY = lerp(thisPointBack.getPosY(), thatPoint.getPosY(), stepVal); 
      this.points.get(i).change(newX, newY);
      line(newX, 
      newY-5, 
      thatPoint.getPosX(), 
      thatPoint.getPosY()-5);
    }
  }

  public void moveDotsTo(float destX, float destY, float stepVal) {
    for (int i = 0; i < this.points.size (); i++) {
      float currX = lerp(this.backupPoints.get(i).getPosX(), destX, stepVal);
      float currY = lerp(this.backupPoints.get(i).getPosY(), destY, stepVal);
      this.points.get(i).setCoord(currX, currY);
      this.points.get(i).render();
    }
  }

  public void reset() {
    this.points.clear();
    for (Point p : this.backupPoints) {
      this.points.add(new Point(p));
    }
    this.startAnimating();
    this.firstRender = true;
  }

  public void render(BarGraph barGraph) {
    setGeometry(barGraph); 
    for (Point p : this.points) {
      p.render();
    }
    connectTheDots();
  }


  public void drawPoints(BarGraph barGraph) {
    setGeometry(barGraph);
    for (Point p : this.points) {
      p.render();
    }
  }

  public void drawBars(BarGraph barGraph, float stepVal, float stepHeight) {
    ArrayList<Bar> bars = barGraph.bars;
    float finalBarHeight = 0; 
    for (int i=0; i< bars.size (); i++) {
      if (stepHeight < bars.get(i).bHeight) {
        Bar newBar = bars.get(i); 
        newBar.yCoord += stepVal;
        newBar.bHeight = stepHeight; 
        newBar.render(); 
       } else {
         bars.get(i).render(); 
       }
    }
  }

  public void drawBarsUp(BarGraph barGraph, float stepVal, float stepHeight) {
    ArrayList<Bar> bars = barGraph.bars;
    for (int i=0; i< bars.size (); i++) {
      Bar newBar = bars.get(i); 
      if (stepVal * newBar.bHeight < this.points.get(i).pointPosY) {
        newBar.bHeight = (1.0f - stepVal)  * (barGraph.paddedHeight - this.points.get(i).pointPosY);
        newBar.render(); 
       } else {
         bars.get(i).render(); 
       }
    }
  }
}





class Parser {
    String xTitle;
    String[] columnNames;
    LinkedHashMap<String, HashMap<String, Float>> labelToAttrib;
    HashMap<String, Float> totalSums;

    Parser (String filename) {
        this(filename, false);
    }
    Parser( String filename, boolean debug) {
        Table t = loadTable(filename, "header");
        this.labelToAttrib = new LinkedHashMap<String, HashMap<String, Float>>();
        this.totalSums = new HashMap<String, Float>();
        String label; 
        HashMap<String, Float> attribs;

        /*
         * getColumnTitles is undocumented in processing. But it seems to work.
         * The first column title in the csv is the title of the labels,
         * so we don't want to use that when we're getting values.
         */
        this.columnNames = t.getColumnTitles();
        this.xTitle = this.columnNames[0];

        for (TableRow row : t.rows()) {
            
            attribs = new HashMap<String, Float>();
            /* Get the label of the row - "Dog" in our example */
            label = row.getString(xTitle);

            /*
             * Again, because first thing is the title of the label, we don't 
             *  want it.
             */
            for (int i = 1; i < columnNames.length; i++) {
                /* 
                 * Get key and value to put in the attribute map
                 *   "Lenth" and 4.0 in our example. 
                 * Go through all of the column names and do this.
                 */
                String keyName = this.columnNames[i];
                float value = row.getFloat(keyName);

                /* Build the 'attributes' Mapping */
                attribs.put(keyName, value);

                /*
                 * Basic counter implementation to keep track of the 
                 * total sum for any given column
                 */
                if (this.totalSums.containsKey(keyName)) {
                    this.totalSums.put(keyName, totalSums.get(keyName) + value);
                } else {
                    this.totalSums.put(keyName, value);
                }
            }

            /* 
             *  In the outer hashmap, set the label to point to its attributes 
             */
            this.labelToAttrib.put(label, attribs);
        }
        
        if (debug) {
            println("VALUES");
            for ( Entry<String, HashMap<String, Float>> entry : this.labelToAttrib.entrySet() ) {
                println(entry.getKey() + ": ");
                for (Entry<String, Float> e : entry.getValue().entrySet() ) {
                    println("\t" + e.getKey() + ": " + e.getValue());
                }
            }
        
            println("LABELS: ");
            for (String s : this.columnNames) {
                println(s + ": " + this.totalSums.get(s));
            }
        }
    }

    public String[] getColumnNames() {
        return this.columnNames;
    }

    public LinkedHashMap<String, HashMap<String, Float>> getLabelToAttribMap() {
        return this.labelToAttrib;
    }

    public HashMap<String, Float> getTotalSums() {
        return this.totalSums;
    }

    public String getXTitle() {
        return this.xTitle;
    }
}
class Point{
  MyCircle circle;
  int value;
  String label;
  float pointPosX, pointPosY;
  
  Point() {
    circle = new MyCircle();
    value = 0;
    label = "";
  }

  Point(Point p) {
    circle = new MyCircle(p.circle);
    value = p.value;
    label = p.label;
    pointPosX = p.pointPosX;
    pointPosY = p.pointPosY;
  }
  
  Point( String l, int val){
    this();
    value = val;
    label = "(" +l + ", " + value + ")";
  }
  
  Point( int posx, int posy, String l, int val) {
    this(l, val);
    setCoord( posx, posy );
  }
  
  public Point setCoord( float posx, float posy){
    pointPosX = posx;
    pointPosY = posy;
    circle.setPos( pointPosX,pointPosY);
    circle.setRadius(5.0f);
    return this;
  }
  
  public void render(){
    circle.render();
  }
  
  public void setLabel( String s ){
    label = s;
  }
  
  public void intersect(int posx, int posy){
    if(circle.intersect(posx,posy)){
      fill(color(255, 0, 0));
      text( label, circle.posx - 25, circle.posy - 10);
      fill(color(0));
    }
  }
  
  public float getPosX(){return pointPosX;}
  public float getPosY(){return pointPosY;}


  public Point change(float newX, float newY) {
    // pointPosX = this.pointPosX - xDelta;
    // pointPosY = this.pointPosY - yDelta;
    this.pointPosX = newX;
    this.pointPosY = newY;
    //this.setCoord(newX, newY);
    return this;
  }

  public void print() {
    println("Point at (" + this.pointPosX + ", " + this.pointPosY + ")");
  }

  public String toString() {
    return "(" + this.pointPosX + ", " + this.pointPosY + ")";
  }
}
class XYAxis {
  String xLabel, yLabel;
  int xInterval, yInterval;
  int xLength, yLength;
  int xAxis_x, xAxis_y, yAxis_x, yAxis_y;
  int xNumTicks, yNumTicks;
  int tickLength;
  
  XYAxis() {
    xLabel = "X-Axis";
    yLabel = "Y-Axis";
    xInterval = 1;
    yInterval = 1;
    xLength = width - width / 4;
    yLength = height - height / 4;
    xAxis_x = width / 8 + width / 16;
    xAxis_y = height - height / 8;
    yAxis_x = xAxis_x;
    yAxis_y = xAxis_y;
    xNumTicks = 10;
    yNumTicks = 10; 
    tickLength = 10;
  }
  
  public void setXLabel( String x ) {xLabel = x;}
  public void setYLabel( String y ) {yLabel = y;}
  public void setXInterval( int x ) {xInterval = x;}
  public void setYInterval( int y ) {yInterval = y;}
  public void setXNumTicks( int x ) {xNumTicks = x;}
  public void setYNumTicks( int y ) {yNumTicks = y;}
  
  public void update() {
      xLength = width - width / 4;
      yLength = height - height / 4;
      xAxis_x = width / 8 + width / 16;
      xAxis_y = height - height / 8;
      yAxis_x = xAxis_x;
      yAxis_y = xAxis_y;
      xInterval = xLength / xNumTicks;
      yInterval = yLength / yNumTicks;  
  }
  
  public void render() {
    // draw axis
    line(xAxis_x, xAxis_y, xAxis_x + xLength, xAxis_y);
    line(yAxis_x, yAxis_y, xAxis_x, yAxis_y - yLength);
    // draw X ticks
    int xTick_x = xAxis_x;
    int xTick_y = xAxis_y + tickLength / 2;
    int xTick_height = xTick_y - tickLength;
    for(int i=0; i< xNumTicks; i++) {
      xTick_x += xInterval;
      line(xTick_x, xTick_y, xTick_x, xTick_height);
    }
    // draw Y ticks
    int yTick_x = yAxis_x - tickLength / 2;
    int yTick_y = yAxis_y;
    int yTick_length = yTick_x + tickLength;
    //manually slap in the zero index on the axis
    text(0, yTick_x - 17, xAxis_y+5);
    for(int i=0; i< yNumTicks; i++) {
      yTick_y -= yInterval;
      line(yTick_x, yTick_y, yTick_length, yTick_y);
      text(i+1, yTick_x - 17, yTick_y+5);
    }
    // draw text labels
    fill( color(0,0,0) );
    text(xLabel, xAxis_x + xLength / 2, xAxis_y + 20);
    text(yLabel, yAxis_x - 73, yAxis_y - yLength / 2);
  }
  
  public int getTickX(int i) {
    return xAxis_x + ((i+1) * xInterval);
  }
  
  public int getTickY(int val) {
    return yAxis_y - (val * yInterval); 
  }
  
}
class pieChart {
  private ArrayList<Float> angles; 
  private ArrayList<Float> backupAngles;
  private float diameter; 
  private float lastAngle; 
  private int index; 
  private int rightSpacing;
  private float widthDivider;
  ArrayList<Point> pointsToMove;
  private float endX, endY;
  private float startX, startY;
 
  pieChart(float diameter) {
    this.angles = new ArrayList<Float>(); 
    this.backupAngles = new ArrayList<Float>(); 
    this.pointsToMove = new ArrayList<Point>(); 
    this.diameter = diameter; 
    this.lastAngle = 0; 
    this.index = 0; 
    this.rightSpacing = width/4; 
    this.widthDivider = 1.0f;
    this.endX = 0.0f;
    this.endY = 0.0f;
  }
  
  public void addAngle(float ratio) {
     float w = width - this.rightSpacing; 
     this.angles.add(ratio * 360); 
     this.backupAngles.add(ratio * 360); 
     this.pointsToMove.add(new Point());
     this.startY = height/2; // w/2 + diameter/1.0 * cos(this.angles.get(0));
     this.startX = w/2 + this.rightSpacing; // height/2 + diameter/4.0 * sin(this.angles.get(0));
  }
  
  public void render() {
      float lastAngle = 0; 
      stroke(color(0));
      strokeWeight(2); 
      fill(255); 
      float w = width - this.rightSpacing; 
      for (int i = 0; i < this.angles.size(); i++) {
        float nextAngle = lastAngle + radians(this.angles.get(i));
        arc(w/2, 
             height/2, 
             diameter * this.widthDivider, 
             diameter * this.widthDivider, 
             lastAngle, 
             nextAngle);
        line(w/2,
             height/2,
             w/2 + diameter/2.0f * cos(nextAngle),
             height/2 + diameter/2.0f * sin(nextAngle) );
        lastAngle += radians(this.angles.get(i));
      }
      
      strokeWeight(0); 
  }

  public void shrink(float stepVal) {
        this.widthDivider *= stepVal;
        float inverseStep = 1.0f - stepVal;
        for(int i = 0; i < this.angles.size(); i++) {
            this.angles.set(i, this.angles.get(i) * inverseStep);
        }
        float w = width - this.rightSpacing;
        for (int i = 0; i < this.pointsToMove.size(); i++) {
            pointsToMove.get(i).setCoord(w/2 + diameter/2.0f * cos(0),
                                         height/2 + diameter/2.0f * sin(0)
                                        );
        }
        this.endX = w/2 + diameter/4.0f;
        this.endY = height/2;
  }

  public void grow(float stepVal) {
       // this.widthDivider *= stepVal;
        for(int i = 0; i < this.angles.size(); i++) {
            this.angles.set(i, this.backupAngles.get(i) * stepVal);
        }
        float w = width - this.rightSpacing;
        for (int i = 0; i < this.pointsToMove.size(); i++) {
            pointsToMove.get(i).setCoord(w/2 + diameter/2.0f * cos(0),
                                         height/2 + diameter/2.0f * sin(0));
        }
  }

  public void makeLine(float stepVal, LineGraph lineGraph) {
    for(int i = 0; i < pointsToMove.size(); i++) {
        /*
        float newX = lerp(lineGraph.points.get(i).getPosX(),
                          this.startX,
                          stepVal);
        float newY = lerp(lineGraph.points.get(i).getPosY(), 
                          this.startY, 
                          stepVal);
        // */
        float newX = lerp(this.startX,
                          lineGraph.points.get(i).getPosX(),
                          stepVal);
        float newY = lerp(this.startY, 
                          lineGraph.points.get(i).getPosY(), 
                          stepVal);

        //pointsToMove.get(i).setCoord(width - newX, height - newY).render();
        pointsToMove.get(i).setCoord(newX, newY).render();
    }
  }
  
  public void drawNextWedge() {
    stroke(color(0));
    float gray = map(this.index, 0, this.angles.size(), 100, 255); 
    fill(gray);

    arc(width/2, 
        height/2, 
        diameter, 
        diameter, 
        this.lastAngle, 
        this.lastAngle + radians(this.angles.get(this.index))
        );

    this.lastAngle += radians(this.angles.get(this.index));
    this.index++;   
  }
  
  public void reset() {
    this.angles.clear();
    this.widthDivider = 1.0f;
    for (float angle : this.backupAngles) {
      this.angles.add(angle);
    }
  }

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "A2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
