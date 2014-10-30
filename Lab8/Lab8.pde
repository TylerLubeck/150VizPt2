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
        println(maxVal, minVal);
        VerticalLine newLine = new VerticalLine(minVal, maxVal,
                                                headers[i]);
        println(newLine.getYPos(1.2));
        lines.add(newLine);
    }
}

void setup() {
    size(600,600);
    readData();
}

