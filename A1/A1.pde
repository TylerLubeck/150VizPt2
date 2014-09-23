import java.util.Stack;
int cHeight;
int cWidth; 
int short_side; 
Sides currentSide;
Canvas mainCanvas;
Node root; 
Stack<Node> rootStack;
Node currentRoot;
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
  currentRoot = root;
  rootStack = new Stack<Node>();
  println("root id is",currentRoot.getID());
  println("root num children is",currentRoot.children.size());
}

void squarify(Node x, Canvas c){
  if(x.children == null){
      return;
    }else{
    float va_ratio = c.mWidth * c.mHeight / x.getValue();
    
    for(int i=0; i<x.children.size(); i++){
      c.addSquare(x.children.get(i), va_ratio);
    }
    c.render();
    for(int i=0; i<x.children.size(); i++){
      Rectangle childRect = c.getRectByID(x.children.get(i).getID());
      Canvas childCanvas = new Canvas(childRect);
      squarify(x.children.get(i),childCanvas);
      childCanvas.render();
    }
  }
  println(root.getNodeById(6).getValue()); 
}

int getSelectedId(float x, float y) {
  for (Row r : mainCanvas.rows) {
    for (Rectangle re : r.rects) {
      println("In rect ", re.getID());
      if (re.isWithin(x, y)) {
        return re.getID();
      }
    }
  }
  return -1;
}

void draw() {
  mainCanvas = new Canvas(0,0,width,height);
  squarify(currentRoot, mainCanvas);
  //println("NUM ROWS: ", mainCanvas.rows.size());
  //mainCanvas.render();
}

void zoomIn(float x, float y){
  println("Current Root ID: ", currentRoot.getID());
  println("LOL zoom in ha");
  int id = getSelectedId(x, y);
  if (id == -1) {
    println("NO ID");
    return;
  }
  println("Found ID: ", id);
  Node n = root.getNodeById(id);
  println("Found Node: ", n);
  if (n == null) {
    println("NO NODE");
    return;
  }
  rootStack.push(currentRoot);
  currentRoot = n;
}

void zoomOut(){
  if(!rootStack.empty()) {
      currentRoot = rootStack.pop();
      println("LOL zoom out ha");
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    zoomIn(mouseX, mouseY);
  } else if(mouseButton == RIGHT) {
    zoomOut();
  }
}
