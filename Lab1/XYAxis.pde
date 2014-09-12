class XYAxis {
  String xLabel, yLabel;
  int xInterval, yInterval;
  int xLength, yLength;
  int xAxis_x, xAxis_y, yAxis_x, yAxis_y;
  int xNumTicks, yNumTicks;
  int tickLength;
  
  XYAxis() {
    xLabel = "X-Axis";
    yLabel = "Y-Axis";
    xInterval = 1;
    yInterval = 1;
    xLength = width - width / 4;
    yLength = height - height / 4;
    xAxis_x = width / 8 + width / 16;
    xAxis_y = height - height / 8;
    yAxis_x = xAxis_x;
    yAxis_y = xAxis_y;
    xNumTicks = 10;
    yNumTicks = 10; 
    tickLength = 10;
  }
  
  void setXLabel( String x ) {xLabel = x;}
  void setYLabel( String y ) {yLabel = y;}
  void setXInterval( int x ) {xInterval = x;}
  void setYInterval( int y ) {yInterval = y;}
  void setXNumTicks( int x ) {xNumTicks = x;}
  void setYNumTicks( int y ) {yNumTicks = y;}
  
  void resetIntervals() {
      xInterval = xLength / xNumTicks;
      yInterval = yLength / yNumTicks;  
  }
  
  void render() {
    // draw axis
    line(xyAxis.xAxis_x, xyAxis.xAxis_y, xyAxis.xAxis_x + xyAxis.xLength, xyAxis.xAxis_y);
    line(xyAxis.yAxis_x, xyAxis.yAxis_y, xyAxis.xAxis_x, xyAxis.yAxis_y - xyAxis.yLength);
    // draw X ticks
    int xTick_x = xAxis_x;
    int xTick_y = xAxis_y + tickLength / 2;
    int xTick_height = xTick_y - tickLength;
    for(int i=0; i< xNumTicks; i++) {
      xTick_x += xInterval;
      line(xTick_x, xTick_y, xTick_x, xTick_height);
    }
    // draw Y ticks
    int yTick_x = yAxis_x - tickLength / 2;
    int yTick_y = yAxis_y;
    int yTick_length = yTick_x + tickLength;
    for(int i=0; i< yNumTicks; i++) {
      yTick_y -= yInterval;
      line(yTick_x, yTick_y, yTick_length, yTick_y);
    }
    // draw text labels
    fill( color(0,0,0) );
    text(xLabel, xAxis_x + xLength / 2, xAxis_y + 20);
    text(yLabel, yAxis_x - 55, yAxis_y - yLength / 2);
  }
  
}
