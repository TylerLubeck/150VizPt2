int canvasWidth = MIN_INT; // this would be initialized in setup
float RADIUS = 5;

void draw() {
  clearCanvas();
  String tooltip = "";
  /**
   ** Finish this:
   **
   ** you should draw your scatterplot here, on rect(0, 0, canvasWidth,canvasWidth) (CORNER)
   ** axes and labels on axes are required
   ** the hovering is optional
   **/
    rectMode(CORNER); 
    //rect(0, 0, canvasWidth, canvasWidth);// (CORNER);
    drawCoordSys();
    for (DataPoint p: data) {
        fill(0);
        float x = map(p.X, 0, MAX_X, canvasWidth * .1, canvasWidth * .95);
        float y = map(p.Y, 0, MAX_Y, canvasWidth * .9, canvasWidth * .05);
        if (isIntersect(x, y)) {
          fill(100);
          tooltip = "Month = " + p.month + "\nDay = " + p.day + "\ntemp = " + p.temp + "\nhumidity = " + p.hum + "\nwind = " + p.wind;
        }
          
        ellipse(x, y, RADIUS, RADIUS);
    }
    if (tooltip != "") {
      textSize(15);
      textAlign(LEFT);
      float textW = textWidth(tooltip);
      fill(255);
      rect(mouseX - textW*1.1, mouseY-120, textW*1.1, 120);
      fill(0);
      text(tooltip, mouseX - textW*1.05, mouseY-105);
      textAlign(CENTER, BOTTOM);
    }
 }

  void drawCoordSys() { 
      float x, y;
      stroke(1);
      line(canvasWidth * 0.1, canvasWidth * 0.9, canvasWidth * 0.95, canvasWidth * 0.9);
      line(canvasWidth * 0.1, canvasWidth * 0.9, canvasWidth * 0.1, canvasWidth * 0.05);  
      float xUnit = MAX_X / 10.0;
      float yUnit = MAX_Y / 10.0;
      //drawX Ticks and labels
      for (int i = 0; i < 11; i++) {
          x = map(i * xUnit, 0, MAX_X, canvasWidth * 0.1, canvasWidth * 0.95);
          line(x, canvasWidth*0.9 - canvasWidth * 0.01, x, canvasWidth*0.9 + canvasWidth * 0.01);
          textAlign(CENTER, BOTTOM);
          fill(0);          
          text(String.format("%.2f  ", (i*xUnit)), x, canvasWidth *0.9 + canvasWidth * 0.03);
      }
      
      // drawY Ticks and labels
      for (int i = 0; i < 11; i++) {
          y = map(i * yUnit, 0, MAX_Y, canvasWidth * .9, canvasWidth * .05);
          line(canvasWidth * 0.1 - canvasWidth * 0.01, y, canvasWidth * 0.1 + canvasWidth * 0.01, y);
          textAlign(CENTER, CENTER);
          fill(0);          
          text(String.format("%.2f  ", (i*yUnit)), canvasWidth * 0.1 - canvasWidth * 0.03, y);
      }
  }
  
  boolean isIntersect(float x, float y) {
    float distance = sqrt((mouseX - x) * (mouseX - x) + (mouseY - y) * (mouseY - y));
    return (distance <= RADIUS);
  }
    
