import java.util.Map;
class Parser {
  private String fileName;  //Stores the file name, just in case.
  private String[] lines;   //Stores all of the lines in the input file
  private int numLeaves;    //Stores the count of leaves in the input file
  private int numRelations; //Stores the count of relations in the input file
  private HashMap<Integer, Integer> idToValMap; //Stores a map of (leaf id) -> (leaf value).
  private HashMap<Integer, Integer> parentToChildMap; //Stores a map of (parent leaf id) -> (child leaf value)

  Parser(String fileName) {
    this.fileName = fileName;
    //Read the lines from the file
    this.lines = loadStrings(this.fileName);
    
    //Create the blank HashMaps
    this.idToValMap = new HashMap<Integer,Integer>();
    this.parentToChildMap = new HashMap<Integer,Integer>();
    
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
    for (int i=1; i <= (this.numLeaves); i++) {
      line = this.lines[i];
      parts = split(line, ' ');
      this.idToValMap.put(int(parts[0]), int(parts[1]));
    }
  }
  
  // Goes through the input file and grabs the (parent id, child id) tuples.
  // Puts them in the (parent leaf id) -> (child leaf id) HashMap
  void parseRelations() {
    int startIndex = this.numLeaves + 2;
    int endIndex = startIndex + this.numRelations;
    String line = "";
    String[] parts = {};
    for (int i = startIndex; i < endIndex; i ++) {
      line = this.lines[i];
      parts = split(line, ' ');
      this.parentToChildMap.put(int(parts[0]), int(parts[1])); 
    }
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
  
  HashMap<Integer, Integer> getRelationsMap() {
    return this.parentToChildMap; 
  }
  
  String getFileName() {
    return this.fileName; 
  }
}


