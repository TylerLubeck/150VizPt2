class Point{
  MyCircle circle;
  int value;
  String label;
  float pointPosX, pointPosY;
  
  Point() {
    circle = new MyCircle();
    value = 0;
    label = "";
  }
  
  Point( String l, int val){
    this();
    value = val;
    label = "(" +l + ", " + value + ")";
  }
  
  Point( int posx, int posy, String l, int val) {
    this(l, val);
    setCoord( posx, posy );
  }
  
  void setCoord( float posx, float posy){
    pointPosX = posx;
    pointPosY = posy;
    circle.setPos( pointPosX,pointPosY);
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
      fill(color(255, 0, 0));
      text( label, circle.posx - 25, circle.posy - 10);
      fill(color(0));
    }
  }
  
  float getPosX(){return pointPosX;}
  float getPosY(){return pointPosY;}
}
