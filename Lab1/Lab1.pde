import java.util.Map;
UIButton myButton;
XYAxis xyAxis;
LineGraph lGraph;
int maxNum;
Table table;

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
   
  for (Map.Entry entry : data.entrySet() ){
    String keyValue = entry.getKey().toString();
    lGraph.addPoint(keyValue, data.get(keyValue)); 
  }
  frame.setResizable(true); 
  background(color(255));
}

void draw() {
    background(color(255));
    color c = color(200);
    myButton = new UIButton(50, 30, width - 55, 5, c, "Switch");
    
    lGraph.updateAxis();
    lGraph.drawPoints();
    lGraph.connectTheDots();
    
    lGraph.render();
    
    fill(myButton.getColor());
    rect(myButton.getPosX(), myButton.getPosY(), myButton.getWidth(), myButton.getHeight());
    
    fill(color(0,0,0));
    for(Point p : lGraph.points){
      p.intersect(mouseX,mouseY);
    }   
}



