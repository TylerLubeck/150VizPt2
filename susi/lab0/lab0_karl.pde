
class Button {
  float x, y; // Center of rectangle
  float w, h; // Width and height of rectangle
  float r; // Radius of edges
  String s1, s2; // The two possible strings
  boolean state; // true == s1, false == s2
  
  Button(float xi, float yi, float wi, float hi, float ri, String si1, String si2) {
    x = xi; y = yi; w = wi; h = hi; r = ri;
    state = true;
    s1 = si1; s2 = si2;
  }
  
  float getX0() { return x - getW()/2; }
  float getY0() { return y - getH()/2; }
  float getW() { return w * (state ? 1 : 2/3.0); }
  float getH() { return h * (state ? 1 : 2/3.0); }
  
  void draw() {
    fill(state ? 0 : 100, state ? 0 : 150, state ? 0 : 200);
    rect(getX0(), getY0(), getW(), getH(), r);
    textAlign(CENTER,CENTER);
    fill(state ? 255 : 0);
    text(state ? s1 : s2, x, y);
  }
  
  void update_state(int mx, int my) {
    state = (abs(mx - x) < 0.5*w && abs(my - y) < 0.5*h) ? ! state : state;
  }
  
}

Button b = null;
float sw = 400.0;
float sh = 300.0;

void setup() {
  size(int(sw),int(sh));
  b = new Button(sw/2, sh/2, sw/2, sh/2, 15.0, "Hello", "World!");
}

void draw() {
  background(255, 255, 255);
  b.draw();
}

void mousePressed() {
  b.update_state(mouseX, mouseY);
}
  
