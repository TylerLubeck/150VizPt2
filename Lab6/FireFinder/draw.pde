int canvasWidth = MIN_INT; // this would be initialized in setup

void draw() {
  clearCanvas();

  /**
   ** Finish this:
   **
   ** you should draw your scatterplot here, on rect(0, 0, canvasWidth,canvasWidth) (CORNER)
   ** axes and labels on axes are required
   ** the hovering is optional
   **/
    rectMode(CORNER); 
    //rect(0, 0, canvasWidth, canvasWidth);// (CORNER);

    for (Pair p: pairs) {
        fill(0);
        float x = map(p.X, 0, MAX_X, canvasWidth * .1, canvasWidth);
        float y = map(p.Y, 0, MAX_Y, canvasWidth * .9, 0);
        ellipse(x, y, 5, 5);
    }

    
}
