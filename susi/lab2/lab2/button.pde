
class Button {

  float x;
  float y;
  float w;
  float h;

  Button(float x, float y, float w, float h) {
    this.x = x; this.y = y;
    this.w = w; this.h = h;
  }

  void draw() {
    //print(x); print(" "); print(y); print(" "); print(w); print(" "); println(h);
    rect(x,y,w,h);
  }

  boolean contains(int xM, int yM) {
    //println(xM,x,x+w,yM,y,y+h,curr);
    return (xM > x) && (xM < (x + w)) && (yM > y) && (yM < (y + h));
  }

}
