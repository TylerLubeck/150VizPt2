void setup() {
  
  /* TODO:
   * In order to zoom out properly, consider doing this:
   * When left click, record the ID of the element clicked on.
   * When right click, if there is an ID recorded, just draw that one
  */
   
  Parser p = new Parser("hierarchy2.shf"); 
  p.parse();
  println("done");
  //println("There are " + p.getNumberOfLeaves() + " leaves");
}

void draw() {
  
}
