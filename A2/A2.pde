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
float lineToBarStepAmount = 0.0;

void setup() {
  frame.setResizable(true); 
  size(700, 700);
  currentGraph = 1; 
  transitionGraph = 1; 
  buttons = new Button[3]; 
  Parser p = new Parser(FILE_NAME, /*debug*/ true);
  columnNames = p.getColumnNames();
  labelToAttrib = p.getLabelToAttribMap();
  totalSums = p.getTotalSums();
  XAxis = p.getXTitle();

  /* Create a Bar Chart */
  barGraph = new BarGraph(width, height);
  for (int i = 1; i < 2; i++) {
    for (Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet ()) {
      barGraph.addBar(e.getKey(), int(e.getValue().get(columnNames[i])));
    }
  }
  barGraph.doneAddingBars();

  /* Create a Line Graph */
  //lineGraph = new LineGraph(2.0,5.0);
  lineGraph = new LineGraph(width, height); 
  for (int i = 1; i < 2; i++) {
    for (Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet ()) {
      lineGraph.addPoint(e.getKey(), int(e.getValue().get(columnNames[i])));
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



void draw() {
  background(255); 
  drawButtonContainer(); 
  for (Button b : buttons) {
    changeColorOnHover(b);
  }
  transitionBetweenGraphs(); 
}

void transitionBetweenGraphs() {
  switch (currentGraph) {
  case 0: 
    pie.render(); 
    if (transitionGraph == LINE) {
      //transition pie to line  
      currentGraph = 1;
    } else if (transitionGraph == BAR) {
      //transition pie to bar
      currentGraph = 2;
    }
    break;
  case 1: 
    lineGraph.render();
    if (transitionGraph == BAR) {
      // transition line to bar
      currentGraph = 2;
    } else if (transitionGraph == PIE) {
        if ( lineToBarStepAmount < 1.0 ) {
          lineGraph.disconnectTheDots(lineToBarStepAmount);
          lineToBarStepAmount += 0.012;
          println("NEW STEP: " + lineToBarStepAmount);
        } else {
            println("RESETTING");
          lineToBarStepAmount = 0.0;
          lineGraph.reset();
          currentGraph = 0;
        }
    }
    break;
  case 2:
    barGraph.render();
    if (transitionGraph == LINE) {
      // transition bar to line
      currentGraph = 1;
    } else if (transitionGraph == PIE) {
      //transition bar to pie
      currentGraph = 0;
    }
    break;
  }
}

void changeColorOnHover(Button button) {
  if (button.intersect(mouseX, mouseY)) {
    button.setColor(color(80, 50, 70)); 
    button.render();
  }
}


void drawButtonContainer() {
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

void mousePressed() {
  for (int i = 0; i < 3; i++) {
    if (buttons[i].intersect(mouseX, mouseY)) {
      transitionGraph = i; 
    }
  }
}
