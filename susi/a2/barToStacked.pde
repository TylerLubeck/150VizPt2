class BarToStacked {
  color[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
   
  BarGraph barG;
  StackedBar stackedG;
  float unit, maxValue, zeroY, longestIndex, progress;
  boolean shrinking;
  int tintValue;
  
  BarToStacked(BarGraph barGraph, StackedBar stackedBar) {
    this.barG = barGraph;
    this.stackedG = stackedBar;
    zeroY = height*0.85;
    bsSetup();
  }
  
  void bsSetup() {
   progress = 0;
   shrinking = true; 
   tintValue = 255;
  }
  
  void draw() {
   if(shrinking) {
    shrink();
    if(!shrinking)
      progress = 0;
   }
   else if (progress < 1) {
     fadeIn();
     if(progress >= 1) {
        inTransition = false;
        bar = false;
        stacked = true;
        toStacked = false;
        bsSetup();
   }
  } 
 }
  
  void shrink() {
    shrinking = false;
    progress += 0.005;    
    float upperX, upperY, heightB;
    int maxRange = (ceil(stackedG.maxValue) % stackedG.graph.intervalX == 0 ? 
        ceil(stackedG.maxValue) : (ceil(stackedG.maxValue) + (ceil(stackedG.maxValue) % stackedG.graph.intervalX)));
    float tempMax = lerp(barG.getMaxYValue(), maxRange, progress);
    tempMax = tempMax > stackedG.maxValue ? stackedG.maxValue : tempMax;
    float xInterval = width * 0.8 / (float(labels.size()) + 1.0);
    float tickX = width * 0.1 + xInterval;

    float widthB = barG.getWidth();
    float interval = tempMax / 10.0;
    float tempUnit = (height*.75 / tempMax) / 1.1;
    barG.drawAxis();
    barG.drawXTicks();
    barG.drawXLabels();
    for (int i = 0; i < labels.size(); ++i) {
      fill(lerpColor(color(255,255,179), colors[1], progress));
      upperX = tickX-(xInterval*0.9)/2;
      upperY = zeroY-tempUnit*barG.yData.get(i);
      heightB = tempUnit*barG.yData.get(i);
      rect(upperX, upperY, widthB, heightB);
      tickX+= xInterval;
    }
    textAlign(CENTER, CENTER);
    float halfTick = width * 0.01;
    for (int i = 0; i*interval *tempUnit < height * 0.74; i++) {
      line(width*0.1- halfTick, barG.zeroY-tempUnit*i*interval, width*0.1+halfTick, barG.zeroY-tempUnit*i*interval);
      fill(0,0,0, tintValue);
      textSize(12);
      text(i*interval, width*0.05, zeroY-tempUnit*i*interval);
    }
    if (progress < 1)
      shrinking = true;
  }

  
  void fadeIn() {
   progress += 0.005;
   int tintVal = int(lerp(0, 255, progress));
   stackedG.setTint(tintVal);
   stackedG.draw(tintVal);
 
  }

  
}
  

