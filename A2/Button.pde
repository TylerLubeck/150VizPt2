class Button {
  boolean m_isWithin;
  color c; 
  float m_width, m_height;
  float m_posX, m_posY;
  String text; 
  
  Button(int w, int h, int x, int y, String t) {
      m_width = w/3;
      m_height = h/3;
      m_posX = x;
      m_posY = y;
      text = t;
      this.c = color(209, 190, 194); 
  }
    
  void render(){
    fill(this.c);
    stroke(color(216, 224, 227));
    strokeWeight(0); 
    rect(m_posX, m_posY, m_width, m_height, 5);
    fill(0); 
    textSize(20); 
    text(this.text, m_posX + (m_width/4), m_posY + m_height / 2);
  }
  
  boolean intersect( int mousex, int mousey ){
    setWithin(mousex,mousey);
    return isWithin();
  }
  
  void setWithin( int mousex, int mousey ) {
    if( mousex >= m_posX && mousex <= (m_posX + m_width) &&
        mousey >= m_posY && mousey <= (m_posY + m_height) ) {
        m_isWithin = true;
    }
    else {
      m_isWithin = false;
    }
  }
  
  void setWidth( float w ) {
    m_width = w;
  }
  
  void setHeight( float h ) {
    m_height = h;
  }
  
  void setPosX( float x ) {
    m_posX = x;
  }
  
  void setPosY( float y ) {
    m_posY = y;
  }
  
  void setText( String t ) {
    text = t;
  }
  
  void setColor(color c) {
    this.c = c; 
  }
  
  boolean isWithin() {return m_isWithin;}
  float getPosX() {return m_posX;}
  float getPosY() {return m_posY;}
  float getWidth() {return m_width;}
  float getHeight() {return m_height;}
  String getText() {return text;}
}
