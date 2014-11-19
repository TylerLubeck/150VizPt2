import java.util.Collections;

class StackedBar {
  Data values;
  float unit;
  float zeroY, x, y, w, h;
  float maxRange, totalVal;

  StackedBar(Data values) {
    this.values = values;
    setMaxRange();
  }
  
  
  void draw(float x, float y, float w, float h) {
    this.x = x;
    this.y = y; 
    this.w = w-2;
    this.h = h-2;
    zeroY = y + this.h;
    setUnit();
    drawBars();
  }

  void drawBars(){
    float upperX, upperY, widthB, heightB;
    float currVal = maxRange;
    
    widthB = w * 0.1;
    upperX = x + w/2 -widthB/2;
    for (int i = 0; i < values.getSize(); ++i) {
      upperY = zeroY - unit * currVal;
      heightB = unit*currVal;
      fill(255);
      rect(upperX, upperY, widthB, heightB);
      if(values.isMarked(i)) {
        fill(0);
        ellipse(upperX + widthB /2, upperY + values.getValue(i)*unit - w*0.008, w* 0.01, w*0.01);
      }
      currVal -= values.getValue(i);  
    
    } 
  }
  
  
  void setUnit() {
     unit = h /maxRange/1.1;
  } 
  
  void setMaxRange() {
     float max = 0.0;
     for (int i = 0; i < values.getSize(); ++i) {
        max += values.getValue(i);
     }
     maxRange = max;
  }
}

