
public abstract class Drawable {
  abstract void draw(float x0, float y0, float w, float h); /* Draw this drawable thing */
  /* Whether or not this drawable things "contains" the mouse */
  boolean contains(int xM, int yM) { return false; }
  void draw() { this.draw(0,0,width,height); } /* Default to drawing on entire screen */
}

