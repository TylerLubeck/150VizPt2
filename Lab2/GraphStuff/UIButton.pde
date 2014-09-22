class UIButton {
  boolean m_isWithin;
  float m_width, m_height;
  float m_posX, m_posY;
  color m_c;
  String T1;
  
  UIButton() {
    m_width = width / 2;
    m_height = height / 2;
    m_posX = width / 4;
    m_posY = height / 4;
    m_c = color( 255, 0, 0 );
    T1 = "Click me";
  }
  
  UIButton(int w, int h, int x, int y, color c, String t) {
      m_width = w;
      m_height = h;
      m_posX = x;
      m_posY = y;
      m_c = c;
      T1 = t;
  }
  
  void updatePosition( int x, int y ){
    m_posX = x;
    m_posY = y;
  }
  
  void render(){
    fill(m_c);
    rect(getPosX(), getPosY(), getWidth(), getHeight());
    fill(color(0));
    text(T1, getPosX() + 2, getPosY() + getHeight()/2);
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
  
  void setColor( color c ) {
    m_c = c;
  }
  
  void setText( String t ) {
    T1 = t;
  }
  
  boolean isWithin() {return m_isWithin;}
  float getPosX() {return m_posX;}
  float getPosY() {return m_posY;}
  float getWidth() {return m_width;}
  float getHeight() {return m_height;}
  color getColor() {return m_c;}
  String getText() {return T1;}
}
