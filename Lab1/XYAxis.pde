class XYAxis {
  String xLabel, yLabel;
  int xInterval, yInterval;
  int xLength, yLength;
  int xAxis_x, xAxis_y, yAxis_x, yAxis_y;
  int xNumTicks, yNumTicks;
  
  XYAxis() {
    xLabel = "X-Axis";
    yLabel = "Y-Axis";
    xInterval = 1;
    yInterval = 1;
    xLength = width - width / 4;
    yLength = height - height / 4;
    xAxis_x = width / 8;
    xAxis_y = height - height / 8;
    yAxis_x = xAxis_x;
    yAxis_y = xAxis_y;
    xNumTicks = 10;
    yNumTicks = 10; 
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
  
}
