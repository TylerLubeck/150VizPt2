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
    stroke(255, 0, 0); 
    textSize(10); //<-- Need to calculate in a smart way 
    print(iD); 
    text(iD, posX + 50, posY + 50);
    //textWidth(CENTER,CENTER); 
  }
  
  int getArea() {
    return this.mWidth * this.mHeight; 
  }
  
  int getAspectRatio() {
    return max(this.mWidth/this.mHeight, this.mHeight/this.mWidth); 
  }

}
