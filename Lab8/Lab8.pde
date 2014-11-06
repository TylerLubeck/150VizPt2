Table table;
String[] headers;
ArrayList<VerticalLine> lines;

void readData() {
    table = loadTable("iris.csv", "header");    
    headers = table.getColumnTitles();
    lines = new ArrayList<VerticalLine>();

    int numColumns = table.getColumnCount();
    for(int i = 0; i < numColumns; i++) {
        float[] vals = table.getFloatColumn(i);
        float maxVal = max(vals);
        float minVal = min(vals);
        VerticalLine newLine = new VerticalLine(minVal, maxVal,
                                                headers[i]);
        println(newLine.getYPos(1.2));
        println(newLine);
        lines.add(newLine);
    }
}

void setup() {
    size(600,600);
    readData();
    frame.setResizable(true);
}


void draw() {
    background(0);
    float startingX = width * .1;
    float xInterval = width / lines.size();
    for(VerticalLine l : lines) {
        l.setX(startingX);
        startingX += xInterval;
    }
  float x1, y1, x2, y2;
  int counter = 0;
  for (VerticalLine l : lines) {
        l.drawLine();
  }
  for (int i = 0; i < table.getRowCount(); ++i) {
    for (int j = 0; j < lines.size() -1; ++j) {
      x1 = lines.get(j).x;
      y1 = table.getFloatColumn(lines.get(j).title)[i];
      x2 = lines.get(j+1).x;
      y2 = table.getFloatColumn(lines.get(j+1).title)[i];
      pushStyle();
      strokeWeight(1);
      stroke(0,230,0,50);
      line(x1, lines.get(j).getYPos(y1), x2, lines.get(j+1).getYPos(y2));
      popStyle();
      counter++;
    }
  }
  noLoop();
}
