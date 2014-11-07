class PieGraph {
  
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
    for (int i =0; i < angles.size(); ++i) {
      stroke(0);
      fill(70, 170, 208);
      arc(centerX, centerY, radius, radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
      if (values.isMarked(i)) {
        tempX = centerX + radius /4 * cos(radians(currentAngle - angles.get(i)/2));
        tempY = centerY + radius /4 * sin(radians(currentAngle - angles.get(i)/2));
        fill (0);
        ellipse(tempX, tempY, chartSize*0.02, chartSize * 0.02);
      }
      currentAngle -= angles.get(i);
    }
  }
  
}

