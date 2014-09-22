class Bar{
  int value;
  float xCoord, yCoord;
  float bWidth, bHeight;
  String label;
  color fill, stroke;
  Bar(){
    value = 0;
    label = "";
  }
  Bar( String l, int val, color f, color s){
    value = val;
    label = "(" + l + "," + value + ")";
    fill = f;
    stroke = s;
  }
  
  void SetGeometry( float xC, float yC, float w, float h){
    xCoord = xC - w/2;
    yCoord = yC;
    bWidth = w;
    bHeight = h;
  }
  
  void render(){
    stroke(stroke);
    fill(fill);
    rect( xCoord, yCoord, bWidth, bHeight );
  }
  
  void intersect(int posx, int posy){
    if( posx >= xCoord && posx <= bWidth + xCoord &&
        posy >= yCoord && posy <= (yCoord+ bHeight)){
      fill(color(255, 0, 0));
      text( label, xCoord - bWidth - 10, yCoord - 2);
      fill(color(0));

    }
  }
}


class BarGraph{
  XYAxis axis;
  ArrayList<Bar> bars;
  color fill, stroke;
  
  BarGraph(){
    axis = new XYAxis();
    bars = new ArrayList<Bar>();
    fill = color(155, 161, 163);
    stroke = color(216, 224, 227);
  }
  
  BarGraph( XYAxis a) {
    this();
    setAxis(a);
  }
  
  void setAxis( XYAxis a) {
    axis = a;
  }
  
  void addBar( String lbl, int val){
    Bar b = new Bar( lbl, val, fill, stroke);
    bars.add(b);
  }
  
  void drawBars(){
    //calculate each point's posx and posy based on val
    for(int i=0; i< bars.size(); i++){
      bars.get(i).SetGeometry(axis.getTickX(i),
                              axis.getTickY(bars.get(i).value),
                              14,
                              bars.get(i).value * axis.yInterval);
    }
  }
  
  void updateAxis(){
    axis.update();
  }
  
  void render(){
    axis.render();
    for (Bar b : bars) {
      b.render();
    }
  }
  
}
