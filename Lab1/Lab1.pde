import java.util.Map;
UIButton myButton;
XYAxis xyAxis;
int maxNum;
Table table;

HashMap<String, Integer> data;

void setup() {
  size(400, 400);
  maxNum = 0;
  
  data = new HashMap<String, Integer>();
  table = loadTable("lab1-data.csv", "header");

  for (TableRow row : table.rows ()) {
      //println(row.getString("Name") + ": " + row.getInt(" Number"));
      int count = row.getInt(" Number");
      if (count > maxNum) {
          maxNum = count; 
      }
      data.put(row.getString("Name"), count);
  }
  
  for (Map.Entry entry : data.entrySet() ){
      println(entry.getKey() + ": " + entry.getValue()); 
  }
   
   frame.setResizable(true); 
   background(color(255));
  
}

void draw() {
    color c = color(200);
    myButton = new UIButton(50, 30, width - 55, 5, c, "Switch");
    xyAxis = new XYAxis();
    xyAxis.setXLabel("Fruits");
    xyAxis.setYLabel("Amount");
    xyAxis.setYNumTicks(maxNum);
    xyAxis.setXNumTicks(table.getRowCount());
    xyAxis.resetIntervals();
    fill(myButton.getColor());
    rect(myButton.getPosX(), myButton.getPosY(), myButton.getWidth(), myButton.getHeight());   
    xyAxis.render();
}

