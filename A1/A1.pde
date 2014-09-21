float VA_Ratio; 
int cHeight;
int cWidth; 
int short_side; 
Sides currentSide; 

void setup() {
  size(400, 300); 
  /* TODO:
   * In order to zoom out properly, consider doing this:
   * When left click, record the ID of the element clicked on.
   * When right click, if there is an ID recorded, just draw that one
  */
  frame.setResizable(true);  
  Parser p = new Parser("hierarchy2.shf"); 
  Node root = p.parse();
  
  /* TESTING ROW */ 
  float total_area = width * height;
  float total_value = root.val; 
  VA_Ratio = total_area/(total_value); 
  int cHeight = height;
  int cWidth = width; 
  currentSide = height > width ? Sides.WIDTH : Sides.HEIGHT; 
  int short_side = min(height, width); 
 
  Row testRow = new Row(VA_Ratio, 0, 0, 0, short_side);
  testRow.addRect(short_side, currentSide, root.getChildren().get(0)); 
  //testRow.addRect(short_side, currentSide, root.getChildren().get(1));  
  testRow.render(); 
  
  
}

void draw() {
  
}
