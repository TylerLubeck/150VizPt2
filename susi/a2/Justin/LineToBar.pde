class LineToBar extends Animation {

	LineGraph fromGraph;
	BarGraph  toGraph;

	LineToBar(LineGraph l, BarGraph b) {
		this.fromGraph = l;
		this.toGraph = b;
		this.progressInterval = 0.005;
	}

	void draw(float x, float y, float w, float h) {
		//barGraph.draw(tintVal);
	}

};