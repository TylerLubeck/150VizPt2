class LineGraph{
    //XYAxis axis;
    ArrayList<Point> points;
    ArrayList<Point> currentPoints;
    float w, h;
    float leftSpacing;
    float rightSpacing;
    float paddedHeight;
    float min, max; 
    ArrayList<Boolean> isAnimating;
    float xDelta, yDelta;

    LineGraph(float w, float h) {
        this.xDelta = 0.5;
        this.yDelta = 0.5;
        this.w = w;
        this.h = h - 100;
        this.leftSpacing = 40;
        this.rightSpacing = width/4;
        this.paddedHeight = height - 100;
        this.points = new ArrayList<Point>(); 
        this.currentPoints = new ArrayList<Point>(); 
        this.isAnimating = new ArrayList<Boolean>();
    } 

    void setAxis( XYAxis a) {
        axis = a;
    }

    void addPoint( String lbl, int val){
        Point p = new Point(lbl,val);
        points.add(p);
        this.currentPoints.add(p);
        this.isAnimating.add(false);
    }

    void setGeometry() { 
        float numPoints = points.size(); 
        float totalSpacing = numPoints - 1;
        float xInterval = (width - this.leftSpacing - width/4) / numPoints; 
        float yInterval = 2.0; 
        for (int i = 0; i < numPoints; i++) {
            points.get(i).setCoord(xInterval + (i * xInterval), points.get(i).value * yInterval); 
        }
    }

    void connectTheDots(){
        for(int i = 0; i < points.size() - 1; i++) {                     
            fill(color(0));
            strokeWeight(2); 
            line(points.get(i).getPosX(), 
                    points.get(i).getPosY(), 
                    points.get(i+1).getPosX(), 
                    points.get(i+1).getPosY());
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

    boolean disconnectTheDots() {
        fill(color(0));
        strokeWeight(2); 
        for (int i = 0; i < this.isAnimating.size() - 1; i++) {
            if (this.isAnimating.get(i)) {
                Point thisPoint = this.points.get(i);
                Point thatPoint = this.points.get(i+1);
                float xMod = this.xDelta, yMod;
                float thisX = thisPoint.getPosX(), thisY = thisPoint.getPosY();
                float thatX = thatPoint.getPosX(), thatY = thatPoint.getPosY();
                yMod = (thisY < thatY) ? -this.yDelta : this.yDelta;
                thisPoint.change(xMod, yMod);
                if (thisX > thatX) {
                    this.isAnimating.set(i, false);
                }
            }
        }

        //Return if we're done or not
        for(int i = 0; i < this.isAnimating.size() - 1; i++) {
            //Return false if any point is still animating
            if (this.isAnimating.get(i)) return false;
        }
        //If all points are false, then everything is done animating
        //TODO: Set the points back to original?
        return true;
    }

    void render(){
        setGeometry(); 
        for (Point p : points) {
            p.render();
        }
        connectTheDots(); 
    }
}
