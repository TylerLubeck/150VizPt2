class LineToBar extends Animation {

	LineGraph fromGraph;
	BarGraph  toGraph;
	float xInterval, fadeProg;
	boolean reduceDotsFinished, isFinished;

	LineToBar(LineGraph l, BarGraph b) {
		this.fromGraph = l;
		this.toGraph = b;
		this.progressInterval = 0.01;
		this.xInterval = width*0.8 / (float(this.toGraph.xData.size()) + 1.0);
		this.reduceDotsFinished = false;
		this.isFinished = false;
		this.fadeProg = 0.0;
	}

	void draw(float x, float y, float w, float h) {
		this.xInterval = width*0.8 / (float(this.toGraph.xData.size()) + 1.0);
                animate(x,y,w,h);

		if (isFinished) {
			fadeBarIn();
			if (fadeProg >= 1) {
				inTransition = false;
				bar = true;
				line = false;
                                toBar = false;
				progress = 0.0;
				reduceDotsFinished = false;
				isFinished = false;
				fadeProg = 0.0;
			}
		}
		progress += progressInterval;
	}

	void animate(float x, float y, float w, float h) {
		float tickX = width*0.1 + xInterval;
		float widthB = xInterval*0.9;
		float upperY, heightB;
		float upperX = tickX;
		float prevX = upperX;
		float prevY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(0);

		if (!reduceDotsFinished) {
			for (int i=0; i<toGraph.xData.size(); i++) {
	      		upperY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(i);

	      		float dotWidth = 0.015*width;
	  			float newY = upperY-(lerp(prevY,upperY, progress)-prevY);
	  			float newX = upperX-(lerp(prevX,upperX, progress)-prevX);
	  			if (newX > prevX){
	      			line(prevX, prevY, newX, newY);
	      			prevX = upperX;
					prevY = upperY;
					fill(255,255,179);
					if (i==1) {
						float firstX = width*0.1 + xInterval;
						float firstY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(0);
						ellipse(firstX, firstY, dotWidth, dotWidth);
						ellipse(upperX, upperY, dotWidth, dotWidth);
					} else {
						ellipse(upperX, upperY, dotWidth, dotWidth);
					}
				} else if (newX < prevX) {
					float dotInterval = lerp(0, dotWidth, progress);
					float dot = dotWidth*2 - dotInterval;
					fill(255,255,179);
					if (i==1) {
						float firstX = width*0.1 + xInterval;
						float firstY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(0);
						ellipse(firstX, firstY, dot, dot);
						ellipse(upperX, upperY, dot, dot);
					}
					else
						ellipse(upperX, upperY, dot, dot);
				}
	      		upperX += xInterval;
			}
			if (progress >= 2.0) {
				progress = 0.0;
				reduceDotsFinished = true;
			}
		} else {
			for (int i=0; i<toGraph.xData.size(); i++) {
				upperY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(i);
				upperX = tickX-(xInterval*0.9)/2;
				heightB = fromGraph.unit * fromGraph.yData.get(i);
				fill(255,255,179);
				float wInterval = lerp(0, widthB, progress);
				float hInterval = lerp(0, heightB, progress);
				float newUpperX = lerp(upperX, upperX + widthB/2, progress);
				if (hInterval <= heightB) {
					rect(upperX, upperY, wInterval , hInterval);
				} else {
					isFinished = true;
				}

				tickX += xInterval;
			}
		}
	}

	void fadeBarIn() {
		fadeProg += 0.01;
		toGraph.setTint(int(lerp(0,255,fadeProg)));
		fill(0, int(lerp(0,255,fadeProg)));
		toGraph.drawAxis();
		toGraph.drawYTicks();
		toGraph.drawXTicks();
		toGraph.drawXLabels();
		toGraph.drawBars(255);
	}

};







