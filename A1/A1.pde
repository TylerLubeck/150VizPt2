float VA_Ratio; 
int cHeight;
int cWidth; 
int short_side; 
Sides currentSide;
Canvas c;

void setup() {
  size(500, 400); 
  /* TODO:
   * In order to zoom out properly, consider doing this:
   * When left click, record the ID of the element clicked on.
   * When right click, if there is an ID recorded, just draw that one
  */
  frame.setResizable(true);  
  Parser p = new Parser("hierarchy.shf"); 
  Node root = p.parse();
  
  /* TESTING ROW */ 
  float total_area = width * height;
  float total_value = root.val; 

  VA_Ratio = total_area/(total_value); 
  int cHeight = height;
  int cWidth = width; 
  println(cHeight + " " + cWidth); 
  currentSide = cHeight > cWidth ? Sides.WIDTH : Sides.HEIGHT; 
  int short_side = min(height, width); 
 
  //Row testRow = new Row(VA_Ratio, 0, 0, 0, short_side, currentSide);
  //Row testRow = new Row(root.getChildren().get(0), 0, 0, short_side, currentSide, VA_Ratio); 
  //testRow.addRect(root.getChildren().get(1)); 
  
 // testRow.addRect(short_side, root.getChildren().get(0)); 
  //testRow.addRect(short_side, root.getChildren().get(1));  
  //testRow.render(); 
  
  //traverse the tree
  //println(root.children.size());
  c = new Canvas(0,0,width,height);
  squarify(root, c.mWidth*c.mHeight / root.getValue());
  //c.Print();
  //println("Num of rows in canvas is ", c.rows.size());
  c.render(); 
  //Row testRow = new Row(root.getChildren().get(0), 0, 0, short_side, currentSide, VA_Ratio); 
  //testRow.render(); 
  
  
}

void squarify(Node x, float siblingSum){
  if(x.children == null){
    println("Adding node x:",x.getValue());
    c.addSquare(x, siblingSum);
    c.Print();
  } else{
    int denom = 0;
    for( Node child : x.children ){
      denom+= child.getValue();
    }
    siblingSum = c.mWidth * c.mHeight / denom;
    for(int i=0; i<x.children.size(); i++){
      squarify(x.children.get(i),siblingSum);
    }
  }
}

void draw() {
  
}
