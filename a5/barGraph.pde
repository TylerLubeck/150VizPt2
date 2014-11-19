import java.util.Collections;

class BarGraph {
  color[] colors = {
   color(166,206,227),color(31,120,180),color(178,223,138),color(51,160,44),color(251,154,153),color(227,26,28),
   color(253,191,111),color(255,127,0),color(202,178,214),color(106,61,154)};
  
  color singleColor = color(166,206,227);
  
  Data values;
  float unit;
  float zeroY, zeroX, x, y, w, h;
  float maxRange;
  
  BarGraph(Data values) {
    this.values = values;
    setMaxRange();
  }
  
  void draw(float x, float y, float w, float h, int colorOption) {
    this.x = x;
    this.y = y; 
    this.w = w-2;
    this.h = h-2;
    setUnit();
    switch(colorOption) {
      case 0: drawBarsWhite(); break;
      case 1: drawBarsMarkedWColor(); break;
      case 2: drawBarsUniColor(); break;
      case 3: drawBarsMultiColor(); break;
    }
  }

  
  void drawBarsWhite(){
    zeroY = y + this.h;
    float xInterval = w / (float(values.getSize()));
    float tickX = x + xInterval/2.0;
    float upperX, upperY, widthB, heightB;
    int colorIndex = 0;
    
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
      colorIndex = (colorIndex + 1) % colors.length;
    }
 }
 
 void drawBarsMarkedWColor(){
    zeroY = y + this.h;
    float xInterval = w / (float(values.getSize()));
    float tickX = x + xInterval/2.0;
    float upperX, upperY, widthB, heightB;
    int colorIndex = 0;
    
    for (int i = 0; i < values.getSize(); ++i) {
      if (values.isMarked(i)) {
          fill(singleColor);
      }
      else 
          fill(255);
      upperX = tickX-(xInterval*0.8)/2;
      upperY = zeroY-unit*values.getValue(i);
      widthB = xInterval*0.8;
      heightB = unit*values.getValue(i);
      rect(upperX, upperY, widthB, heightB);
      
      tickX+= xInterval;
      colorIndex = (colorIndex + 1) % colors.length;
    }
 }
 
 
 void drawBarsUniColor(){
    zeroY = y + this.h;
    float xInterval = w / (float(values.getSize()));
    float tickX = x + xInterval/2.0;
    float upperX, upperY, widthB, heightB;
    int colorIndex = 0;
    
    for (int i = 0; i < values.getSize(); ++i) {
      fill(singleColor);
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
 
void drawBarsMultiColor(){
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

