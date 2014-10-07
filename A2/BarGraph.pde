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
  boolean barsHidden;

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
    barsHidden = false;
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
    setGeometry();
  }

  void setGeometry() {
    //calculate appropriate width/height and spacing for each bar
    int numBars = bars.size();
    float barSpacing = 5.0;
    float totalSpacing = (numBars + 1) * barSpacing;
    float availableWidth = this.w - totalSpacing - this.leftSpacing - this.rightSpacing;
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
    if (!barsHidden) {
      for (Bar b : bars) {
        b.render();
      }
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

  void AnimateToPie(pieChart pie) {

    //Step 1: shrink bars to their pointX, pointY
    //Their heights will be proporionate to each other in terms of "masterBarHeight"
    shrink();

    if (barsAreDoneAnimating()) {
      //setBarsAreAnimatingToFalse();
      //Step 2: Move all the bars to one stacked column in middle of screen
      stackBars(); //SO LONG MY FRIEND
      //barsToWedges(pie);
    }
    if (barsAreDoneAnimating()) {
      moveUp();
    }
  }

  void barsToWedges(pieChart pie) {
    barsHidden = true;
    for (int i=0; i<bars.size (); i++) {
      Bar bar = bars.get(i);
      //make a wedge
      beginShape();
      vertex(bar.xCoord, bar.yCoord + bar.bHeight);
      vertex(bar.xCoord + bar.bWidth, bar.yCoord + bar.bHeight);
      vertex(bar.pointX, bar.pointY);
      endShape();
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

  void stackBars() {
    //find middle bar
    int iMiddle = bars.size()/2;
    //move to middle
    moveToMiddle(iMiddle);
    int yCoord = (int)bars.get(0).yCoord - 10;
    //iterate outward in both directions and move to middle
    int iRight = iMiddle + 1;
    int iLeft = iMiddle - 1;
    int iCur = iRight;
    for (int i=0; i< bars.size () - 1; i++) {
      //only increment when current is done
      if (!barIsAnimating[iCur]) {
        if ( i%2 == 0 ) {
          iCur = iLeft;
          iLeft--;
        } else {
          iCur = iRight;
          iRight++;
        }
        moveToMiddle(iCur);
      }
    }
  }

  void moveUp() {
    int middlePosY = Math.round(this.h / 2) - Math.round(bars.get(0).bHeight / 2);
    float pxMove = 5;
    for (int i=0; i< bars.size (); i++) {
      int barPosY = (int)bars.get(i).yCoord;
      if (barPosY > middlePosY) {
        bars.get(i).yCoord -= pxMove;
        this.barIsAnimating[i]=true;
      } else {
        this.barIsAnimating[i]=false;
      }
    }
  }

  //move bar.get(i) to middle and move it to appropriate height
  void moveToMiddle(int i) {
    //casting everything to ints to avoid infinite loop of trying to become center
    //i.e. bar's xPos is 10.7px and middleX is 10px

    println("width is" + this.w);
    int middlePosX = Math.round(this.w / 2) - Math.round(bars.get(0).bWidth / 2);
    println("middle pos is" + middlePosX);
    float pxMove = 5;
    int barPosX = (int)bars.get(i).xCoord;
    int barPosY = (int)bars.get(i).yCoord;
    int y = (int)(this.paddedHeight) - 200;
    if (barPosX < middlePosX) {
      bars.get(i).xCoord += pxMove;
      this.barIsAnimating[i]=true;
    } else if (barPosX > middlePosX) {//if right of middleX, move left
      bars.get(i).xCoord -= pxMove;
      this.barIsAnimating[i]=true;
    } else {
      this.barIsAnimating[i]=false;
    }
  }
  
  
}

