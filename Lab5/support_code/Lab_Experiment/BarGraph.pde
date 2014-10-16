import java.util.Collections;

class BarGraph {
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
    
    for (int i = 0; i < values.getSize(); ++i) {
      fill(255);
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
    }
 }
 
 void drawBarsHorizontal(){
    zeroX = x;
    float yInterval = h / (float(values.getSize()));
    float tickY = y + yInterval/2.0;
    float upperX, upperY, widthB, heightB;
    
    for (int i = 0; i < values.getSize(); ++i) {
      fill(255);
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

