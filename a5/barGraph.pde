import java.util.Collections;

class BarGraph {
  color[] colors = {
   color(166,206,227),color(31,120,180),color(178,223,138),color(51,160,44),color(251,154,153),color(227,26,28),
   color(253,191,111),color(255,127,0),color(202,178,214),color(106,61,154)};
  
  
  Data values;
  float unit;
  float zeroY, zeroX, x, y, w, h;
  float maxRange;
  
  BarGraph(Data values) {
    this.values = values;
    setMaxRange();
  }
  
  void draw(float x, float y, float w, float h, boolean vertical) {
    this.x = x;
    this.y = y; 
    this.w = w-2;
    this.h = h-2;
    setUnit();
    if (vertical)
      drawBarsVertical();
    else
      drawBarsHorizontal();
  }

  
  void drawBarsVertical(){
    zeroY = y + this.h;
    float xInterval = w / (float(values.getSize()));
    float tickX = x + xInterval/2.0;
    float upperX, upperY, widthB, heightB;
    int colorIndex = 0;
    
    for (int i = 0; i < values.getSize(); ++i) {
      fill(colors[colorIndex]);
      upperX = tickX-(xInterval*0.8)/2;
      upperY = zeroY-unit*values.getValue(i);
      widthB = xInterval*0.8;
      heightB = unit*values.getValue(i);
      rect(upperX, upperY, widthB, heightB);
      if (values.isMarked(i)) {
        fill(0);
        ellipse(tickX, zeroY - w*0.02, w*0.01, w*0.01);
      }
      tickX+= xInterval;
      colorIndex = (colorIndex + 1) % colors.length;
    }
 }
 
 void drawBarsHorizontal(){
    zeroX = x;
    float yInterval = h / (float(values.getSize()));
    float tickY = y + yInterval/2.0;
    float upperX, upperY, widthB, heightB;
    
    for (int i = 0; i < values.getSize(); ++i) {
      fill(70, 170, 208);
      upperY = tickY-(yInterval*0.8)/2;
      upperX = x;
      heightB = yInterval*0.8;
      widthB = unit*values.getValue(i);
      rect(upperX, upperY, widthB, heightB);
      if (values.isMarked(i)) {
        fill(0);
        ellipse(zeroX + w*0.02, tickY, w*0.01, w*0.01);
      }
      tickY+= yInterval;
    }
 }
 
  void setUnit() {
     unit = h /maxRange/1.1;
  } 
  
  void setMaxRange() {
     float max = 0.0;
     for (int i = 0; i < values.getSize(); ++i) {
        if (values.getValue(i) > max) 
          max = values.getValue(i);
     }
     maxRange = max;
  }
}

