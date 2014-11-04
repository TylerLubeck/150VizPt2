class Edge {
	float springL;
    float currLength;
    //Info about strokeWeight, b/c it is num connections
    ArrayList<Integer> nIDs;
    String ip1;
    String ip2;
    int edgeWeight;
    Edge(){};

    Edge(String sIP_, String dIP_, int firstnID) {
    	this.ip1 = sIP_;
    	this.ip2 = dIP_;
    	nIDs = new ArrayList<Integer>();
        nIDs.add(firstnID);
        this.springL = (float)200;
    }

    String toString() {
        return String.format("%d: %s -> %s", this.nIDs.size(), this.ip1, this.ip2);
    }

    void setLength(int min_, int max_) {
        int minLen = 50;
        int maxLen = 60;
        int minEdgeW = 3;
        int maxEdgeW = 8;
        this.springL = map(this.nIDs.size(), min_, max_, minLen, maxLen);
        this.edgeWeight = int(map(this.nIDs.size(), min_, max_, minEdgeW, maxEdgeW));
    }
}
