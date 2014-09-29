final String FILE_NAME = "Dataset2.csv";
String[] columnNames;
LinkedHashMap<String, HashMap<String, Float>> labelToAttrib;
HashMap<String, Float> totalSums;
String XAxis;
BarGraph bar;
XYAxis axis;
pieChart pie;

void setup() {
    size(400, 400);
    Parser p = new Parser(FILE_NAME, /*debug*/ true);
    columnNames = p.getColumnNames();
    labelToAttrib = p.getLabelToAttribMap();
    totalSums = p.getTotalSums();
    XAxis = p.getXTitle();

    /* Create a Bar Chart */
    /*
    axis = new XYAxis();
    axis.setXLabel(XAxis);
    axis.setYLabel(columnNames[1]);
    axis.setXNumTicks(10);
    axis.setYNumTicks(200);
    bar = new BarGraph(axis);
    for (int i = 1; i < 2; i++) {
        for(Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet()) {
            bar.addBar(e.getKey(), int(e.getValue().get(columnNames[i])));
        }
    }
    */

    /* Create a Pie Chart */
    pie = new pieChart(300.0); 
    for (int i = 1; i < 2; i++) {
        for(Entry<String, HashMap<String, Float>> e : labelToAttrib.entrySet()) {
            pie.addAngle(e.getValue().get(columnNames[i]) / totalSums.get(columnNames[i]));
        }
    }
}

void draw() {
    // bar.render(); 
    pie.render();
}
