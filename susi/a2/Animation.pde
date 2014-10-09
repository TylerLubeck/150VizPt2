
abstract class Animation extends Drawable {
  float progress; /* Fraction on [0,1], representing the progress of the animation */
  float progressInterval; /* Amount to increase progress by after each draw() */
  
  Animation() {
    this.progress = 0;
    this.progressInterval = 0.001;
  }

}

