float VA_Ratio; 
int cHeight;
int cWidth; 
int short_side; 
Sides currentSide;
Canvas c;

void setup() {
  size(400, 300); 
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
  currentSide = height > width ? Sides.WIDTH : Sides.HEIGHT; 
  int short_side = min(height, width); 
  
  //traverse the tree
  println(root.children.size());
  c = new Canvas(0,0,width,height);
  squarify(root);
  c.Print();
  println("Num of rows in canvas is ", c.rows.size());
 
  //Row testRow = new Row(root.getChildren().get(0), 0, 0, short_side, currentSide, VA_Ratio); 
  //testRow.render(); 
  
  
}

void squarify(Node x){
  if(x.children == null){
    println("Adding node x:",x.getValue());
    c.addSquare(x);
    c.Print();
  } else{
    for(int i=0; i<x.children.size(); i++){
      squarify(x.children.get(i));
    }
  }
}

void draw() {
  
}
