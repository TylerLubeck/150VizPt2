static int circle_count = 0;
class MyCircle {
  int id;
  int posx, posy, radius;
  int r, g, b;
  int rB, gB, bB;
  boolean selected = false;

  MyCircle(int _id, int _posx, int _posy, int _radius) {
    id = _id;
    posx = _posx;
    posy = _posy;
    radius = _radius;
    rB = circle_count % 255;
    gB = (circle_count / 255) % 255;
    bB = (circle_count / 255 / 255) % 255;
    circle_count += 50;
  }
  
  void setColor (int _r, int _g, int _b) {
    r = _r; g = _g; b = _b;
  }
  
  boolean getSelected () {
    return selected;
  }
  
  void setSelected (boolean _selected) {
    selected = _selected;
  }
  
  void render() {
    strokeWeight(5);
    stroke(r, g, b);
    noFill();
    ellipse(posx, posy, radius*2, radius*2);  
  }
  
  void renderIsect(PGraphics pg) {
    pg.fill(red(id), green(id), blue(id));
    pg.stroke(red(id), green(id), blue(id));
    pg.strokeWeight(5);
    pg.ellipse(posx, posy, radius*2, radius*2);  
  }
  
  void renderSelected() {
    strokeWeight(1);
    stroke(r, g, b);
    fill (r, g, b, 128);
    ellipse(posx, posy, radius*2, radius*2);      
  }

  void renderPickBuffer() {
    //pickbuffer.loadPixels();
    pickbuffer.strokeWeight(1);
    pickbuffer.stroke(rB, gB, bB);
    pickbuffer.fill (rB, gB, bB); //, 255);
    pickbuffer.ellipse(posx, posy, radius*2, radius*2);
    //pickbuffer.updatePixels();
  }
  
  boolean isect () {
    color mycolor = color(rB,gB,bB);
    for (int i = 0; i < 600*600; i++) {
      if (pickbuffer.pixels[i] == mycolor && (mouseY*600 + mouseX == i)) {
        return true;
      }
    }
    //println(pickbuffer.pixels);
    //TODO: Fill in this function

    return false;
  }
}

