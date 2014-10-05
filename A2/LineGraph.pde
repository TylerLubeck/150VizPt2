class LineGraph{
  //XYAxis axis;
  ArrayList<Point> points;
  float w, h;
  float leftSpacing;
  float rightSpacing;
  float paddedHeight;
  float min, max; 
     
  LineGraph(float w, float h) {
    this.w = w;
    this.h = h - 100;
    this.leftSpacing = 40;
    this.rightSpacing = width/4;
    this.paddedHeight = height - 100;
    this.points = new ArrayList<Point>(); 
  } 
  
  void setAxis( XYAxis a) {
    axis = a;
  }
  
  void addPoint( String lbl, int val){
    Point p = new Point(lbl,val);
    points.add(p);
  }
  
  void findMax() {
    this.max = 0; 
    for (Point p : this.points) {
      if (p.value > this.max) {
        this.max = p.value;
      }
    }
  }
  void findMin() {
    this.min = Float.POSITIVE_INFINITY; 
    for (Point p : this.points) {
      if (p.value < this.min) {
        this.min = p.value; 
      }
    }
  }

  void setGeometry() {
    findMax();
    findMin();  
    float numPoints = points.size(); 
    float totalSpacing = numPoints - 1;
    float xInterval = (width - totalSpacing - this.rightSpacing) / numPoints; 
    float yInterval = 2.0; 
    for (int i = 0; i < numPoints; i++) {
      points.get(i).setCoord(xInterval + (i * xInterval), points.get(i).value * yInterval); 
    }
  }
  
  void connectTheDots(){
    for(int i = 0; i < points.size() - 1; i++) {                     fill(color(0));
      line(points.get(i).getPosX(), points.get(i).getPosY(), points.get(i+1).getPosX(), points.get(i+1).getPosY());
    }
  }
    
  void render(){
    setGeometry(); 
    for (Point p : points) {
      p.render();
    }
    connectTheDots(); 
  }
  
  
}
