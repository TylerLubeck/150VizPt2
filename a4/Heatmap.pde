class HPNode {
    ArrayList<Integer> indices;
	int markedCounter;

	HPNode() {
		this.indices = new ArrayList<Integer>();
		this.markedCounter = 0;
	}
}

class Heatmap  {
	ArrayList<Date> times;
	ArrayList<String> dPorts;
	HPNode [][] hMap;
	int numNodes, maxCount, minCount;
	float pLabelW, tLabelH, blockW, blockH, leftX, leftY, w, h;
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
            hMap[i][j].indices.add(node.id);
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
            hMap[i][j].indices.add(node.id);
			if (selected_nodes.contains(node.id)) {
				hMap[i][j].markedCounter++;
			}
		}
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
			if (selected_nodes.contains(node.id)) {
				hMap[dPorts.indexOf(node.dPort)][times.indexOf(node.time)].markedCounter++;
			}
		}
	}

	void setMinMax() {
		int min = nodes.size(), max = 0;
		for (int i = 0; i < dPorts.size(); ++i) {
			for (int j = 0; j < times.size(); ++j) {
				if (hMap[i][j] != null && hMap[i][j].indices.size() > max) {
					max = hMap[i][j].indices.size();
				}
				if (hMap[i][j] == null) {
                    min = 0;
                }
                else if (hMap[i][j].indices.size() < min) {
					min = hMap[i][j].indices.size();
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

	public void display(float _x0, float _y0, float _w, float _h) {
		if (numNodes != nodes.size()) {
			minCount = maxCount = 0;
			doCounts(false);
		}
		else {
			resetMarked();
			checkMarked();
		}
		this.leftX = _x0;
		this.leftY = _y0;
		this.w = _w;
		this.h = _h;
		fill(255);
        noStroke();
        rect(leftX, leftY, w, h);
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
		float startX = leftX, startY = leftY;
		for (String dPort : dPorts) {
			fill(220);
			rect(startX, startY, pLabelW, blockH);
			fill(0);
			text(dPort, startX + pLabelW/2, startY + blockH/2);
			startY += blockH;
		}
		startX = leftX + pLabelW; 
		startY = leftY + h -tLabelH;
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
    		startX = leftX + pLabelW;
    		startY = leftY + i* blockH;
    		for (int j = 0; j < times.size(); ++j) {
    			count = hMap[i][j] == null? minCount: hMap[i][j].indices.size();
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
                	rect(startX, startY, blockW, blockH* hMap[i][j].markedCounter / count);	
                }
    			startX += blockW;
    		}
    	}
    }

    public void hover() {
    	int row, col;
    	if (inTable()) {
    		row = int((mouseY-leftY) / blockH);
    		col = int((mouseX - leftX - pLabelW) / blockW);
                if (hMap[row][col] != null) {
    		    selected_nodes.addAll(hMap[row][col].indices);
                }
    	}
    }

    public ArrayList<Integer> handleThisArea(Rectangle rect) {
    	int startRow, endRow, startCol, endCol;
        Rectangle rectSub = getIntersectRegion(rect);
        ArrayList<Integer> temp = new ArrayList<Integer>();
        if (rectSub != null) {
        	startRow = int((rectSub.p1.y - leftY) / blockH);
        	endRow = int((rectSub.p2.y - leftY) / blockH) > dPorts.size() -1  ? dPorts.size() -1 : int((rectSub.p2.y - leftY) / blockH) ;
        	startCol = int((rectSub.p1.x - leftX - pLabelW) / blockW);
        	endCol = int((rectSub.p2.x - leftX - pLabelW) / blockW);
        	for (int i = startRow; i <= endRow; ++i) {
        		for (int j = startCol; j <= endCol; ++j) {
                                if (hMap[i][j] != null) {
        			     temp.addAll(hMap[i][j].indices);
                                }
        		}
        	}
                return temp;
        }  
        return null;
    }

    boolean inTable() {
    	return mouseX > leftX + pLabelW && mouseY > leftY 
    			&& mouseX < leftX + w && mouseY < leftY + h - tLabelH;
	}

    public Rectangle getIntersectRegion(Rectangle rect) {
        Rectangle rect2 = new Rectangle(leftX + pLabelW, leftY, leftX + w, leftY + h - tLabelH);
        return getIntersectRegion(rect, rect2);
    }

    public boolean isIntersected(Rectangle rect1, Rectangle rect2) {
           boolean flag1 = abs(rect2.p2.x + rect2.p1.x - rect1.p2.x - rect1.p1.x) - (rect1.p2.x - rect1.p1.x + rect2.p2.x - rect2.p1.x) <= 0;
           boolean flag2 = abs(rect2.p2.y + rect2.p1.y - rect1.p2.y - rect1.p1.y) - (rect1.p2.y - rect1.p1.y + rect2.p2.y - rect2.p1.y) <= 0;
           return flag1 && flag2;
    }

    private Rectangle getIntersectRegion(Rectangle rect1, Rectangle rect2){
          if(isIntersected(rect1, rect2)){
              float x1 = max(rect1.p1.x, rect2.p1.x);
              float y1 = max(rect1.p1.y, rect2.p1.y);
              float x2 = min(rect1.p2.x, rect2.p2.x);
              float y2 = min(rect1.p2.y, rect2.p2.y);
              if (y1 == y2 && y1 == leftY) {
                  return null;
              }
              return new Rectangle(x1, y1, x2, y2);
          }
          return null;
     }
}
