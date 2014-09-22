int cHeight;
int cWidth; 
int short_side; 
Sides currentSide;
Canvas mainCanvas;
Node root; 
void setup() {
  size(400, 500); 
  /* TODO:
   * In order to zoom out properly, consider doing this:
   * When left click, record the ID of the element clicked on.
   * When right click, if there is an ID recorded, just draw that one
  */
  frame.setResizable(true);  
  Parser p = new Parser("hierarchy2.shf"); 
  root = p.parse();
  mainCanvas = new Canvas(0,0,width,height);
}

void squarify(Node x, Canvas c){
  if(x.children == null){
      return;
    }else{
    float va_ratio = c.mWidth * c.mHeight / x.getValue();
    
    for(int i=0; i<x.children.size(); i++){
      c.addSquare(x.children.get(i), va_ratio);
    }
    for(int i=0; i<x.children.size(); i++){
      Rectangle childRect = c.getRectByID(x.children.get(i).getID());
      Canvas childCanvas = new Canvas(childRect);
      squarify(x.children.get(i),childCanvas);
    }
  }
}

void draw() {
  squarify(root, mainCanvas);
  mainCanvas.render();
}
