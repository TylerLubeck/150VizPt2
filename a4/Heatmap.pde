class HPNode {
	int genCounter;
	int markedCounter;

	HPNode() {
		this.genCounter = 0;
		this.markedCounter = 0;
	}
}

class Heatmap {
	ArrayList<Date> times;
	ArrayList<String> dPorts;
	HPNode [][] hMap;
	int numNodes, maxCount, minCount;
	float pLabelW, tLabelH, blockW, blockH, x0, y0, w, h;
	SimpleDateFormat sdf;
	color highlight = color(255, 178, 102);


	Heatmap() {
		times = new ArrayList<Date>();
		dPorts = new ArrayList<String>();
		doCounts(true);
		sdf = new SimpleDateFormat("H:mm:ss");
	}  

	void doCounts(boolean initial) {
		numNodes = nodes.size();
		boolean changedTime = false, changedPort = false;
		for(Node curNode : nodes) {
                  println(curNode.time);
			if (! times.contains(curNode.time)) {
				times.add(curNode.time);
				changedTime = true;
			}
			if (!dPorts.contains(curNode.dPort)) {
				dPorts.add(curNode.dPort);
				changedPort = true;
			}
		}
		if (changedTime) {
			sortTimes();
		}
		if (changedPort) {
			sortPorts();
		}
		hMap = new HPNode[dPorts.size()][times.size()];
		if (initial) {
			initialMap();
		}
		else {
			mapAll();
		}
		setMinMax();
	}

	void sortTimes() {
		int j;
		Date temp;
		for (int i = 0; i < times.size(); ++i) {
			j = i-1;
			while (j > 0 && times.get(i).before(times.get(j))) {
				--j;
			}
			if (j+1 != i) {
				temp = times.get(i);
				times.remove(i);
				times.add(j+1, temp);
			}
		}
	}

	void sortPorts() {
		int j;
		String temp;
		String port1[], port2[];
		for (int i = 0; i < dPorts.size(); ++i) {
			j = i-1;
			port1 = splitTokens(dPorts.get(i), "-");
            if (j > 0) {
      			port2 = splitTokens(dPorts.get(j), "-");
      			while (Integer.parseInt(trim(port1[0])) < Integer.parseInt(trim(port2[0]))) {
      				--j;
      				port2 = splitTokens(dPorts.get(j), "-");
      			}
      			if (j+1 != i) {
      				temp = dPorts.get(i);
      				dPorts.remove(i);
      				dPorts.add(j+1, temp);
      			}
            }
		}
	}

	void initialMap() {
		int i, j;
		for(Node node : nodes) {
			i = dPorts.indexOf(node.dPort);
			j = times.indexOf(node.time);
			if (hMap[i][j] == null) {
				hMap[i][j] = new HPNode();
			}
			hMap[i][j].genCounter++;
		}
	}

	void mapAll() {
		int i, j;
		for(Node node : nodes) {
			i = dPorts.indexOf(node.dPort);
			j = times.indexOf(node.time);
			if (hMap[i][j] == null) {
				hMap[i][j] = new HPNode();
			}
			hMap[i][j].genCounter++;
			if (inRange(node)) {
				hMap[i][j].markedCounter++;
			}
		}
	}

	boolean inRange(Node node) {
		return false;
	}

	void resetMarked() {
		for (int i = 0; i < dPorts.size(); ++i) {
			for (int j = 0; j < times.size(); ++j) {
				if (hMap[i][j] != null) {
                    hMap[i][j].markedCounter = 0;
				}
			}
		}
	}

	void checkMarked() {
		for (Node node : nodes) {
			if (inRange(node)) {
				hMap[dPorts.indexOf(node.dPort)][times.indexOf(node.time)].markedCounter++;
			}
		}
	}

	void setMinMax() {
		int min = nodes.size(), max = 0;
		for (int i = 0; i < dPorts.size(); ++i) {
			for (int j = 0; j < times.size(); ++j) {
				if (hMap[i][j] != null && hMap[i][j].genCounter > max) {
					max = hMap[i][j].genCounter;
				}
				if (hMap[i][j] == null) {
                    min = 0;
                }
                else if (hMap[i][j].genCounter < min) {
					min = hMap[i][j].genCounter;
				}
			}
		}
		minCount = min;
		maxCount = max;
	}

	void setLabelSize() {
		textSize(12);
		float labelW = 0;
		for (String dPort : dPorts) {
			if (textWidth(dPort) > labelW) {
				labelW = textWidth(dPort);
			}
		}
		pLabelW = labelW+4;
		tLabelH = 14;
	}

	void draw(float _x0, float _y0, float _w, float _h) {
		if (numNodes != nodes.size()) {
			minCount = maxCount = 0;
			doCounts(false);
		}
		else {
			resetMarked();
		}
		this.x0 = _x0;
		this.y0 = _y0;
		this.w = _w;
		this.h = _h;
		fill(255);
        noStroke();
        rect(x0, y0, w, h);
        stroke(0);
		setLabelSize();
		blockH = (h - tLabelH) / dPorts.size();
		blockW = (w - pLabelW) / times.size();
		drawLabels();
		drawHeatmap();
	}

	void drawLabels() {
		textSize(12);
		textAlign(CENTER, CENTER);
		float startX = x0, startY = y0;
		for (String dPort : dPorts) {
			fill(220);
			rect(startX, startY, pLabelW, blockH);
			fill(0);
			text(dPort, startX + pLabelW/2, startY + blockH/2);
			startY += blockH;
		}
		startX = x0 + pLabelW; 
		startY = y0 + h -tLabelH;
		for (Date time : times) {
			fill(220);
			rect(startX, startY, blockW, tLabelH);
  			fill(0);
            textSize(9);
			text(sdf.format(time), startX + blockW/2, startY + tLabelH/2);
			startX += blockW;
		}
	}
    
    void drawHeatmap() {
    	int count;
    	float startX, startY, colr, colg, colb;
    	for (int i = 0; i < dPorts.size(); ++i) {
    		startX = x0 + pLabelW;
    		startY = y0 + i* blockH;
    		for (int j = 0; j < times.size(); ++j) {
    			count = hMap[i][j] == null? minCount: hMap[i][j].genCounter;
                if (count == 0) {
                	fill(255);
                }
                else {
    		    	colr = map(count, minCount, maxCount, 231, 134);
                    colg = map(count, minCount, maxCount, 232, 121);
                    colb = map(count, minCount, maxCount, 163, 38);
                    fill(colr, colg, colb);
                }
    			rect(startX, startY, blockW, blockH);
                if (hMap[i][j] != null && hMap[i][j].markedCounter != 0) {
                	fill(highlight);
                	rect(startX, startY, blockW * hMap[i][j].markedCounter / count, blockH);	
                }
    			startX += blockW;
    		}
    	}

    }
}
