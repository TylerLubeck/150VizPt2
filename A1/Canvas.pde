class Canvas{
  private int posX, posY, mWidth, mHeight;
  //rs is for remaining space dimensions
  private int rs_posX, rs_posY, rs_mWidth, rs_mHeight;
  private Sides fixedSide;
  private int fixedLength;
  private ArrayList<Row> rows;

  
  Canvas(int posX, int posY, int w, int h){
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
  
  //adds a row and calculates the remaining space
  void addRow(Row row){
    println("In addRow");
    println("Row is x,y,w,h",row.posX,row.posY,row.mWidth,row.mHeight);
    this.rows.add(row);
    //CASTING EVERYTHING TO INT, BE WEARY
    if(row.fixedSide == Sides.HEIGHT){
      this.rs_posX = int(row.posX + row.mWidth);
      this.rs_mWidth -= int(row.mWidth);
    } else{
      this.rs_posY = int(row.posY + row.mHeight);
      this.rs_mHeight -= int(row.mHeight);
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
      this.addRow(firstRow);
    } else{
      //attempt adding a node to the last row
      int size = this.rows.size();
      if(!this.rows.get(size-1).addRect(square)){
        println("RS x,y,w,h: ",rs_posX,rs_posY,rs_mWidth,rs_mHeight);
        Row newRow = new Row(square, this.rs_posX, this.rs_posY,
                             this.fixedLength, this.fixedSide,va_ratio);
        this.addRow(newRow);
      }
    }
    
  }
  
}
