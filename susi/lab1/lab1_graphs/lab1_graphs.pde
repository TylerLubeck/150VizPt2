
 ArrayList<String> xData;
 ArrayList<Integer> yData;
 boolean isLineGraph;
 LineGraph lineGraph;
 BarGraph barGraph;
 String[] button = {"Bar Graph", "Line Graph"};
 float buttonW, buttonH;
 boolean inTransition;
 int tintVal;
  
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
   
   tintVal = 255;
 }
 
 void draw() {
   background(255, 255, 255);
   fill(220);
   rect(width*0.9 - buttonW, height*0.1, buttonW, buttonH);
   fill(0);
   textAlign(CENTER, CENTER);
   if(inTransition) {
     lineGraph.draw(abs(tintVal-255));
     barGraph.draw(tintVal);
     tintVal = isLineGraph? (tintVal - 5) : (tintVal + 5);
     if (tintVal == 255 || tintVal == 0) {
       inTransition = false;
       tintVal = 255;
     }
   }
   else {
     if(isLineGraph) {
       text(button[0], width*0.9-buttonW/2, height*0.1+9);
     }
     else {
       text(button[1], width*0.9-buttonW/2, height*0.1+9);
     }
      if (isLineGraph) {
        lineGraph.draw(tintVal);
      } else {
        barGraph.draw(tintVal);
      }
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
        inTransition = true;
        tintVal = isLineGraph? 250 : 5;
  }
}
   

