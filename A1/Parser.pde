import java.util.Map;
import java.util.Set;
import java.util.HashSet;
class Parser {
  private String fileName;  //Stores the file name, just in case.
  private String[] lines;   //Stores all of the lines in the input file
  private int numLeaves;    //Stores the count of leaves in the input file
  private int numRelations; //Stores the count of relations in the input file
  private HashMap<Integer, Integer> idToValMap; //Stores a map of (leaf id) -> (leaf value).
  private HashMap<Integer, ArrayList<Integer>> parentToChildMap; //Stores a map of (parent leaf id) -> (child leaf value)
  private int rootNodeID;
  private Node rootNode;

  Parser(String fileName) {
    this.fileName = fileName;
    //Read the lines from the file
    this.lines = loadStrings(this.fileName);

    //Create the blank HashMaps
    this.idToValMap = new HashMap<Integer, Integer>();
    this.parentToChildMap = new HashMap<Integer, ArrayList<Integer>>();
    this.rootNode = null;

    //The format spec tells us where in the file to find these values. Grab them and store them.
    this.numLeaves = Integer.parseInt(this.lines[0]);
    this.numRelations = Integer.parseInt(this.lines[this.numLeaves + 1]);

    //Using the information gathered, parse for leaves and relations
    this.parseLeaves();
    this.parseRelations();
  }

  // Goes through the input file and grabs the (id, value) tuples.
  // Puts them in the (leaf id) -> (leaf value) HashMap
  void parseLeaves() {
    String line = "";
    String[] parts = {};
    int val = 0;
    for (int i=1; i <= (this.numLeaves); i++) {
      line = this.lines[i];
      parts = split(line, ' ');
      val += int(parts[1]);
      this.idToValMap.put(int(parts[0]), int(parts[1]));
    }
    
    println("Expected value: " + val);
  }

  // Goes through the input file and grabs the (parent id, child id) tuples.
  // Puts them in the (parent leaf id) -> (child leaf id) HashMap
  void parseRelations() {
    
    int startIndex = this.numLeaves + 2;
    int endIndex = startIndex + this.numRelations;
    Set<Integer> rootSet = new HashSet<Integer>();
    Set<Integer> childSet = new HashSet<Integer>();
    String line = "";
    String[] parts = {};
    ArrayList<Integer> childRelations = null;
    for (int i = startIndex; i < endIndex; i ++) {
      line = this.lines[i];
      parts = split(line, ' ');
      rootSet.add(int(parts[0]));
      childSet.add(int(parts[1]));
      childRelations = this.parentToChildMap.get(int(parts[0]));
      if ( childRelations == null) {
        childRelations = new ArrayList<Integer>();
      }
      childRelations.add(int(parts[1]));
      this.parentToChildMap.put(int(parts[0]), childRelations);
    }
    
    
    this.rootNodeID = rootSet.toArray(new Integer[rootSet.size()])[0];
  }

  int getNumberOfRelations() {
    return this.numRelations;
  }

  int getNumberOfLeaves() {
    return this.numLeaves;
  }

  HashMap<Integer, Integer> getLeavesMap() {
    return this.idToValMap;
  }

  HashMap<Integer, ArrayList<Integer>> getRelationsMap() {
    return this.parentToChildMap;
  }

  String getFileName() {
    return this.fileName;
  }

  //TODO: Not void
  Node parse() {
    if (this.rootNode != null) {
      return this.rootNode;
    }
    
    this.rootNode = buildRoot(this.rootNodeID);
    rootNode.sortTree();  
    return this.rootNode;
  }
  
  Node buildRoot(int ID) {
    ArrayList<Integer> children = this.parentToChildMap.get(ID);
    if (children == null) {
      int val = this.idToValMap.get(ID);
      return new Node(ID, val);
    }
    
    Node thisBranch = new Node(ID); //TODO: Add Parent info
    
    for (int childID : children) {
      thisBranch.addChild(buildRoot(childID)); 
    }
    
    thisBranch.sumTheChildren();
    println(thisBranch.getID() + ": " + thisBranch.getValue());
    return thisBranch;
  }
  

}

