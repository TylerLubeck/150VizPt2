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
    println("IN NEW ROW: short_side -- " + short_side); 
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
    println("NEW ROW: w " + w + " h " + h + " x " + this.posX + " y " + this.posY); 
    this.rects.add(new Rectangle(this.posX, this.posY, h, w, n.getID())); 
  }
  /* Adds a rectangle if the aspect ratio is optimum. Otherwise, returns false; */ 
  boolean addRect(Node node) {
    float area = (float)node.getValue() * this.VA_Ratio;
    
      //this.rects.add(new Rectangle(0, 0, h, w, node.getID()));  // <-- not the right xPos & yPos  
    return resizeRects(area, node); 
  }
  
  /* given a new rectangle, attempt to fit the rectangle on the given row. 
  returns false if the aspect ratio is not optimum */ 
  boolean resizeRects(float nodeArea, Node node) {
    float h, w; 
    float totalArea = (float)this.sumAreas() + nodeArea; 
    float new_side = totalArea / this.short_side;
    
    if (this.fixedSide == Sides.HEIGHT) { 
        h = (node.getValue() * this.VA_Ratio) / new_side; 
        w = new_side; 
    } else {
        w = (node.getValue() * this.VA_Ratio) / new_side;  
        h = new_side;
    }
    
    float asp_ratio = max(h/w, w/h); 
    if(asp_ratio < this.rects.get(this.rects.size() - 1).getAspectRatio()) {
      
      this.rects.add(new Rectangle(0, 0, w, h, node.getID())); // FIX THIS ID IS NOT CORRECT 
      println("adding... " + w +" " + h);  
      ArrayList<Rectangle> resizedRects = new ArrayList<Rectangle>(); 
      Rectangle first = this.rects.get(0);
      
      println("NEW SIDE: " + new_side); 
     
      if (this.fixedSide == Sides.HEIGHT) {
        first.setHeight(first.getArea() / new_side); 
        first.setWidth(new_side); 
        first.setPosX(this.posX); 
        first.setPosY(this.posY);    
      } else {
        first.setWidth(first.getArea() / new_side); 
        first.setHeight(new_side); 
        first.setPosY(this.posY); 
        first.setPosX(this.posX); 
      }
      
      println(first.getWidth() + " " + first.getHeight() + " " + first.getPosX() + " " + first.getPosY()); 
      resizedRects.add(first); 
    
      float x, y;  
      for (int i = 1; i < this.rects.size(); i++) {
        if (this.fixedSide == Sides.HEIGHT) {
          h = rects.get(i).getArea() / new_side;
          //println("AREA " + rects.get(i).getArea()); 
          w = new_side;
          y = resizedRects.get(i - 1).getPosY() + rects.get(i - 1).getHeight();
          x = this.posX; 
          this.mWidth = w;
          this.mHeight = h;
          this.posY = (int)y; 
        } else {
          w = rects.get(i).getArea() / new_side;
          h = new_side;
          x = resizedRects.get(i - 1).getPosX() + rects.get(i - 1).getWidth();
          y = this.posY; 
          this.mWidth = w;
          this.mHeight = h;
          this.posX = (int)x; 
        }
        
        println(w + " " + h + " " + x + " " + y + " "); 
        println(" SQUISHING: " + w + " " + h + " " + x + " " + y + " "); 
        resizedRects.add(new Rectangle(x, y, w, h, this.rects.get(i).getID())); 
      }
      this.rects = resizedRects; 
      return true;     
    } 
       
    return false; 
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
  
  Sides getShorterSide() {
    return this.fixedSide; 
  }
  
  
}
