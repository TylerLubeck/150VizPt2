class Parser {
	
	Parser(String fileName) {
		String tempData[];
		Node tempNode;
		Spring tempSpring;
		String data[] = loadStrings(fileName);
		int numNodes = Integer.parseInt(trim(data[0]));
  		int numRltns = Integer.parseInt(trim(data[numNodes+1]));
  		for(int i = 1; i <= numNodes; ++i) {
  			tempData = splitTokens(data[i], ",");
  			tempNode = new Node(Integer.parseInt(trim(tempData[0])), Integer.parseInt(trim(tempData[1])));
  			nodes.add(tempNode);
  		}
  		for (int i = numNodes + 2; i < numNodes + 2 + numRltns; ++i) {
  			tempData = splitTokens(data[i], ",");
  			tempSpring = new Spring(Double.parseDouble(trim(tempData[2])));
  			makeConnection(Integer.parseInt(trim(tempData[0])), Integer.parseInt(trim(tempData[1])), tempSpring);
  		}
	}

	void makeConnection(int id1, int id2, Spring spring) {
		int index1 = -1;
		int index2 = -1;
		for (int i = 0; i < nodes.size(); ++i) {
			if (nodes.get(i).id == id1)
				index1 = i;
			else if (nodes.get(i).id == id2)
				index2 = i;
		}
		if (index1 == -1 || index2 == -1)
			println("ERROR IN PARSING");
		nodes.get(index1).neighbors.add(nodes.get(index2));
		nodes.get(index1).springs.add(spring);
		nodes.get(index2).neighbors.add(nodes.get(index1));
		nodes.get(index2).springs.add(spring);
	}
}
