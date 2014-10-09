
 ArrayList<String> xData, xData2, xData3;
 ArrayList<Integer> yData, yData2, yData3;
 ArrayList<PieGraph> pies;
 int currentIndex;
 boolean inTransition;
 int tintVal;
  
 void step2() {
   size(1200,800);
   frame.setResizable(true);
   textSize(15);
   xData = new ArrayList<String>();
   yData = new ArrayList<Integer>();
   xData2 = new ArrayList<String>();
   yData2 = new ArrayList<Integer>();
   xData3 = new ArrayList<String>();
   yData3 = new ArrayList<Integer>();
   xData.add("a");
   xData.add("b");
   xData.add("c");
   xData.add("d");
   yData.add(45);
   yData.add(77);
   yData.add(200);
   yData.add(111);
   xData2.add("e");
  xData2.add("f");
  xData2.add("g");
  xData2.add("h");
  xData2.add("i");
  xData2.add("j");
  yData2.clear();
  yData2.add(22);
  yData2.add(30);
  yData2.add(1500);
  yData2.add(111);
  yData2.add(77);
  yData2.add(66);
   
   pies = new ArrayList<PieGraph>();
   PieGraph temp = new PieGraph(xData, yData, false);
   pies.add(temp);
   inTransition = false;
   currentIndex = 0;
   tintVal = 255;
 }
 
 void parseData(String category) {
//   for (int i = 0; i < adult.size(); ++i) {
//   }
 }
 
 void draw() {
   background(255, 255, 255);
   println(currentIndex);
   pies.get(currentIndex).draw(width/2, height/2, height/4);
 }
  
  
void mouseClicked() {
  if (mouseButton  == LEFT) {
    if (currentIndex < 2) {
      println(currentIndex);
              println("how many pies? " + pies.size());

      String selection = pies.get(currentIndex).getSelectedCategory();

      if (selection != "") {      
        PieGraph temp = new PieGraph(xData2, yData2, false);
        println("how many pies? " + pies.size());
        pies.add(temp);
        println(pies.size());
        currentIndex++;
        println(currentIndex);
        //move pies.get(currentIndex) to background
      }
    }
  }
  else if (mouseButton == RIGHT && currentIndex != 0){
    //moveforward
    pies.remove(currentIndex);
    currentIndex--;
  }
}
   

