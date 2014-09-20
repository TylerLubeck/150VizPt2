class Rectangle{
  private int posX, posY;
  private int mHeight, mWidth;
  private int iD;
  
  Rectangle( int posX, int posY, int h, int w, int iD ){
    this.posX = posX;
    this.posY = posY;
    this.mHeight = h;
    this.mWidth = w;
    this.iD = iD;
  }
  
  void render(){
    rect(this.posX, this.posY, this.mWidth, this.mHeight);
    textSize(10); //<-- Need to calculate in a smart awy
    text(iD, posX, posY);
    textWidth(CENTER,CENTER);
  }
}
