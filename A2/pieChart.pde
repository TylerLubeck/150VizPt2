class pieChart {
  private ArrayList<Float> angles; 
  private float diameter; 
  private float lastAngle; 
  private int index; 
  private int rightSpacing;
 
  pieChart(float diameter) {
    this.angles = new ArrayList<Float>(); 
    this.diameter = diameter; 
    this.lastAngle = 0; 
    this.index = 0; 
    this.rightSpacing = width/4; 
  }
  
  void addAngle(float ratio) {
      //println("ADDING ANGLE WITH RATIO: " + ratio);
     this.angles.add(ratio * 360); 
  }
  
  void render() {
      float lastAngle = 0; 
      stroke(color(0));
      strokeWeight(2); 
      fill(255); 
      int w = width - this.rightSpacing; 
      for (int i = 0; i < this.angles.size(); i++) {
        float nextAngle = lastAngle + radians(this.angles.get(i));
        arc(w/2, 
             height/2, 
             diameter, 
             diameter, 
             lastAngle, 
             nextAngle);
        line(w/2,
             height/2,
             w/2 + diameter/2.0 * cos(nextAngle),
             height/2 + diameter/2.0 * sin(nextAngle));
        lastAngle += radians(this.angles.get(i));
      }
      
      strokeWeight(0); 
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
