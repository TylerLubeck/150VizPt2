class Bar {
  float value;
  float xCoord, yCoord, pointX, pointY;
  float bWidth, bHeight;
  String label;
  color fill, stroke;
  
  Bar() {
    value = 0;
    label = "";
  }
  Bar( String l, float val, color f, color s) {
    value = val;
    label = "(" + l + "," + value + ")";
    fill = f;
    stroke = s;
  }

  void SetGeometry( float xC, float yC, float w, float h) {
    pointX = xC + w/2;
    pointY = yC;
    xCoord = xC;
    yCoord = yC;
    bWidth = w;
    bHeight = h;
  }

  void render() {
    stroke(stroke);
    fill(fill);
    rect( xCoord, yCoord, bWidth, bHeight );
  }

  void intersect(int posx, int posy) {
    if ( posx >= xCoord && posx <= bWidth + xCoord &&
      posy >= yCoord && posy <= (yCoord+ bHeight)) {
      fill(color(255, 0, 0));
      text( label, xCoord - bWidth - 10, yCoord - 2);
      fill(color(0));
    }
  }
}


class BarGraph {
  ArrayList<Bar> bars;
  float sumBarValues;
  color fill, stroke;
  float w, h;
  float leftSpacing;
  float rightSpacing;
  float paddedHeight;
  float pad;
  boolean[] barIsAnimating;
  float barWidth; 

  BarGraph(float w, float h) {
    bars = new ArrayList<Bar>();
    fill = color(155, 161, 163);
    stroke = color(216, 224, 227);
    this.w = w;
    this.h = h;
    //Need to make spacing dynamic
    this.leftSpacing = 20;
    this.rightSpacing = 20; 
    this.paddedHeight = height - 100;
    this.sumBarValues = 0;
  }

  void addBar( String lbl, float val) {
    Bar b = new Bar( lbl, val, this.fill, this.stroke);
    bars.add(b);
  }

  void doneAddingBars() {
    this.setGeometry();
    for (Bar b : bars) {
      this.sumBarValues += b.value;
    }
    //println("sum of bar values is", this.sumBarValues);
    float masterBarHeight = 3* (paddedHeight / 4);

    //create array
    barIsAnimating = new boolean[this.bars.size()];
    setBarsAreAnimatingToFalse();
  }

  void setGeometry() {
    //calculate appropriate width/height and spacing for each bar
    int numBars = bars.size();
    float barSpacing = 5.0;
    float totalSpacing = (numBars + 1) * barSpacing;
    float availableWidth = (width - width/4) - totalSpacing - this.leftSpacing - this.rightSpacing;
    this.barWidth = availableWidth / numBars;
    float yFactor = 2.0;

    //set up starting coords
    float startPosX = this.leftSpacing + barSpacing;

    for (int i=0; i< bars.size (); i++) {
      float barHeight = bars.get(i).value * yFactor;
      bars.get(i).SetGeometry(startPosX, 
      paddedHeight - barHeight, 
      this.barWidth, 
      barHeight);
      startPosX+=this.barWidth + barSpacing;
    }
  }

  void render() {
    setGeometry(); 
    for (Bar b : bars) {
      b.render();
    }
  }

  boolean barsAreDoneAnimating() {
    for (boolean b : this.barIsAnimating) {
      if (b) {
        return false;
      }
    }
    return true;
  }

  void setBarsAreAnimatingToFalse() {
    for (int i=0; i<this.barIsAnimating.length; i++) {
      this.barIsAnimating[i] = false;
    }
  }

  void AnimateToPie() {

    //Step 1: shrink bars to their pointX, pointY
    //Their heights will be proporionate to each other in terms of "masterBarHeight"
    shrink();

    if (barsAreDoneAnimating()) {
      setBarsAreAnimatingToFalse();
      //Step 2: Move all the bars to one stacked column in middle of screen
      moveToMiddle();
    }
    if(barsAreDoneAnimating()){
      setBarsAreAnimatingToFalse();
      
    }
  }

  void shrink() {
    float pxShrink = 2;
    float masterBarHeight = 3* (paddedHeight / 4);
    for (int i=0; i<bars.size (); i++) {
      float finalBarHeight = ( bars.get(i).value / this.sumBarValues ) * masterBarHeight;
      if ((paddedHeight - bars.get(i).yCoord) > finalBarHeight) {
        bars.get(i).yCoord += pxShrink;
        bars.get(i).bHeight -= pxShrink;
        this.barIsAnimating[i] = true;
      } else {
        this.barIsAnimating[i] = false;
      }
    }
  }

  void moveToMiddle() {
    
    //casting everything to ints to avoid infinite loop of trying to become center
    //i.e. bar's xPos is 10.7px and middleX is 10px
    
    int middlePosX = width / 2 - (int)(bars.get(0).bWidth / 2);
    float pxMove = 1;
    for (int i=0; i<bars.size (); i++) {
      int barPosX = (int)bars.get(i).xCoord;
      //if left of middleX, move right
      if (barPosX < middlePosX) {
        bars.get(i).xCoord += pxMove;
        this.barIsAnimating[i]=true;
      } else if (barPosX > middlePosX) {//if right of middleX, move left
        bars.get(i).xCoord -= pxMove;
        this.barIsAnimating[i]=true;
      } else{
        this.barIsAnimating[i]=false;
      }
    }
  }
  
  
  
}

