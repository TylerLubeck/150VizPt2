class Edge {
	float springL;
    float currLength;
    int nID;
    String sIP;
    String dIP;
    int numConnections; 
    int edgeWeight;

	Spring(double sprL) {
        this.springL = (float)sprL;
        this.springL *= 1/3;
	}
}
