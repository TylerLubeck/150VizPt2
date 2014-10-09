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
float buttonWidthP = 0.08;
float buttonHeightP = 0.06;
Button pieButton = new  Button(0.90, 0.02, buttonWidthP, buttonHeightP, "Pie");
Button barButton = new  Button(0.90, 0.10, buttonWidthP, buttonHeightP, "Bar");
Button lineButton = new Button(0.90, 0.18, buttonWidthP, buttonHeightP, "Line");
Button roseButton = new Button(0.90, 0.26, buttonWidthP, buttonHeightP, "Rose");
Button stackedButton = new Button(0.90, 0.34, buttonWidthP, buttonHeightP, "Stacked\nBar");
ArrayList<Button> buttons = new ArrayList<Button>();

/* Data lists */
ArrayList<String> labels;
ArrayList<ArrayList<Float>> values;


void setup() {
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

void draw() {
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

void parseData(String dat) {
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

void mousePressed() {
  for (int i = 0; i < buttons.size(); i++)
    if (buttons.get(i).mousePressed(mouseX,mouseY))
      break;
}

void mouseReleased() {
  for (int i = 0; i < buttons.size(); i++)
    buttons.get(i).mouseReleased();
}

void mouseClicked() {
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

