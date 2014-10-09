String data = "Dataset1.csv";
//String data = "Dataset2.csv";

BarGraph barGraph;
LineGraph lineGraph;
LineToBar lineToBarAnim;
BarToLine barToLineAnim;
ArrayList<String> labels;
ArrayList<ArrayList<Float>> values;
boolean inTransition, bar, pie, lineG, toPie, toBar, toLine;

void setup() {
  parseData(data);
  frame.setResizable(true);
  size(600, 400);
  barGraph = new BarGraph(labels, values.get(0));
  lineGraph = new LineGraph(labels, values.get(0));


  lineToBarAnim = new LineToBar(lineGraph, barGraph);
  barToLineAnim = new BarToLine(lineGraph, barGraph);

  inTransition = pie = lineG = toPie = toBar = toLine = false;
  bar = true;
  lineG = true;
}

void draw() {
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

void mouseClicked() {
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
