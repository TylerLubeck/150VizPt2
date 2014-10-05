final String FILE_NAME = "Dataset1.csv";
String[] columnNames;
LinkedHashMap<String, HashMap<String, Float>> labelToAttrib;
HashMap<String, Float> totalSums;
String XAxis;
BarGraph bar;
LineGraph lineGraph;
XYAxis axis;
pieChart pie;


void setup() {
    frame.setResizable(true); 
    size(800, 800);
    background(100, 200, 200); 
    Parser p = new Parser(FILE_NAME, /*debug*/ true);
    columnNames = p.getColumnNames();
    labelToAttrib = p.getLabelToAttribMap();
    totalSums = p.getTotalSums();
    XAxis = p.getXTitle();

    /* Create a Bar Chart */
    bar = new BarGraph(width, height);
    for (int i = 1; i < 2; i++) {
        for(Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet()) {
            bar.addBar(e.getKey(), int(e.getValue().get(columnNames[i])));
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
    pie = new pieChart(300.0); 
    for (int i = 1; i < 2; i++) {
        for(Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet()) {
            pie.addAngle(e.getValue().get(columnNames[i]) / totalSums.get(columnNames[i]));
        }
    }
    
    /* Create Buttons */ 
    //Button[] buttons = new Button[3]; 

}

void draw() {
    //bar.render(); 
    //pie.render();
    lineGraph.render();
    drawButtonContainer(); 
    
}

void drawButtonContainer() {
  Button pieButton = new Button(width - width/4, height, width/4, 0, "Pie Chart"); 
  Button lineButton = new Button(width - width/4, height, width/4, 0, "Line Graph"); 
  Button barButton = new Button(width - width/4, height, width/4, 0, "Bar Graph"); 
  fill(255);
  rect(width - width/4, 0, width/4, height, 7); 
  pieButton.render(); 
}


