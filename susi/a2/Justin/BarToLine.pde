class BarToLine {

	LineGraph lineGraph;
	BarGraph  barGraph;

	BarToLine(LineGraph l, BarGraph b) {
		this.lineGraph = l;
		this.barGraph  = b;
	}

	void draw(int tintVal) {
		lineGraph.draw(tintVal);
	}

};