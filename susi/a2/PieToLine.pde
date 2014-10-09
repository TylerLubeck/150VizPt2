
class PieToLine extends Animation {
  
  PieGraph fromGraph;
  LineGraph toGraph;

  PieToLine(PieGraph pGraph, LineGraph lGraph) {
    this.fromGraph = pGraph;
    this.toGraph = lGraph;
    this.progressInterval = 0.005;
  }

  void drawTransition(float x, float y, float w, float h) {
    float centerX = (x + w)/2.0;
    float centerY = (y + h)/2.0;
    float radius = (w < h ? 0.9*(w/2) : 0.9*(h/2)) * 0.73;
    float radiusOrig = radius;
    float currAngle = radians(270.0); //0.75*2*PI;
    float barAngle = 0.0;
    float xInterval = width*0.8 / (float(toGraph.xData.size()) + 1.0);
    pushMatrix();
    translate(centerX,centerY);
    for (int i = 0; i < toGraph.xData.size(); i++) {
      barAngle = radians(fromGraph.angles.get(i) % 360);
      fill(fromGraph.colors[i % fromGraph.colors.length]);
      float centerXA = 50 * progress * cos(currAngle);
      float centerYA = 50 * progress * sin(currAngle);
      if (progress < 0.5) {
        stroke(0);
        //pushMatrix();
        //rotate((progressInterval * i) * PI);
        arc(centerXA, centerYA, radius, radius, currAngle - barAngle, currAngle, PIE);
        //popMatrix();
      } else {
        pushMatrix();
        translate(0-centerX, 0-centerY);
        float prog2 = (progress - 0.5) * 2;
        float newX = lerp(centerXA + centerX, width*0.1 + xInterval*(i+1), prog2);
        toGraph.unit = (height*0.75  /(toGraph.maxRange))/1.1;
        tint(1.0); toGraph.drawAxis(); tint(0.0);
        float lineGraphYValue = toGraph.zeroY - toGraph.unit * toGraph.yData.get(i);
        float newY = lerp(centerYA + centerY, lineGraphYValue, prog2);
        //if (i == 23) println(lineGraphYValue,newY);
        stroke(0);
        radius = radiusOrig * (1.10 - prog2);

        arc(newX, newY, radius, radius, currAngle - barAngle, currAngle, PIE);
        popMatrix();
      }
      currAngle -= barAngle;
    }
    popMatrix();
  }

  void fadeInLineGraph() {
    toGraph.draw(255 - (int)(50 + (1.6 - progress) / 0.6 * 200));
  }

  void draw(float x, float y, float w, float h) {
    //println(this.progress);

    float progressBak = progress;
    if (progress >= 1.0) progress = 1.0;
    //if (progress < 1.0)
    drawTransition(x,y,w,h);
    progress = progressBak;
    if (progress > 0.9) fadeInLineGraph();
    
    if ((progress += progressInterval) >= 1.6) {
      inTransition = false; toLine = false;
      pie = false; line = true; 
      progress = 0.0;
    }
  }

}

