class pieChart {
  private ArrayList<Float> angles; 
  private ArrayList<Float> backupAngles;
  private float diameter; 
  private float lastAngle; 
  private int index; 
  private int rightSpacing;
  private float widthDivider;
  ArrayList<Point> pointsToMove;
  private float endX, endY;
  private float startX, startY;
 
  pieChart(float diameter) {
    this.angles = new ArrayList<Float>(); 
    this.backupAngles = new ArrayList<Float>(); 
    this.pointsToMove = new ArrayList<Point>(); 
    this.diameter = diameter; 
    this.lastAngle = 0; 
    this.index = 0; 
    this.rightSpacing = width/4; 
    this.widthDivider = 1.0;
    this.endX = 0.0;
    this.endY = 0.0;
  }
  
  void addAngle(float ratio) {
     float w = width - this.rightSpacing; 
     this.angles.add(ratio * 360); 
     this.backupAngles.add(ratio * 360); 
     this.pointsToMove.add(new Point());
     this.startY = height/2; // w/2 + diameter/1.0 * cos(this.angles.get(0));
     this.startX = w/2 + this.rightSpacing; // height/2 + diameter/4.0 * sin(this.angles.get(0));
  }
  
  void render() {
      float lastAngle = 0; 
      stroke(color(0));
      strokeWeight(2); 
      fill(255); 
      float w = width - this.rightSpacing; 
      for (int i = 0; i < this.angles.size(); i++) {
        float nextAngle = lastAngle + radians(this.angles.get(i));
        arc(w/2, 
             height/2, 
             diameter * this.widthDivider, 
             diameter * this.widthDivider, 
             lastAngle, 
             nextAngle);
        line(w/2,
             height/2,
             w/2 + diameter/2.0 * cos(nextAngle),
             height/2 + diameter/2.0 * sin(nextAngle) );
        lastAngle += radians(this.angles.get(i));
      }
      
      strokeWeight(0); 
  }

  void shrink(float stepVal) {
        this.widthDivider *= stepVal;
        float inverseStep = 1.0 - stepVal;
        for(int i = 0; i < this.angles.size(); i++) {
            this.angles.set(i, this.angles.get(i) * inverseStep);
        }
        float w = width - this.rightSpacing;
        for (int i = 0; i < this.pointsToMove.size(); i++) {
            pointsToMove.get(i).setCoord(w/2 + diameter/2.0 * cos(0),
                                         height/2 + diameter/2.0 * sin(0)
                                        );
        }
        this.endX = w/2 + diameter/4.0;
        this.endY = height/2;
  }

  void grow(float stepVal) {
       // this.widthDivider *= stepVal;
        for(int i = 0; i < this.angles.size(); i++) {
            this.angles.set(i, this.backupAngles.get(i) * stepVal);
        }
        float w = width - this.rightSpacing;
        for (int i = 0; i < this.pointsToMove.size(); i++) {
            pointsToMove.get(i).setCoord(w/2 + diameter/2.0 * cos(0),
                                         height/2 + diameter/2.0 * sin(0));
        }
  }

  void makeLine(float stepVal, LineGraph lineGraph) {
    for(int i = 0; i < pointsToMove.size(); i++) {
        /*
        float newX = lerp(lineGraph.points.get(i).getPosX(),
                          this.startX,
                          stepVal);
        float newY = lerp(lineGraph.points.get(i).getPosY(), 
                          this.startY, 
                          stepVal);
        // */
        float newX = lerp(this.startX,
                          lineGraph.points.get(i).getPosX(),
                          stepVal);
        float newY = lerp(this.startY, 
                          lineGraph.points.get(i).getPosY(), 
                          stepVal);

        //pointsToMove.get(i).setCoord(width - newX, height - newY).render();
        pointsToMove.get(i).setCoord(newX, newY).render();
    }
  }
  
  void drawNextWedge() {
    stroke(color(0));
    float gray = map(this.index, 0, this.angles.size(), 100, 255); 
    fill(gray);

    arc(width/2, 
        height/2, 
        diameter, 
        diameter, 
        this.lastAngle, 
        this.lastAngle + radians(this.angles.get(this.index))
        );

    this.lastAngle += radians(this.angles.get(this.index));
    this.index++;   
  }
  
  void reset() {
    this.angles.clear();
    this.widthDivider = 1.0;
    for (float angle : this.backupAngles) {
      this.angles.add(angle);
    }
  }

}
