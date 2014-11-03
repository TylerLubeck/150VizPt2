class Edge {
	float springL;
    float currLength;
    //Info about strokeWeight, b/c it is num connections
    ArrayList<Integer> nIDs;
    String ip1;
    String ip2;
    int edgeWeight;
    Edge(){};

    Edge(String sIP_, String dIP_) {
    	this.ip1 = sIP_;
    	this.ip2 = dIP_;
    	nIDs = new ArrayList<Integer>();
    }

	Edge(double sprL) {
        this.springL = (float)sprL;
        this.springL *= 1/3;
	}
}
