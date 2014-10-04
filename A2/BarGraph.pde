class Bar{
  int value;
  float xCoord, yCoord, pointX,pointY;
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
    pointX = xC;
    pointY = yC;
    xCoord = pointX - w/2;
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
  ArrayList<Bar> bars;
  color fill, stroke;
  float w, h;
  float leftSpacing;
  float rightSpacing;
  float paddedHeight;
  
  BarGraph(float w, float h){
    bars = new ArrayList<Bar>();
    fill = color(155, 161, 163);
    stroke = color(216, 224, 227);
    this.w = w;
    this.h = h;
    //Need to make spacing dynamic
    this.leftSpacing = 20;
    this.rightSpacing = 20;
    this.paddedHeight = height - 100;
  }
  
  void addBar( String lbl, int val){
    Bar b = new Bar( lbl, val, fill, stroke);
    bars.add(b);
  }
  
  void setGeometry(){
    //calculate appropriate width/height and spacing for each bar
    int numBars = bars.size();
    float barSpacing = 5.0;
    float totalSpacing = (numBars - 1) * barSpacing;
    float availableWidth = width - totalSpacing - this.leftSpacing - this.rightSpacing;
    float barWidth = availableWidth / numBars;
    float yFactor = 2.0;
    
    //set up starting coords
    float startPosX = this.leftSpacing;
    
    for(int i=0; i< bars.size(); i++){
      float barHeight = bars.get(i).value * yFactor;
      bars.get(i).SetGeometry(startPosX,
                              paddedHeight - barHeight,
                              barWidth,
                              barHeight);
      startPosX+=barWidth + barSpacing;
    }
  }
  
  void render(){
    this.setGeometry();
    for (Bar b : bars) {
      b.render();
    }
  }
  
}
