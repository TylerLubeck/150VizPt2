class Point{
  MyCircle circle;
  String label;
  
  Point() {
    circle = new MyCircle();
    label = "";
  }
  
  void setCoord( int posx, int posy){
    circle.setPos( float(posx),float(posy));
    circle.setRadius(5.0);
  }
  
  void render(){
    circle.render();
  }
  
  void setLabel( String s ){
    label = s;
  }
  
  void intersect(int posx, int posy){
    if(circle.intersect(posx,posy)){
      text( label, circle.posx, circle.posy + 10);
    }
  }
}
