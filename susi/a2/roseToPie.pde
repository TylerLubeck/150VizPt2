class RoseToPie implements Cloneable {
 color[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
 color highlight = color(255, 255, 0);
  
 PieGraph pieG;
 RoseChart roseG;
 float centerX, centerY, rPie, rRose, rUnit, rAngle, progress;
 boolean fading;
 ArrayList<Float> angles;
 ArrayList<ArrayList<Float>> values;
  
 RoseToPie(PieGraph pie, RoseChart rose) {
   this.pieG = pie;
   this.roseG = rose;
   this.angles = (ArrayList<Float>)pieG.angles.clone();
   this.values = (ArrayList<ArrayList<Float>>)roseG.values.clone();
   rAngle = 360.0 / angles.size();
   rpSetup();
 }
 
 void rpSetup() {
  progress = 0; 
  fading = true; 
  roseG.setTint(255);
 }
 
 void draw(float centerX, float centerY, float rPie, float rRose) {
   if (fading) {
     fadeOut(centerX, centerY, rRose);
     if (!fading)
       progress = 0;
   }
   else if (progress < 1) {
     shiftPie(centerX, centerY, rPie, rRose);
     if(progress >= 1) {
       inTransition = false;
       rose = false;
       pie = true;
       toPie = false;
       rpSetup();
     }
   }
 }
 
 void shiftPie(float centerX, float centerY, float rPie, float rRose) {
   float currentAngle = 270;
   int colorIndex = 0;
   roseG.maxRadius = rRose;
   roseG.calcAxisVals();
   float unit = roseG.unit;
   float tempAngle, tempR;
   
   for (int i = 0; i < angles.size(); ++i) {
     progress += 0.0005;
     fill(lerpColor(colors[1], colors[colorIndex], progress));;     tempR = lerp(unit * values.get(0).get(i), rPie, progress);
     tempAngle = lerp(rAngle, angles.get(i), progress);;
     stroke(0);
     arc(centerX, centerY, 2* tempR, 2* tempR, radians(currentAngle - tempAngle), radians(currentAngle), PIE);
     currentAngle -= tempAngle;
     colorIndex = (colorIndex + 1) % colors.length;
    }
 }
 
 void fadeOut(float centerX, float centerY, float radius) {
   progress += 0.01;
   int tintVal = int(lerp(255, 0, progress));
   roseG.setTint(tintVal);
   roseG.draw(centerX, centerY, radius);
   if (progress >= 1)
     fading = false;
 }
 
}


