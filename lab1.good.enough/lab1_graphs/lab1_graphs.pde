
 ArrayList<String> xData;
 ArrayList<Integer> yData;
 boolean isLineGraph;
 LineGraph lineGraph;
 BarGraph barGraph;
 String[] button = {"Bar Graph", "Line Graph"};
 float buttonW, buttonH;
  
 void setup() {
   size(600,600);
   frame.setResizable(true);
   textSize(15);
   buttonW = max(textWidth(button[0]), textWidth(button[1])) + 4;
   buttonH = 18;
   xData = new ArrayList<String>();
   yData = new ArrayList<Integer>();
   isLineGraph = true; // true = line graph
   
   parseData("lab1-data.csv");
   
   lineGraph = new LineGraph(xData, yData);
   barGraph = new BarGraph(xData, yData);
 }
 
 void draw() {
   background(255, 255, 255);
   fill(220);
   rect(width*0.9 - buttonW, height*0.1, buttonW, buttonH);
   fill(0);
   textAlign(CENTER, CENTER);
   if(isLineGraph) {
     text(button[0], width*0.9-buttonW/2, height*0.1+9);
   }
   else {
     text(button[1], width*0.9-buttonW/2, height*0.1+9);
   }
    if (isLineGraph) {
      lineGraph.draw();
    } else {
      barGraph.draw();
    }
 }
  
  
 void parseData(String file) {
   String data[] = loadStrings(file);
   
   for (int i=1; i < data.length; i++) {
      String temp[] = splitTokens(data[i], ", "); 
      String name = trim(temp[0]);
      int number = Integer.parseInt(trim(temp[1]));
      xData.add(name);
      yData.add(number);
   }
 }
 
void mouseClicked() {
  if (mouseX <= width* 0.9 && mouseX >= (width*0.9 - buttonW) 
      && mouseY >= height*0.1 && mouseY <= (height*0.1 + buttonH)) {
        isLineGraph = !isLineGraph;
  }
}
   

