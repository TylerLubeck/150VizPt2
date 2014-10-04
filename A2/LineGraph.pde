class LineGraph{
  //XYAxis axis;
  ArrayList<Point> points;
  float w, h;
  float leftSpacing;
  float rightSpacing;
  float paddedHeight;
  float min, max; 
  
//  LineGraph(){
//    axis = new XYAxis();
//    points = new ArrayList<Point>();
//  }
//  
//  LineGraph( XYAxis a) {
//    this();
//    setAxis(a);
//  }
   
  LineGraph(float w, float h) {
    this.w = w;
    this.h = h - 100;
    this.leftSpacing = 20;
    this.rightSpacing = 50;
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
    float numPoints = this.points.size(); 
    float totalSpacing = (numPoints - 1) * 5.0;
    float xInterval = (this.w  - totalSpacing) / numPoints; 
    float yInterval = 2.0; 
    for (int i = 0; i < this.points.size(); i++) {
      this.points.get(i).setCoord(xInterval + (i * xInterval), this.points.get(i).value * yInterval); 
    }
  }
  
  void connectTheDots(){
    for(int i=0; i< points.size() - 1; i++){
      stroke( color(0,0,0) );
      line(points.get(i).getPosX(),points.get(i).getPosY(), points.get(i+1).getPosX(), points.get(i+1).getPosY());
    }
  }
  
  void updateAxis(){
    axis.update();
  }
  
  void render(){
    setGeometry(); 
    for (Point p : points) {
      p.render();
    }
    connectTheDots(); 
  }
  
  
  
}
