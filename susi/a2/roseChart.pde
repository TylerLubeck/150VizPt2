class RoseChart implements Cloneable {
  color[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
//    color(, 0, 255), color(0, 255, 0), color(255, 0, 0), color(0, 255, 255), color(255, 0, 255)};
  color highlight = color(255, 255, 0);
  
  ArrayList<String> labels;
  ArrayList<ArrayList<Float>> values;
  ArrayList<Float> valuesPerCat;
  int totalNumPeople;
  String toolTip;
  boolean lastLevel;
  float centerX, centerY, maxRadius, angle, unit, maxValue;
  int interval, tintValue;
    
  RoseChart(ArrayList<String> labels, ArrayList<ArrayList<Float>> values) {
    this.labels = labels;
    this.values = values;
    angle = 360.0 / labels.size();
    valuesPerCat = new ArrayList<Float>();
    calcValPerCat();
    toolTip = "";
    this.lastLevel = lastLevel;
    this.maxValue = getMaxValue();
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
  
  void draw(float centerX, float centerY, float radius) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.maxRadius = radius;
    float currentAngle = 270.0;
    ArrayList<Float> clonedVals = (ArrayList<Float>)valuesPerCat.clone();
    calcAxisVals();
    toolTip = "";
    int colorIndex = 0; //values.size() % colors.length;
    for (int i = 0; i < valuesPerCat.size(); ++i) {
      for (int j =values.size() -1; j >=0; --j) {
        fill(colors[colorIndex], (j == 0? 255 : tintValue));
        if (j != 0)
          stroke(0, tintValue);
        else
          stroke(0);
        arc(centerX, centerY, 2* unit * clonedVals.get(i), 2* unit * clonedVals.get(i), radians(currentAngle - angle), radians(currentAngle),  PIE);
        clonedVals.set(i, clonedVals.get(i) - values.get(j).get(i));
        colorIndex = j % colors.length;
      }
      currentAngle -= angle;
    }
    drawLabels();
  }
  
  void drawLabels(int tintVal) {
   this.tintValue = tintVal;
   drawLabels(); 
  }
  
  void drawLabels() {
    float currentAngle = 270;
    calcAxisVals();
    float endX, endY;
    int intervalY = ceil(maxValue / 10.0);
    for (int i = 0; i < labels.size(); ++i) {
      endX = centerX + maxRadius * cos(radians(currentAngle));
      endY = centerY + maxRadius * sin(radians(currentAngle));
      stroke(0, tintValue);
      line(centerX, centerY, endX, endY);
      currentAngle -= angle;
    }
    for (int i = 1; i < 11; ++i) {
      noFill();
      ellipse(centerX, centerY, 2*i*intervalY * unit, 2*i*intervalY * unit);
      fill(0, tintValue);
      textAlign(TOP);
      text(i*intervalY, centerX, centerY - i*intervalY * unit);
    }
  }
  void setTint(int tint) {
    tintValue = tint;
  }
  
  void calcAxisVals() {
    unit = (height/3 / maxValue)/1.1;
    interval = ceil(maxValue/10.0);
  }
}

