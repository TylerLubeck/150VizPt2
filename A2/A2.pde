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
Button[] buttons; 

void setup() {
    frame.setResizable(true); 
    size(800, 800);
    currentGraph = 0; 
    buttons = new Button[3]; 
    Parser p = new Parser(FILE_NAME, /*debug*/ true);
    columnNames = p.getColumnNames();
    labelToAttrib = p.getLabelToAttribMap();
    totalSums = p.getTotalSums();
    XAxis = p.getXTitle();

    /* Create a Bar Chart */
    barGraph = new BarGraph(width, height);
    for (int i = 1; i < 2; i++) {
        for(Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet()) {
            barGraph.addBar(e.getKey(), int(e.getValue().get(columnNames[i])));
        }
    }

    /* Create a Line Graph */
    //lineGraph = new LineGraph(2.0,5.0);
    lineGraph = new LineGraph(600, 600); 
    for (int i = 1; i < 2; i++) {
        for(Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet()) {
            lineGraph.addPoint(e.getKey(), int(e.getValue().get(columnNames[i])));
        }
    }
    
    /* Create a Pie Chart */
    pie = new pieChart(width/2); 
    for (int i = 1; i < 2; i++) {
        for(Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet()) {
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
    switch (currentGraph) {
      case 0: 
        pie.render();     
        break;
      case 1: 
        lineGraph.render(); 
        break;
      case 2:
        barGraph.render();
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
      switch (i) {
        case 0:
          //transition(buttons[currentGraph], pieChart)
          currentGraph = 0; 
          break; 
        case 1:
          //transition(buttons[currentGraph], lineGraph)
          currentGraph = 1; 
          break; 
        case 2: 
          //transition(buttons[currentGraph], barChart) 
          currentGraph = 2; 
          break;  
      }
    }
  }
}



