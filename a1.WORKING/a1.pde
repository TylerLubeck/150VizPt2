
String csvSOE = "soe-funding.csv";
//String shfData = "hierarchy.shf";
String shfData = "hierarchy2.shf";
//String shfData = "hierarchy3.shf";
SqTreeMap sqtreemap;
String toolTip = "";

/**
 * Finds nodes with IDs id0 and id1 in the list of nodes, making
 * Node(id1) the child of Node(id0)
 **/
void linkNodes(String id0, String id1, ArrayList<Node> nodes) {
  
  int i0 = nodes.indexOf(new Node(id0));
  int i1 = nodes.indexOf(new Node(id1));
  if (i0 < 0) {
    nodes.add(new Node(id0));
    i0 = nodes.indexOf(new Node(id0));
  }
  if (i1 < 0) {
    nodes.add(new Node(id1));
    i1 = nodes.indexOf(new Node(id1));
  }
 
  //println(i0,i1);
  /* Find n0 and n1, adding n1 to n0's list of children: */
  Node n0 = nodes.get(i0);
  Node n1 = nodes.get(i1);
  n0.children.add(n1);
  n1.parent = n0;

}

/** Recursively determines the root node of a tree */
Node findRoot(Node n) {
  if (n.parent == null)
    return n;
  return findRoot(n.parent);
}

/**
 * Parses the given SHF file, populating a SqTreeMap object and
 * storing it in the sqtreemap global variable
 **/
void parseSHF(String fn) {
    
  /* Loop variables */
  String tmp[];
  int size;
  String id0,id1;
  String id;

  String data[] = loadStrings(fn);
  int num_nodes = Integer.parseInt(trim(data[0]));
  int num_rltns = Integer.parseInt(trim(data[num_nodes+1]));
  ArrayList<Node> nodes = new ArrayList<Node>();
  
  /* Create leaf nodes from SHF */
  for (int i = 1; i <= num_nodes; i++) {
    tmp = splitTokens(data[i]);
    //println(tmp);
    id = trim(tmp[0]);
    size = Integer.parseInt(trim(tmp[1]));
    nodes.add(new Node(id,size));
  }

  /* Add parent-child relationships to nodes */
  for (int i = num_nodes + 2; i < num_nodes + 2 + num_rltns; i++) {
    tmp = splitTokens(data[i]);
    id0 = trim(tmp[0]);
    id1 = trim(tmp[1]);
    linkNodes(id0,id1,nodes);
    //println(id0,",",id1);
  }

  sqtreemap = new SqTreeMap(findRoot(nodes.get(0)));
  sqtreemap.root.updateValueSum();
  sqtreemap.root.sortChildren();

}

/**
 * Zooms in / out on the cell which was clicked.
 *   left click == zoom in
 *   right click == zoom out
 **/
void mouseClicked() {
  if (mouseButton  == LEFT)
    sqtreemap.zoomIn();
  else if (mouseButton == RIGHT && sqtreemap.curr_root.parent != null)
    sqtreemap.curr_root = sqtreemap.curr_root.parent;
}

void setup() {
  parseSHF(shfData);
  size(600,400);
  frame.setResizable(true);
}

void draw() {
  background(255,255,255);
  if (width > 50 && height > 50)
    sqtreemap.draw(0,0,width,height);
}

