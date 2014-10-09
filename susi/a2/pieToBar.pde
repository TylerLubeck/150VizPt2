class PieToBar implements  Cloneable {
  BarGraph barGraph;
  PieGraph pieGraph;
  color[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
  boolean pbGrowChange, pbSqChange, pbMoved;
  float centerX, centerY, radius, barWidth, pbExplRad, pbSpreadRad, pbSqRad, pbSpreadIncrement, progress, fadeProg;
  ArrayList<Float> angles, pbRadii, pbThetas, pbX, pbX1, pbX2, pbY, pbY1, pbY2, pbW1, pbW2, pbBarArea;
   
  PieToBar(PieGraph pie, BarGraph bar) {
    this.pieGraph = pie;
    this.barGraph = bar;
    pbSetup();
  }
  
  void pbSetup(){
    this.angles = (ArrayList<Float>)pieGraph.angles.clone();
    pbExplRad = progress = fadeProg = 0;
    pbGrowChange = pbSqChange = true;
    pbMoved = false;
  }
  
  void pbTransform(float centerX, float centerY, float radius, float barWidth) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    this.barWidth = barWidth;
    
    if (pbExplRad  < radius /2) {
      explode();
      if (pbExplRad >= radius/2) {
        pbSpreadRad = pbExplRad;
        pbSpreadIncrement = (radius * 1.2 - pbExplRad)/ (log((100 * radius)/ pbExplRad) / log(1.03));
        progress = 0;
      }
    }
    else if (pbSpreadRad <= 100 *radius){
      spread();
      if (pbSpreadRad > 100*radius) {
        pbSqRad = pbSpreadRad;
        pbSqStartCond();
        progress = 0;
      }
    }
    else if (pbGrowChange) {
      grow();
      if (! pbGrowChange) {
        getXYW();
        progress = 0;
      }
    }
    else if (pbSqChange) {
      moveRect();
    }
    else if (fadeProg < 1) {
      fadeBarIn(); 
      if (fadeProg >= 1)  {
        inTransition = false;
        pie = false;
        bar = true;
        toBar = false;
        pbSetup();
      }   
    }
  }
    
  void explode() {
    float currentAngle = 270;
    int colorIndex = 0;
    float transX, transY;
    for (int i =0; i < angles.size(); ++i) {
      progress += 0.001;
      pbExplRad = lerp(0, radius/2, progress);
      fill(colors[colorIndex]);
      transX = centerX + pbExplRad * cos(radians(currentAngle - angles.get(i)/2));
      transY = centerY + pbExplRad * sin(radians(currentAngle - angles.get(i)/2));
      arc(transX, transY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    }
  }  
  
  void spread() {
    float currentAngle = 270;
    int colorIndex = 0;
    float transX, transY, tempAngle;
    for (int i =0; i < angles.size(); ++i) {
      fill(colors[colorIndex]);
      tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
      transX = centerX + pbSpreadRad * cos(tempAngle);
      transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
      arc(transX, transY, 2*radius, 2*radius, (tempAngle - radians(angles.get(i)/2)), (tempAngle + radians(angles.get(i)/2)),  PIE);
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    } 
    if (pbSpreadRad < 100 *radius){
        pbSpreadRad *= 1.03;
        pbExplRad += pbSpreadIncrement;
    }
  }
  
  void pbSqStartCond() {
    pbRadii = new ArrayList<Float>();
    pbX = new ArrayList<Float>();
    pbY = new ArrayList<Float>();
    pbBarArea = new ArrayList<Float>();
    float currentAngle = 270;
    
    float transX, transY, tempAngle;
    for (int i = 0; i < angles.size(); ++i) {
      pbRadii.add(radius);
      tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
      transX = centerX + pbSpreadRad * cos(tempAngle);
      transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
      pbX.add(transX);
      pbY.add(transY);
      currentAngle -= angles.get(i);
      pbBarArea.add(barGraph.getUnit() * barWidth * barGraph.yData.get(i));
    }  
    pbThetas = (ArrayList<Float>)angles.clone();
  }
  
  void grow() {
    pbGrowChange = false;
    int colorIndex = 0;
    float finalAngle;
    for (int i =0; i < angles.size(); ++i) {
      progress += 0.0005;
      finalAngle = (angles.get(i) > degrees(2*barWidth * barWidth / pbBarArea.get(i)) ? 
              degrees(2*barWidth * barWidth / pbBarArea.get(i)) : angles.get(i));
      fill(colors[colorIndex]);
      pbY.set(i, (pbY.get(i) + (pbRadii.get(i) - lerp(radius, sqrt(2 * pbBarArea.get(i)/radians(finalAngle)), progress))));
      pbRadii.set(i, lerp(radius, sqrt(2 * pbBarArea.get(i)/radians(finalAngle)), progress));
        pbThetas.set(i, lerp(angles.get(i), finalAngle , progress));
        if (progress < 1)
          pbGrowChange = true;
      arc(pbX.get(i), pbY.get(i), 2*pbRadii.get(i), 2*pbRadii.get(i), (HALF_PI - radians(pbThetas.get(i)/2)), (HALF_PI + radians(pbThetas.get(i)/2)),  PIE);
      colorIndex = (colorIndex + 1) % colors.length;
    } 
  }
  
  void getXYW() {
    float xInterval = width*0.8 / (float(angles.size()) + 1.0);
    float tickX = width*0.1 + xInterval;
    float unit = barGraph.getUnit();
    float zeroY = height*0.85 + barGraph.lowRange*unit;
    
    pbX1 = new ArrayList<Float>();
    pbY1 = new ArrayList<Float>();
    pbW1 = new ArrayList<Float>();
    pbX2 = new ArrayList<Float>();
    pbY2 = new ArrayList<Float>();
    pbW2 = new ArrayList<Float>();
    for (int i = 0; i < angles.size(); ++i) {
      pbX1.add(pbX.get(i));
      pbY1.add(pbY.get(i));
      pbW1.add(0.0);
      pbX2.add(pbX.get(i) + pbRadii.get(i) * cos(HALF_PI + radians(pbThetas.get(i) / 2)));
      pbY2.add(pbY.get(i) + pbRadii.get(i) * sin(HALF_PI + radians(pbThetas.get(i) / 2)));
      pbW2.add(radians(pbThetas.get(i)) * pbRadii.get(i));
      pbX.set(i, tickX);
      pbY.set(i, zeroY-unit*barGraph.yData.get(i));
      tickX+= xInterval;
   }
  }
  
 void moveRect() {
  pbSqChange = false;
  int colorIndex = 0;
  float x1, x2, y1, y2, w1, w2;
  for (int i =0; i < angles.size(); ++i) {
    progress += 0.0005;
    color c = lerpColor(colors[colorIndex], color(255,255,179), progress);
    fill(c);
    x1 = lerp(pbX1.get(i), pbX.get(i), progress);
    w1 = lerp(pbW1.get(i), barWidth, progress);
    x2 = lerp(pbX2.get(i), pbX.get(i) - barWidth/2, progress);
    w2 = lerp(pbW2.get(i), barWidth, progress);
    y1 = lerp(pbY1.get(i), pbY.get(i), progress);
    y2 = lerp(pbY2.get(i), (pbY.get(i) + pbBarArea.get(i) / barWidth), progress);
    
    quad(x1-w1 /2, y1, x1 + w1 /2, y1, x2 + w2, y2, x2,y2);   
    colorIndex = (colorIndex + 1) % colors.length;
    if (progress < 1)
      pbSqChange = true;
   }
 }
  void fadeBarIn() {
    fadeProg += 0.01;
    barGraph.setTint(int(lerp(0, 255, fadeProg)));
    fill(0, int(lerp(0, 255, fadeProg)));
    barGraph.drawAxis();
    barGraph.drawYTicks();
    barGraph.drawXTicks();
    barGraph.drawXLabels();
    for (int i = 0; i < angles.size(); ++i) {
      fill(255,255,179);
      rect(pbX.get(i) - barWidth/2, pbY.get(i), barWidth, pbBarArea.get(i) / barWidth);
    }
  }
}

