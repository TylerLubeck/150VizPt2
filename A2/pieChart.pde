class pieChart {
  ArrayList<Float> angles; 
  float diameter; 

  pieChart(float diameter) {
    this.angles = new ArrayList<Float>(); 
    this.diameter = diameter; 
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

}
