class LineGraph{
  XYAxis axis;
  ArrayList<Point> points;
  
  LineGraph(){
    axis = new XYAxis();
    points = new ArrayList<Point>();
  }
  
  LineGraph( XYAxis a) {
    this();
    setAxis(a);
  }
  
  void setAxis( XYAxis a) {
    axis = a;
  }
  
  void addPoint( String lbl, int val){
    Point p = new Point(lbl,val);
    points.add(p);
  }
  
  void drawPoints(){
    //calculate each point's posx and posy based on val
    for(int i=0; i< points.size(); i++){
      points.get(i).setCoord(axis.getTickX(i),axis.getTickY(points.get(i).value));
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
    axis.render();
    for (Point p : points) {
      p.render();
    }
  }
  
  
  
}
