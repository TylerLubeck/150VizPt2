class Rectangle{
  private float posX, posY;
  private float mHeight, mWidth;
  private int iD;
  
  Rectangle( float posX, float posY, float w, float h, int iD ){
    this.posX = posX;
    this.posY = posY;
    this.mHeight = h;
    this.mWidth = w;
    this.iD = iD;     
  }
  
  void render(){
    fill(255); 
    rect(this.posX, this.posY, this.mWidth, this.mHeight);
    fill(255, 0, 0); 
    textSize(20); //<-- Need to calculate in a smart way 
    text(iD, this.posX + 50, this.posY + 50);
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
  
  float getHeight() {
    return this.mHeight; 
  }
  
  float getPosX() {
    return this.posX; 
  }
  
  float getPosY() {
    return this.posY; 
  }
  void setHeight(float h) {
    this.mHeight = h;
  }
  
  void setWidth(float w) {
    this.mWidth = w;
  }
  
  void setPosX(float x) {
    this.posX = x;
  }
  
  void setPosY(float y) {
    this.posY = y; 
  }


}
