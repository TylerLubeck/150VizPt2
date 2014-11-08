import controlP5.*;
import java.lang.Object;
import java.util.Arrays;

final int NUM_REP = 20;

int chartType;
ArrayList<Integer> visType;
Data d = null;
BarGraph bg;
PieGraph pg;
StackedBar sb;
SqTreeMap sm;

void setup() {
    totalWidth = displayWidth;
    totalHeight = displayHeight;
    chartLeftX = totalWidth / 2.0 - chartSize / 2.0;
    chartLeftY = totalHeight / 2.0 - chartSize / 2.0 - margin_top;
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
    tempIndex = int(random(0, visType.size()));
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

void draw() {
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
                 pg.draw(chartLeftX + chartSize/2, chartLeftY + chartSize/2, chartSize*0.9);
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
            reportPerc = ans / 100.0; // this is the participant's response
            
            error = log(abs(reportPerc - truePerc)*100.0 + 1/8.0) / log(2);

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
          tempIndex = int(random(0, visType.size()));
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
