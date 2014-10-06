class LineGraph{
    //XYAxis axis;
    ArrayList<Point> points;
    ArrayList<Point> backupPoints;
    float w, h;
    float leftSpacing;
    float rightSpacing;
    float paddedHeight;
    float min, max; 
    ArrayList<Boolean> isAnimating;
    float xDelta, yDelta;
    boolean firstRender = true;

    LineGraph(float w, float h) {
        this.xDelta = 12.5;
        this.yDelta = 12.5;
        this.w = w;
        this.h = h - 100;
        this.leftSpacing = 40;
        this.rightSpacing = width/4;
        this.paddedHeight = height - 100;
        this.points = new ArrayList<Point>(); 
        this.backupPoints = new ArrayList<Point>(); 
        this.isAnimating = new ArrayList<Boolean>();
    } 

    void setAxis( XYAxis a) {
        axis = a;
    }

    void addPoint( String lbl, int val){
        Point p = new Point(lbl,val);
        Point p2 = new Point(lbl, val);
        points.add(p);
        this.backupPoints.add(p2);
        this.isAnimating.add(false);
    }

    void setGeometry() { 
        float numPoints = points.size(); 
        float totalSpacing = numPoints - 1;
        float xInterval = (width - this.leftSpacing - width/4) / numPoints; 
        float yInterval = 2.0; 
        if (this.firstRender) {
            println("FIRST RENDER");
            for (int i = 0; i < numPoints; i++) {
                points.get(i).setCoord(xInterval + (i * xInterval), 
                                       points.get(i).value * yInterval); 
                backupPoints.get(i).setCoord(xInterval + (i * xInterval), 
                                       points.get(i).value * yInterval); 
            }
            this.firstRender = false;
        }
    }

    void connectTheDots(float stepVal) {
        for (int i = 0; i < this.points.size() - 1; i++) {
            fill(color(0));
            strokeWeight(2);
            float newX = lerp(this.backupPoints.get(i).getPosX(),
                              this.backupPoints.get(i+1).getPosX(),
                              stepVal);
            float newY = lerp(this.backupPoints.get(i).getPosY(),
                              this.backupPoints.get(i+1).getPosY(),
                              stepVal);
            line(this.backupPoints.get(i).getPosX(),
                 this.backupPoints.get(i).getPosY(),
                 newX,
                 newY);
        }
    }

    void connectTheDots(){
        for(int i = 0; i < this.points.size() - 1; i++) {                     
            fill(color(0));
            strokeWeight(2); 
            line(this.points.get(i).getPosX(), 
                    this.points.get(i).getPosY(), 
                    this.backupPoints.get(i+1).getPosX(), 
                    this.backupPoints.get(i+1).getPosY());
        }
    }

    /* bit of a cop out, but should look better with some coloring tweaks */ 
    void disconnectTheDots(float stepVal) {
       for (int i = 0; i < this.points.size() - 1; i++) {
            fill(color(255));
            stroke(color(255)); 
            strokeWeight(2);
            float newX = lerp(this.backupPoints.get(i).getPosX(),
                              this.backupPoints.get(i+1).getPosX(),
                              stepVal);
            float newY = lerp(this.backupPoints.get(i).getPosY(),
                              this.backupPoints.get(i+1).getPosY(),
                              stepVal);
            line(this.backupPoints.get(i).getPosX(),
                 this.backupPoints.get(i).getPosY(),
                 newX,
                 newY);
        }
    }
    boolean isSafeToAnimate() {
        for (boolean b: this.isAnimating) if (b) return false;
        return true;
    }

    void startAnimating() {
        for (int i = 0; i < this.isAnimating.size(); i++) {
            this.isAnimating.set(i, true);
        }
    }

    /* old disconnect the dots */ 
    void disconnectTheDotsTest(float stepVal) {
        stroke(color(255, 0, 0));
        fill(color(255, 0, 0));
        strokeWeight(2); 
        for (int i = 0; i < this.points.size() - 1; i++) {
            Point thisPoint = this.points.get(i);
            Point thisPointBack = this.backupPoints.get(i);
            Point thatPoint = this.backupPoints.get(i+1);
            float newX = lerp(thisPointBack.getPosX(), thatPoint.getPosX(), stepVal);
            float newY = lerp(thisPointBack.getPosY(), thatPoint.getPosY(), stepVal); 
            this.points.get(i).change(newX, newY);
            thisPoint.print();
            thatPoint.print();
            line(newX, 
                 newY-5, 
                 thatPoint.getPosX(), 
                 thatPoint.getPosY()-5);
        }
    }

    void moveTheSpots(float stepVal, pieChart pie) {

    }

    void reset() {
        this.points.clear();
        for (Point p: this.backupPoints) {
            this.points.add(new Point(p));
        }
        this.startAnimating();
        this.firstRender = true;
    }

    void render(){
        setGeometry(); 
        for (Point p : points) {
            p.render();
        }
        connectTheDots(); 
    }
    
    void drawPoints() {
      setGeometry();
      for (Point p: points) {
          p.render();
      }
    }
}
