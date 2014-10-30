Table table;
String[] headers;
ArrayList<VerticalLine> lines;

void readData() {
    table = loadTable("iris.csv", "header");    
    headers = table.getColumnTitles();
    lines = new ArrayList<VerticalLine>();
    float startingX = width * .1;

    int numColumns = table.getColumnCount();
    for(int i = 0; i < numColumns; i++) {
        float[] vals = table.getFloatColumn(i);
        float maxVal = max(vals);
        float minVal = min(vals);
        println(maxVal, minVal);
        VerticalLine newLine = new VerticalLine(minVal, maxVal,
                                                headers[i]);
        println(newLine.getYPos(1.2));
        println(newLine);
        lines.add(newLine);
    }
    float xInterval = width / lines.size();

    for(VerticalLine l : lines) {
        l.setX(startingX);
        startingX += xInterval;
    }
}

void setup() {
    size(600,600);
    readData();
}


void draw() {
    background(255);
  float x1, y1, x2, y2;
  for (int i = 0; i < table.getRowCount(); ++i) {
    for (int j = 0; j < lines.size() -1; ++j) {
      x1 = lines.get(j).x;
      y1 = table.getFloatColumn(lines.get(j).title)[i];
      x2 = lines.get(j+1).x;
      y2 = table.getFloatColumn(lines.get(j+1).title)[i];
      line(x1, lines.get(j).getYPos(y1), x2, lines.get(j+1).getYPos(y2));
    }
  }
}
