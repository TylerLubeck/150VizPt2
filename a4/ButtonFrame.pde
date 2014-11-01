class Button {
    float leftX, leftY, w, h;
    color cReg = color(220);
    color cHover = color(200);
    String bText;
    
    Button(String _bText) {
        this.bText = _bText;
    }
    
    boolean inFocus() {
        return mouseX >= leftX && mouseX <= leftX+w && mouseY >= leftY && mouseY <= leftY+h;
    }
    
    void display(float _x0, float _y0, float _w, float _h) {
        this.leftX = _x0; 
        this.leftY = _y0;
        this.w = _w;
        this.h = _h;
        fill(cReg);
        if (inFocus()) {
          fill(cHover);
        }
        stroke(1);
        rect(leftX, leftY, w, h);
        textAlign(CENTER, CENTER);
        fill(0);
        textSize(14);
        text(bText, leftX + w/2, leftY + h/2);
    }    
}

class ButtonFrame {
  Button hoverB, logAndB, logOrB;
  float leftX, leftY, w, h, buttonW, buttonH, xInterval;
  
   ButtonFrame() {
       hoverB = new Button("HOVER");
       logAndB = new Button("AND");
       logOrB = new Button("OR");
   } 
   
   void display(float _x0, float _y0, float _w, float _h) {
        this.leftX = _x0; 
        this.leftY = _y0;
        this.w = _w;
        this.h = _h;
        calcButtonPos();
        noStroke();
        fill(255);
        rect(leftX, leftY, w, h);
        stroke (1);
        hoverB.display(leftX + xInterval, leftY + h*0.1, buttonW, buttonH);
        logAndB.display(leftX + 2* xInterval + buttonW, leftY + h*0.1, buttonW, buttonH);
        logOrB.display(leftX + 3* xInterval + 2 *buttonW, leftY + h*0.1, buttonW, buttonH);
   }
   
   void calcButtonPos() {
        xInterval = w * 0.05;
        buttonH = h * 0.8;
        buttonW = w * 0.95 / 3 - xInterval;
   }
   
   void interpretClick() {
       if (hoverB.inFocus()) {
           hover = true;
           logAnd = logOr = false; 
       }
       else if (logAndB.inFocus()) {
           logAnd = true;
           hover = logOr = false;
       }
       else if (logOrB.inFocus()) {
           logOr = true;
           hover = logAnd = false;
       }  
     
   }
}
