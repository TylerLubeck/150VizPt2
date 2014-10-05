class pieChart {
  private ArrayList<Float> angles; 
  //private ArrayList<color> colors;
  private float diameter; 
  private float lastAngle; 
  private int index; 
  
  pieChart(float diameter) {
    this.angles = new ArrayList<Float>(); 
    this.diameter = diameter; 
    this.lastAngle = 0; 
    this.index = 0; 
  }
  
  void addAngle(float ratio) {
     println("ADDING ANGLE WITH RATIO * 360 = " + (ratio*360));
     this.angles.add(ratio * 360); 
  }
  
  void render() {
      float lastAngle = 0; 
      stroke(color(0));
      for (int i = 0; i < this.angles.size(); i++) {
        int c = (int)map(i, 0, this.angles.size(), 0, 255);         
        float nextAngle = lastAngle + radians(this.angles.get(i));
        arc(width/2, 
             height/2, 
             diameter, 
             diameter, 
             lastAngle, 
             nextAngle);
        line(width/2,
             height/2,
             width/2 + diameter/2.0 * cos(nextAngle),
             height/2 + diameter/2.0 * sin(nextAngle));
        lastAngle += radians(this.angles.get(i));
      }
  }
  
  void drawNextWedge() {
    stroke(color(0));
    float gray = map(this.index, 0, this.angles.size(), 100, 255); 
    fill(gray);
    arc(width/2, height/2, diameter, diameter, this.lastAngle, 
      this.lastAngle + radians(this.angles.get(this.index)));
    this.lastAngle += radians(this.angles.get(this.index));
    this.index++;   
  }
  
  

}
