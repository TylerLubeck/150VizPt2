class BarToLine extends Animation {

	BarGraph  fromGraph;
	LineGraph toGraph;
	float barWidth, fadeProg;
	float xInterval, xPos, yPos;
	boolean isFinished, reduceBarsFinished;

	BarToLine(BarGraph b, LineGraph l) {
		this.fromGraph = b;
		this.toGraph  = l;
		this.progressInterval = 0.01;
		this.xInterval = width*0.8 / (float(this.toGraph.xData.size()) + 1.0);
		this.barWidth = this.xInterval*0.9;
		this.isFinished = false;
		this.reduceBarsFinished = false;
		this.fadeProg = 0.0;
	}

	void draw(float x, float y, float w, float h) {
		this.xInterval = width*0.8 / (float(this.toGraph.xData.size()) + 1.0);
    
		animate(x,y,w,h);

		if (isFinished) {
			fadeLineIn();
			if (fadeProg >= 1) {
				inTransition = false;
				bar = false;
				line = true;
                                toLine = false;
				progress = 0.0;
				barWidth = xInterval*0.9;
				isFinished = false;
				reduceBarsFinished = false;
				fadeProg = 0.0;
			}
		}
		progress += progressInterval;
	}

	void animate(float x, float y, float w, float h) {
		float tickX = width*0.1 + xInterval;
		float widthB = xInterval*0.9;
		float heightB, upperX, upperY, newWidth;
		float prevX = tickX;
		float prevY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(0);
		
		if (!isFinished) {
			for (int i=0; i<toGraph.xData.size(); i++) {
				upperX = tickX-(xInterval*0.9)/2;
	      		upperY = fromGraph.zeroY-fromGraph.unit * fromGraph.yData.get(i);
				heightB = fromGraph.unit * fromGraph.yData.get(i);


				float x1 = upperX+widthB/2;
				float y1 = upperY;
				float x2 = x1;
				float y2 = y1 + heightB;
				float newY = y2 - (lerp(y1, y2, progress) - y2);
				float dotWidth = 0.015*width;
				float dotInterval = lerp(0, dotWidth, progress);
				float dot = dotWidth - dotInterval;

				if (!reduceBarsFinished) {
					if (barWidth > 1.0) {
						float newUpperX = lerp(upperX, upperX + widthB/2, progress);
						newWidth = lerp(0, widthB, progress);
						barWidth = widthB - newWidth;
						fill(255,255,179);
						rect(newUpperX, upperY, barWidth, heightB);
					} else {

						if (newY >= y1) {
							line(x1, y1, x2, newY);
							fill(255,255,179);
							ellipse(x1, y1, dot, dot);
						} else {
							reduceBarsFinished = true;
							progress = 0.0;
						}
					}
				} else {
		  			newY = lerp(prevY, y1, progress);
		  			float newX = lerp(prevX, x1, progress);
		  			if (newX <= x1) {
						line(prevX, prevY, newX, newY);
						prevX = x1;
						prevY = y1;	
		  			} else {
		  				isFinished = true;
		  			}

					fill(255,255,179);
					ellipse(x1, y1, dotWidth, dotWidth);
				}


				tickX+= xInterval;
			}
		}

	}

	void fadeLineIn() {
		fadeProg += 0.01;
		toGraph.setTint(int(lerp(0,255,fadeProg)));
		fill(0, int(lerp(0,255,fadeProg)));
		toGraph.drawAxis();
		toGraph.drawYTicks();
		toGraph.drawXTicks();
		toGraph.drawXLabels();	
		toGraph.drawDots(255);
		toGraph.drawLines(255);
	}

};





