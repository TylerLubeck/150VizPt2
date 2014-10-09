class BarToPie implements  Cloneable {
  BarGraph barGraph;
  PieGraph pieGraph;
  color[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
  boolean bpShrinkChange, bpSqChange, bpMoved;
  float centerX, centerY, radius, bpExplRad, bpSpreadRad, bpSqRad, bpSpreadIncrement, progress, fadeProg;
  ArrayList<Float> angles, bpRadii, bpThetas, bpX, bpX1, bpX2, bpY, bpY1, bpY2, bpW1, bpW2, bpBarArea; 
  
  BarToPie(PieGraph pie, BarGraph bar) {
    this.pieGraph = pie;
    this.barGraph = bar;
    bpSetup();
  }
  
  void bpSetup() {
    this.angles = (ArrayList<Float>)pieGraph.angles.clone();
    bpExplRad = progress = fadeProg = 0;
    bpShrinkChange = bpSqChange = true;
    bpMoved = false;
    getXYW(barGraph.getWidth());
  }
  
  void bpTransform(float centerX, float centerY, float radius, float barWidth) {
    getXYW(barGraph.getWidth());
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    if (fadeProg < 1) {
      fadeBarOut(barWidth); 
      if (fadeProg >= 1)
        bpSqStartCond(barWidth);
    }
    else if (bpSqChange) {
      moveRect(barWidth);
      if (! bpSqChange)
        progress = 0;
    }
    else if (bpShrinkChange) {
      shrink(barWidth);
      if (! bpShrinkChange) {
        progress = 0;
      }
    }
    else if (bpSpreadRad > radius/2){
      consolidate();
      if (bpSpreadRad > radius/2) {
        progress = 0;
      }
    }
    
    else if (bpExplRad  > 0) {
      implode();
      if (bpExplRad < 0.00000001) {
        inTransition = false;
        bar = false;
        pie = true;    
        toPie = false;  
        bpSetup();
        barGraph.setTint(255);
      }
    }
  }
    
    
  void getXYW(float barWidth) {
    float xInterval = width*0.8 / (float(angles.size()) + 1.0);
    float tickX = width*0.1 + xInterval;
    float unit = barGraph.getUnit();
    float zeroY = height*0.85 + barGraph.lowRange*unit;
    bpX = new ArrayList<Float>();
    bpY = new ArrayList<Float>();
    bpBarArea = new ArrayList<Float>();
    for (int i = 0; i < angles.size(); ++i) {
      bpX.add(tickX);
      bpY.add(zeroY-unit*barGraph.yData.get(i));
      bpBarArea.add(barGraph.getUnit() * barWidth * barGraph.yData.get(i));
      tickX+= xInterval;
   }
  }
  
  void fadeBarOut(float barWidth) {
    fadeProg += 0.1;
    barGraph.setTint(int(lerp(255, 0, fadeProg)));
    fill(0, int(lerp(255, 0, fadeProg)));
    barGraph.drawAxis();
    barGraph.drawYTicks();
    barGraph.drawXTicks();
    barGraph.drawXLabels();
    for (int i = 0; i < angles.size(); ++i) {
      fill(255,255,179);
      rect(bpX.get(i) - barWidth/2, bpY.get(i), barWidth, bpBarArea.get(i) / barWidth);
    }
  }
  
  void bpSqStartCond(float barWidth) {
    bpRadii = new ArrayList<Float>();
    bpThetas = new ArrayList<Float>();
    bpX1 = new ArrayList<Float>();
    bpY1 = new ArrayList<Float>();
    bpX2 = new ArrayList<Float>();
    bpY2 = new ArrayList<Float>();
    bpW1 = new ArrayList<Float>();
    bpW2 = new ArrayList<Float>();
    float currentAngle = 270;
    bpSpreadIncrement = (radius * 1.2 - radius/2)/ (log((100 * radius)/ (radius/2)) / log(1.03));
    bpSpreadRad = bpExplRad = radius/2;
    
    while (bpSpreadRad <= 100 * radius) {
      bpSpreadRad *= 1.03;
      bpExplRad += bpSpreadIncrement;
    }
    
    float transX, transY, tempAngle, finalAngle;
    for (int i = 0; i < angles.size(); ++i) {
      finalAngle = (angles.get(i) > degrees(2*barWidth * barWidth / bpBarArea.get(i)) ? 
              degrees(2*barWidth * barWidth / bpBarArea.get(i)) : angles.get(i));
      bpRadii.add(sqrt(2 * bpBarArea.get(i)/radians(finalAngle)));
      bpThetas.add(finalAngle);
      tempAngle = PI/2 + bpExplRad / bpSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
      transX = centerX + bpSpreadRad * cos(tempAngle);
      transY = centerY + bpSpreadRad * sin(tempAngle) - (bpSpreadRad - bpExplRad);
      bpX1.add(transX);
      bpY1.add(transY + (radius - bpRadii.get(i)));
      bpW1.add(0.0);
      bpX2.add(bpX1.get(i) + bpRadii.get(i) * cos(HALF_PI + radians(bpThetas.get(i)/2)));
      bpY2.add(bpY1.get(i) + bpRadii.get(i) * sin(HALF_PI + radians(bpThetas.get(i)/2)));
      bpW2.add(radians(bpThetas.get(i)) * bpRadii.get(i));
      currentAngle -= angles.get(i);
    }  
    bpThetas = (ArrayList<Float>)angles.clone();
  }
  
  
  void moveRect(float barWidth) {
  bpSqChange = false;
  int colorIndex = 0;
  float x1, x2, y1, y2, w1, w2;
  for (int i =0; i < angles.size(); ++i) {
    progress += 0.0005;
    color c = lerpColor(color(255,255,179), colors[colorIndex], progress);
    fill(c);
    x1 = lerp(bpX.get(i), bpX1.get(i), progress);
    w1 = lerp(barWidth, bpW1.get(i), progress);
    x2 = lerp(bpX.get(i) - barWidth/2, bpX2.get(i), progress);
    w2 = lerp(barWidth, bpW2.get(i), progress);
    y1 = lerp(bpY.get(i), bpY1.get(i), progress);
    y2 = lerp((bpY.get(i) + bpBarArea.get(i) / barWidth), bpY2.get(i), progress);
    
    quad(x1-w1 /2, y1, x1 + w1 /2, y1, x2 + w2, y2, x2,y2);   
    colorIndex = (colorIndex + 1) % colors.length;
    if (progress < 1)
      bpSqChange = true;
   }
 }
 
 void shrink(float barWidth) {
    bpShrinkChange = false;
    int colorIndex = 0;
    float finalAngle;
    for (int i =0; i < angles.size(); ++i) {
      progress += 0.0005;
      finalAngle = (angles.get(i) > degrees(2*barWidth * barWidth / bpBarArea.get(i)) ? 
              degrees(2*barWidth * barWidth / bpBarArea.get(i)) : angles.get(i));
      fill(colors[colorIndex]);
      bpY1.set(i, (bpY1.get(i) + (bpRadii.get(i) - lerp(sqrt(2 * bpBarArea.get(i)/radians(finalAngle)), radius, progress))));
      bpRadii.set(i, lerp(sqrt(2 * bpBarArea.get(i)/radians(finalAngle)), radius, progress));
        bpThetas.set(i, lerp(finalAngle, angles.get(i), progress));
        if (progress < 1)
          bpShrinkChange = true;
      arc(bpX1.get(i), bpY1.get(i), 2*bpRadii.get(i), 2*bpRadii.get(i), (HALF_PI - radians(bpThetas.get(i)/2)), (HALF_PI + radians(bpThetas.get(i)/2)),  PIE);
      colorIndex = (colorIndex + 1) % colors.length;
    } 
  }
 
 void consolidate() {
    float currentAngle = 270;
    int colorIndex = 0;
    float transX, transY, tempAngle;
    for (int i =0; i < angles.size(); ++i) {
      fill(colors[colorIndex]);
      tempAngle = PI/2 + bpExplRad / bpSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
      transX = centerX + bpSpreadRad * cos(tempAngle);
      transY = centerY + bpSpreadRad * sin(tempAngle) - (bpSpreadRad - bpExplRad);
      arc(transX, transY, 2*radius, 2*radius, (tempAngle - radians(angles.get(i)/2)), (tempAngle + radians(angles.get(i)/2)),  PIE);
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    } 
    if (bpSpreadRad >radius/2){
        bpSpreadRad /= 1.03;
        bpExplRad -= bpSpreadIncrement;
    }
  }
  
  
  void implode() {
    float currentAngle = 270;
    int colorIndex = 0;
    float transX, transY;
    for (int i =0; i < angles.size(); ++i) {
      progress += 0.001;
      bpExplRad = lerp(radius/2, 0, progress);
      fill(colors[colorIndex]);
      transX = centerX + bpExplRad * cos(radians(currentAngle - angles.get(i)/2));
      transY = centerY + bpExplRad * sin(radians(currentAngle - angles.get(i)/2));
      arc(transX, transY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
      currentAngle -= angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    }
  }    
}

