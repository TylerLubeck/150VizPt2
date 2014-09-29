class pieChart {
  private ArrayList<Float> angles; 
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
     this.angles.add(ratio * 360); 
  }
  
  void render() {
      float lastAngle = 0; 
      for (int i = 0; i < this.angles.size(); i++) {
        float gray = map(i, 0, this.angles.size(), 100, 255);
        fill(gray);
        arc(width/2, height/2, diameter, diameter, lastAngle, 
        lastAngle+radians(this.angles.get(i)));
        lastAngle += radians(this.angles.get(i));
      }
  }
  
  void drawNextWedge() {
    float gray = map(this.index, 0, this.angles.size(), 100, 255); 
    fill(gray);
    arc(width/2, height/2, diameter, diameter, this.lastAngle, 
      this.lastAngle + radians(this.angles.get(this.index)));
    this.lastAngle += radians(this.angles.get(this.index));
    this.index++;   
  }
  
  

}
