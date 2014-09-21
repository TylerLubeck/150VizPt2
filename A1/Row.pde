class Row {
  private int posX, posY;
  private float mHeight, mWidth; 
  private ArrayList<Rectangle> rects; 
  private float VA_Ratio; 
  private Sides fixedSide; 
  private float short_side; 
  
  Row(Node n, int x, int y, float short_side, Sides side, float va_ratio) {
    this.short_side = short_side; 
    this.fixedSide = side;
    this.VA_Ratio = va_ratio; 
    this.posX = x;
    this.posY = y; 
    addFirstRect(n);
  }
  
  void addFirstRect(Node n) {
    float area = (float)n.getValue() * this.VA_Ratio;
    float h, w;  
    if (this.fixedSide == Sides.HEIGHT) { 
      h = this.short_side;
      w = area/h; 
    } else {
      w = this.short_side;
      h = area/w; 
    }
    
    this.mHeight = h;
    this.mWidth = w; 
    
    this.rects = new ArrayList<Rectangle>(); 
    print(h);
    print(w); 
    
    this.rects.add(new Rectangle(this.posX, this.posY, h, w, n.getID())); 
    
  }
  /* Adds a rectangle if the aspect ratio is optimum. Otherwise, returns false; */ 
  boolean addRect(int short_side, Node node) {
    float area = (float)node.getValue() * this.VA_Ratio;
    float h, w;  
    if (this.fixedSide == Sides.HEIGHT) { 
      h = short_side;
      w = area/h; 
    } else {
      w = short_side;
      h = area/w; 
    }
    
    if (this.rects == null) {
      this.rects = new ArrayList<Rectangle>(); 
      this.rects.add(new Rectangle(0, 0, h, w, node.getID())); 
      return true; 
    }
    else {
      this.rects.add(new Rectangle(0, 0, h, w, node.getID()));  // <-- not the right xPos & yPos 
      return resizeRects(short_side); 
    }
  }
  
  /* given a new rectangle, attempt to fit the rectangle on the given row. 
  returns false if the aspect ratio is not optimum */ 
  boolean resizeRects(int short_side) {
    int h, w; 
    int totalArea = this.sumAreas(); 
      
    if (this.fixedSide == Sides.HEIGHT) { 
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
   * posX and posY might have to happen outside this fnc since order matters..?: 
    first rect in arraylist should be above (or to the left of) second, and so so forth 
   */ 
  Rectangle recalculate(Rectangle r, float new_side) {
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
  
  int getPosX() {
    return this.posX; 
  }
  
  int getPosY() {
    return this.posY;
  }
  
  float getArea() {
    return (this.mWidth * this.mHeight);
  }
  
  float getShorterSide() {
    return this.fixedSide; 
  }
  
  
}
