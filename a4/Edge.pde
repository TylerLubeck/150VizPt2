class Edge {
	float springL;
    float currLength;
    //Info about strokeWeight, b/c it is num connections
    ArrayList<Integer> nIDs;
    String sIP;
    String dIP;
    int edgeWeight;
    Edge(){};

    Edge(String sIP_, String dIP_) {
    	this.sIP = sIP_;
    	this.dIP = dIP_;
    	nIDs = new ArrayList<Integer>();
    }

	Edge(double sprL) {
        this.springL = (float)sprL;
        this.springL *= 1/3;
	}

    String toString() {
        return String.format("%d: %s -> %s", this.nIDs.size(), this.ip1, this.ip2);
    }
}
