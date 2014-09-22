float VA_Ratio; 
int cHeight;
int cWidth; 
int short_side; 
Sides currentSide;
Canvas c;
Node root; 
void setup() {
  size(400, 500); 
  /* TODO:
   * In order to zoom out properly, consider doing this:
   * When left click, record the ID of the element clicked on.
   * When right click, if there is an ID recorded, just draw that one
  */
  frame.setResizable(true);  
  Parser p = new Parser("hierarchy_original.shf"); 
  root = p.parse();
   
}

void squarify(Node x, float siblingSum){
  if(x.children == null){
    println("Adding node x:",x.getValue());
    c.addSquare(x, siblingSum);
    //c.Print();
  } else{
    int denom = 0;
    for( Node child : x.children ){
      println("Node x has children " + x.getID() + " " + x.getValue()); 
      denom+= child.getValue();
    }
    siblingSum = c.mWidth * c.mHeight / denom;
    for(int i=0; i<x.children.size(); i++){   
      squarify(x.children.get(i),siblingSum);
    }
  }
}

void draw() {
  c = new Canvas(0,0,width,height); 
  squarify(root, c.mWidth*c.mHeight / root.getValue());
  c.render();
}
