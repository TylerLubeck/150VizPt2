import java.util.Collections;

class StackedBar {
  color[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
  color highlight = color(255, 255, 0);
  
  ArrayList<String> labels;
  ArrayList<ArrayList<Float>> values;
  ArrayList<Float> valuesPerCat;
  Graph graph;
  int totalNumPeople;
  String toolTip;
  boolean lastLevel;
  float unit, maxValue, zeroY, longestIndex;
  int interval, tintValue;

  StackedBar(ArrayList<String> labels, ArrayList<ArrayList<Float>> values) {
    this.labels = labels;
    this.values = values;
    valuesPerCat = new ArrayList<Float>();
    calcValPerCat();
    maxValue = getMaxValue();
    graph = new Graph(labels, valuesPerCat);
    calcAxisVals();
    tintValue = 255;
  }
  
  void calcValPerCat() {
    for (int i = 0; i<values.get(0).size(); ++i) {
       valuesPerCat.add(0.0);
    } 
    for (int i = 0; i<values.size(); ++i) 
      for (int j = 0; j< values.get(i).size(); ++j)
        valuesPerCat.set(j, valuesPerCat.get(j) + values.get(i).get(j));
  }
 
 float getMaxValue() {
   int maxIndex = valuesPerCat.indexOf(Collections.max(valuesPerCat));
   return valuesPerCat.get(maxIndex);
  }
 
  void draw(int tintVal) {
    graph.draw(0,0,width,height);
    drawBars(tintVal);
  }

  void drawBars(int tintVal){
    zeroY = graph.zeroY;
    unit = graph.unit;
    float xInterval = width*0.8 / (float(labels.size()) + 1.0);
    float tickX = width*0.1 + xInterval;
    float upperX, upperY, widthB, heightB;
    int colorIndex = 0; 
       
    for (int i = 0; i < valuesPerCat.size(); ++i) {
      upperX = tickX-(xInterval*0.9)/2;
      upperY = zeroY-unit*valuesPerCat.get(i);
      widthB = xInterval*0.9;
      heightB = unit*valuesPerCat.get(i);
      for (int j =values.size() -1; j >=0; --j) {
        if (j != 0)
          stroke(0, tintValue);
        else
          stroke(0);
        fill(colors[colorIndex], (j == 0? 255 : tintValue));
        rect(upperX, upperY, widthB, heightB);
        upperY += values.get(j).get(i)*unit;
        heightB -= values.get(j).get(i) *unit;
        colorIndex = j % colors.length;
      }
    
      tickX+= xInterval;
      
    } 
  }
  
  float getWidth() {
    return width*0.8 / (float(labels.size()) + 1.0) * 0.9;
  }
  float getUnit() {
    return (height*0.75  /(maxValue))/1.1;
  }
  void setTint(int tint) {
    tintValue = tint;
  }
  
  
  void calcAxisVals() {
    unit = graph.unit;
    interval = ceil(maxValue/10.0);
  }
}

