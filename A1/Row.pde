class Row {
  private int posX, posY;
  private int mHeight, mWidth; 
  private ArrayList<Rectangle> rects; 
  private int VA_Ratio; 
  
  Row(int va_ratio,int x, int y, int w, int h) {
    this.VA_Ratio = va_ratio;
    this.posX = x;
    this.posY = y;
    this.mHeight = h; 
    this.mWidth = w; 
    this.rects = null; 
  }
  
  /* Adds a rectangle if the aspect ratio is optimum. Otherwise, returns false; */ 
  boolean addRect(int short_side, Sides currentSide, Node node) {
    int area = node.getValue() * this.VA_Ratio;
    int h, w;  
    if (currentSide == Sides.HEIGHT) { 
      h = short_side;
      w = area/h; 
    } else {
      w = short_side;
      h = area/w; 
    }
    
    if (this.rects == null) {
      float asp_ratio = max((h / w), (w / h));
      this.rects = new ArrayList<Rectangle>(); 
      this.rects.add(new Rectangle(0, 0, h, w, node.getID())); 
      return true; 
    }
    else {
      // return resizeRects(short_side, currentSide); 
      return false; 
    }
  }
  
  /* given a new rectangle, attempt to fit the rectangle on the given row. 
  returns false if the aspect ratio is not optimum */ 
  boolean resizeRects(int short_side, Sides currentSide) {
    int h, w; 
      int totalArea = this.sumAreas(); 
      
     /* 2. Divide total area by short_side to determine the value of the opposite side */ 
      if (currentSide == Sides.HEIGHT) { 
        h = short_side; 
        w = totalArea / short_side; 
      } else {
        w = short_side; 
        h = totalArea / short_side; 
      }
       int asp_ratio = max(h/w, w/h); 
       if(asp_ratio < this.rects.get(this.rects.size() - 1).getAspectRatio()) {
         
     /* TODO: If the aspect ratio is better, create a new ArrayList that contains
         the values of all of the newly resized rectangles.  */ 
         ArrayList newRects = new ArrayList<Rectangle>(); 
         for (Rectangle r : this.rects) {
           newRects.add(recalculate(r, totalArea/short_side)); // <-- other stuff needs to passed in too? 
         } 
         return true; 
       }  
       return false; 
  }
  
  /* Given the already calculated "non_shortest side" of the 
   * new rectangle, calculate the new dimension of the rectangles already placed on the row:  
   * if SIDES == HEIGHT 
      height = r.getArea() / new_side
     else 
      width = r.getArea() / new_side
   * posX and posY might have to happen outside this fnc since order matters: 
    first rect in arraylist should be above (or to the left of) second, and so so forth 
   */ 
  Rectangle recalculate(Rectangle r, int new_side) {
    return null; 
  }

  int sumAreas() {
    int sum = 0; 
    for (Rectangle r : this.rects) {
      sum += r.getArea(); 
    }
    return sum;
  }
  
  void render() {
    for (Rectangle r : this.rects) {
      r.render(); 
    }
  }
}
