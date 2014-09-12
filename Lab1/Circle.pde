class MyCircle {
  boolean isect;
  float radius;
  float posx, posy;
  color c;
  
  MyCircle() {
     isect = false;
     radius = random(10, 100);
     posx = random(radius, width-radius);
     posy = random(radius, height-radius);
     //c = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
     c = color(80, 50, 70);
  }
  
  boolean intersect (int mousex, int mousey) {
    float distance = sqrt((mousex - posx) * (mousex - posx) + 
                          (mousey - posy) * (mousey - posy));
    if (distance < radius) {
      isect = true;
    }
    else {
      isect = false;
    }
    return isect;
  }
  
  void setSelected (boolean s) {
    isect = s;
  }

  void setPos(float x, float y) {
    posx = x;
    posy = y;
  }
  
  void setColor (int r, int g, int b) {
    c = color (r, g, b);
  }
  
  void setRadius ( float r ) { radius = r; }
  
  void render() {
    fill(c);
    ellipse(posx, posy, radius * 2, radius * 2 );
  }
  
  
}
