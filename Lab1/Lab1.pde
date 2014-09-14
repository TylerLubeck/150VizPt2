import java.util.Map;
UIButton myButton;
XYAxis xyAxis;
LineGraph lGraph;
BarGraph bGraph;
Graphs graphType;
int maxNum;
Table table;
String switchToLine, switchToBar;

HashMap<String, Integer> data;

void setup() {
  size(400, 400);
  maxNum = 0;
  
  data = new HashMap<String, Integer>();
  table = loadTable("lab1-data.csv", "header");

  for (TableRow row : table.rows ()) {
      int count = row.getInt(" Number");
      if (count > maxNum) {
          maxNum = count; 
      }
      data.put(row.getString("Name"), count);
  }
  
  //create axis
  xyAxis = new XYAxis();
  xyAxis.setXLabel("Fruits");
  xyAxis.setYLabel("Amount");
  xyAxis.setYNumTicks(maxNum);
  xyAxis.setXNumTicks(table.getRowCount());
  
  //create linegraph
  lGraph = new LineGraph(xyAxis);
  bGraph = new BarGraph(xyAxis);
   
  for (Map.Entry entry : data.entrySet() ){
    String keyValue = entry.getKey().toString();
    lGraph.addPoint(keyValue, data.get(keyValue)); 
    bGraph.addBar(keyValue, data.get(keyValue));
  }
  
  //Create button that switches between bar and line graphs
  graphType = Graphs.LINE;
  switchToLine = "Switch to Line Graph";
  switchToBar = "Switch to Bar Graph";
  myButton = new UIButton(120, 30, width - 125, 5, color(200), switchToBar);
  
  frame.setResizable(true); 
  background(color(255));
}

void drawLineGraph(){
  lGraph.updateAxis();
  lGraph.drawPoints();
  lGraph.connectTheDots();
  lGraph.render();
}

void drawBarGraph(){
  bGraph.updateAxis();
  bGraph.drawBars();
  bGraph.render();
}

void draw() {
    background(color(255));
    
    myButton.updatePosition(width - 125, 5);
    myButton.render();
    
    if(graphType == Graphs.LINE){
      drawLineGraph();
      for(Point p : lGraph.points){
        p.intersect(mouseX,mouseY);
      }
    } else if(graphType == Graphs.BAR){
      drawBarGraph();
      for(Bar b : bGraph.bars){
        b.intersect(mouseX,mouseY);
      }
    }   
}

void mousePressed(){
  if(myButton.intersect(mouseX,mouseY)){
    if( graphType == Graphs.LINE ){
      myButton.setText(switchToLine);
      graphType = Graphs.BAR;
    } else if(graphType == Graphs.BAR) {
      myButton.setText(switchToBar);
      graphType = Graphs.LINE;
    }
  }
}



