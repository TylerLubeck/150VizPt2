class Rectangle{
  private float posX, posY;
  private float mHeight, mWidth;
  private int iD;
  
  Rectangle( float posX, float posY, float h, float w, int iD ){
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
    text(iD, posX, posY);
    //textWidth(CENTER,CENTER); 
  }
  
  float getArea() {
    return this.mWidth * this.mHeight; 
  }
  
  int getID() {
    return this.iD; 
  }
  
  float getWidth() {
    return this.mWidth; 
  }
  
  float getAspectRatio() {
    return max(this.mWidth/this.mHeight, this.mHeight/this.mWidth); 
  }

}
