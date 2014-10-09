
ArrayList<String> xData;
ArrayList<Integer> yData;

void step2() {
  //triangle(0.1*width, 0.1*height, 0.5*width, 0.2*height, 0.8*width, 0.4*height);
  xData = new ArrayList<String>();
  yData = new ArrayList<Integer>();
  xData.add("First"); xData.add("Second"); xData.add("Third");
  yData.add(2); yData.add(4); yData.add(7);
  BarGraph bgraph = new BarGraph(xData, yData);
  bgraph.draw(0);
  console.log(adults[0]);
  //console.log(loadStrings("adult.data"));
}

