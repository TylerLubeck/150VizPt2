
String csvSOE = "soe-funding.csv";
SqTreeMap[] tmaps = new SqTreeMap[6]; // The 6 possible tree maps to display
BarGraph[] bgraphs = new BarGraph[6]; // The 6 possible bar braphs to display
String[] cats = new String[3];    // The 3 sortable category titles
String toolTip;
int WHICH_BGRAPH = 5; // Which bar braph to display currently

Node getNextNode(Node r, String c) {
  Node newNode = new Node(c,0);
  int index = r.children.indexOf(newNode);
  if (index < 0) {
    r.children.add(newNode);
    newNode.parent = r;
    index = r.children.indexOf(newNode);
  }
  return r.children.get(index);
}

/**
 * 
 * c1 := sort by this category first
 * c2 := sort by this category second
 * c3 := sort by this category third
 **/
void insertNode(String c1, String c2, String c3, int value, TreeMap t, int i) {
  Node r = t.root;
  r = getNextNode(r,c1);
  r = getNextNode(r,c2);
  r = getNextNode(r,c3);
  String name = Integer.toString(i); //"#"+Integer.toString(r.children.size());
  Node temp = new Node(name, value);
  temp.parent = r;
  r.children.add(temp);
}

/**
 * Parses the given CSV file, populating a SqTreeMap object
 * for each of the (six) possible orderings of the variables.
 **/
void parseCSV(String fn) {
  
  String data[] = loadStrings(fn);
  int num_leaf = data.length - 1;
  
  String tmp[] = splitTokens(data[0],",");
  cats[0] = tmp[0]; cats[1] = tmp[1]; cats[2] = tmp[2];

  for (int i = 0; i < 6; i++) {
    tmaps[i] = new SqTreeMap(new Node("root",0));
  }

  int v;
  String d[];
  for (int i = 1; i < num_leaf; i++) {
    d = splitTokens(data[i],",");
    v = Integer.parseInt(d[3]);
    insertNode(d[0], d[1], d[2], v, tmaps[0], i);
    insertNode(d[0], d[2], d[1], v, tmaps[1], i);
    insertNode(d[1], d[0], d[2], v, tmaps[2], i);
    insertNode(d[1], d[2], d[0], v, tmaps[3], i);
    insertNode(d[2], d[0], d[1], v, tmaps[4], i);
    insertNode(d[2], d[1], d[0], v, tmaps[5], i);
  }

  for (int i = 0; i < 6; i++) {
    tmaps[i].root.updateValueSum();
    tmaps[i].root.sortChildrenAlphabetical();
    
    ArrayList<String> xData = tmaps[i].root.getIDs();
    ArrayList<Integer> yData = tmaps[i].root.getValueSums();
    bgraphs[i] = new BarGraph(xData, yData);
    bgraphs[i].items = new ArrayList<Drawable>();
    for (int j = 0; j < tmaps[i].root.children.size(); j++) {
      bgraphs[i].items.add((Drawable)new SqTreeMap(tmaps[i].root.children.get(j)));
    }
    
    tmaps[i].root.sortChildren();
  }

}

//float golden_ratio = 1.61803398875;

void setup() {
  parseCSV(csvSOE);
  size(1200,800); //ceil(1200*golden_ratio));
  frame.setResizable(true);

  ArrayList categories = new ArrayList<String>();
  categories.add(cats[0]);
  categories.add(cats[1]);
  categories.add(cats[2]);
  categories.add("Total");

  switchButton = new SwitchButton(categories, 100.00, 100.00);

//  tmaps[2].printMe();
}

void draw() {
  //tmaps[2].draw(0,0,width,height);
  toolTip = "";
  background(255,255,255);
  println(WHICH_BGRAPH);
  if (switchButton.buttonOrder.get(0) == cats[0] && switchButton.buttonOrder.get(1) == cats[1] && switchButton.buttonOrder.get(2) == cats[2])
    WHICH_BGRAPH = 0;
  if (switchButton.buttonOrder.get(0) == cats[0] && switchButton.buttonOrder.get(2) == cats[1] && switchButton.buttonOrder.get(1) == cats[2])
    WHICH_BGRAPH = 1;
  if (switchButton.buttonOrder.get(1) == cats[0] && switchButton.buttonOrder.get(0) == cats[1] && switchButton.buttonOrder.get(2) == cats[2])
    WHICH_BGRAPH = 2;
  if (switchButton.buttonOrder.get(1) == cats[0] && switchButton.buttonOrder.get(2) == cats[1] && switchButton.buttonOrder.get(0) == cats[2])
    WHICH_BGRAPH = 4;
  if (switchButton.buttonOrder.get(2) == cats[0] && switchButton.buttonOrder.get(0) == cats[1] && switchButton.buttonOrder.get(1) == cats[2])
    WHICH_BGRAPH = 3;
  if (switchButton.buttonOrder.get(2) == cats[0] && switchButton.buttonOrder.get(1) == cats[1] && switchButton.buttonOrder.get(0) == cats[2])
    WHICH_BGRAPH = 5;
  bgraphs[WHICH_BGRAPH].draw(255);
  if (! toolTip.equals("")) {
      textSize(15);
      textLeading(17);
      textAlign(LEFT);
      float textW = textWidth(toolTip);
      fill(255);
      rect(mouseX, mouseY-55, textW*1.1, 55);
      fill(0);
      text(toolTip, mouseX+ textW*0.05, mouseY-38);
      textAlign(CENTER, BOTTOM);
    }
  
  switchButton.draw();
}

