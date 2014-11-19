class PieGraph {
  color[] colors = {
   color(166,206,227),color(31,120,180),color(178,223,138),color(51,160,44),color(251,154,153),color(227,26,28),
   color(253,191,111),color(255,127,0),color(202,178,214),color(106,61,154)};
  
  Data values;
  ArrayList<Float> angles;
  float totalVal;
  float centerX, centerY, radius;
    
  PieGraph(Data values) {
    this.values = values;
    angles = new ArrayList<Float>();
    calcTotalNum();
    calcAngles();
  }
  
  void calcTotalNum() {
    totalVal = 0;
    for (int i=0; i<values.getSize(); ++i) {
      totalVal += values.getValue(i);
    }
  }
  
  void calcAngles() {
    for (int i = 0; i<values.getSize(); ++i) {
      angles.add(((float)values.getValue(i) / (float)totalVal) * 360.0);
    }
  }
  
  void draw(float centerX, float centerY, float radius) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    float currentAngle = 270;
    float tempX, tempY;
    int colorIndex = 0;
    for (int i =0; i < angles.size(); ++i) {
      stroke(0);
      fill(colors[colorIndex]);
      arc(centerX, centerY, radius, radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
      if (values.isMarked(i)) {
        tempX = centerX + radius /4 * cos(radians(currentAngle - angles.get(i)/2));
        tempY = centerY + radius /4 * sin(radians(currentAngle - angles.get(i)/2));
        fill (0);
        ellipse(tempX, tempY, chartSize*0.02, chartSize * 0.02);
      }
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    }
  }
  
}

