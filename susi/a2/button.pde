
class Button extends Drawable {

  /* Percentages of screen width instead of absolute locations */
  float xP;
  float yP;
  float wP;
  float hP;
  String txt;
  boolean pressed; /* whether or not the mouse is currently pressed on this button */

  Button(float xP, float yP, float wP, float hP, String txt) {
    this.xP = xP; this.yP = yP;
    this.wP = wP; this.hP = hP;
    this.txt = txt;
  }

  void draw(float x, float y, float w, float h) {
    //print(x); print(" "); print(y); print(" "); print(w); print(" "); println(h);
    if (pressed) fill(250);
    else fill(150);
    rect(xP*width,yP*height,wP*width,hP*height);
    fill(0);
    textSize(12);
    textAlign(LEFT, TOP);
    text(txt, 1.01*xP*width, yP*height);
  }

  boolean contains(int xM, int yM) {
    //println(xM,x,x+w,yM,y,y+h,curr);
    boolean withinX = (xM > xP*width)  && (xM < (xP + wP)*width);
    boolean withinY = (yM > yP*height) && (yM < (yP + hP)*height);
    return withinX && withinY;
  }

  boolean mousePressed(int xM, int yM) { return (pressed = contains(xM,yM)); }
  void mouseReleased() { pressed = false; }

}
