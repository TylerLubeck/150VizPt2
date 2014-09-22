class Canvas{
  private float posX, posY, mWidth, mHeight;
  //rs is for remaining space dimensions
  private float rs_posX, rs_posY, rs_mWidth, rs_mHeight;
  private Sides fixedSide;
  private float fixedLength;
  private ArrayList<Row> rows;

  
  Canvas(float posX, float posY, float w, float h){
    this.posX = posX;
    this.posY = posY;
    this.mWidth = w;
    this.mHeight = h;
    //The remaining space is equal to the current canvas space
    this.rs_posX = this.posX;
    this.rs_posY = this.posY;
    this.rs_mWidth = this.mWidth;
    this.rs_mHeight = this.mHeight;
    this.rows = new ArrayList(0);
    calculateShorterSide();
  }
  
  Canvas(Rectangle rect){
    this(rect.posX,rect.posY,rect.mWidth,rect.mHeight);
  }
  
  void Print(){
    /*
    println("Pos X:",this.posX);
    println("Pos Y:",this.posY);
    println("Total Width:",this.mWidth);
    println("Total Height:",this.mHeight);*/
    println("RS Pos X:",this.rs_posX);
    println("RS Pos Y:",this.rs_posY);
    println("RS Total Width:",this.rs_mWidth);
    println("RS Total Height:",this.rs_mHeight);
  }
  
  void calculateShorterSide(){
    if(this.rs_mWidth < this.rs_mHeight){
      this.fixedSide = Sides.WIDTH;
      this.fixedLength = this.rs_mWidth;
    } else{
      this.fixedSide = Sides.HEIGHT;
      this.fixedLength = this.rs_mHeight;
    }
  }
  
  void rsChangedByNewRow(){
    println("rs by new row");
    int numRows = this.rows.size();
    Row row = this.rows.get(numRows-1);
    //CASTING EVERYTHING TO INT, BE WEARY
    if(row.fixedSide == Sides.HEIGHT){
      println("fixed is HEIGHT");
      this.rs_posX = row.posX + row.mWidth;
      this.rs_mWidth -= row.mWidth;
    } else{
      this.rs_posY = row.posY + row.mHeight;
      this.rs_mHeight -= row.mHeight;
    }
    calculateShorterSide();
  }
  
  void rsChangedByCurrentRow(Sides s, float oW, float oH){
    println("rs by old row", s, oW, oH);
    int numRows = this.rows.size();
    Row row = this.rows.get(numRows-1);
    //CASTING EVERYTHING TO INT, BE WEARY
    if(row.fixedSide == Sides.HEIGHT){
      println("fixed is HEIGHT");
      this.rs_posX = row.posX + row.mWidth; 
      this.rs_mWidth = this.rs_mWidth + oW - row.mWidth;
    } else{
      this.rs_posY = row.posY + row.mHeight;
      this.rs_mHeight = this.rs_mHeight + oH - row.mHeight;
    }
    calculateShorterSide();
  }
  
  void render(){
    for (Row row : this.rows){
      row.render();
    } 
  }
  
  //Adds a Node by adjusting the current configuration to obtain the best aspect ratio
  void addSquare(Node square, float va_ratio){
    //if no rows, add a row 
    if(this.rows.size() == 0){
      Row firstRow = new Row(square,this.rs_posX, this.rs_posY,
                             this.fixedLength, this.fixedSide,va_ratio);
      this.rows.add(firstRow);
      this.rsChangedByNewRow();
    } else{
      //attempt adding a node to the last row
      int size = this.rows.size();
      Row copyRow = this.rows.get(size-1);
      Sides oldRowSide = copyRow.fixedSide;
      float oldRowWidth = copyRow.mWidth;
      float oldRowHeight = copyRow.mHeight;
      boolean rowStretched = this.rows.get(size-1).addRect(square);
      if(!rowStretched){
        Row newRow = new Row(square, this.rs_posX, this.rs_posY,
                             this.fixedLength, this.fixedSide,va_ratio);
        this.rows.add(newRow);
        this.rsChangedByNewRow();
      } else{
        this.rsChangedByCurrentRow(oldRowSide,oldRowWidth,oldRowHeight);
      }
    }
    println("RS x,y,w,h: ",rs_posX,rs_posY,rs_mWidth,rs_mHeight);
  }
  
  Rectangle getRectByID(int ID){
    for(Row row : this.rows){
      for(Rectangle rect : row.rects){
        if(rect.getID() == ID){
          return rect;
        }
      }
    }
    println("COULD NOT FIND");
    return null;
  }
  
}
