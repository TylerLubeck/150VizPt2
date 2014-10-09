class PieToRose implements Cloneable {
 color[] colors = {
   color(141,211,199),color(255,255,179),color(190,186,218),color(251,128,114),color(128,177,211),color(253,180,98),
   color(179,222,105),color(252,205,229),color(217,217,217),color(204,235,197),color(255,237,111)};
   color highlight = color(255, 255, 0);
  
 PieGraph pieG;
 RoseChart roseG;
 float centerX, centerY, rPie, rRose, rUnit, rAngle, progress;
 boolean shifting;
 ArrayList<Float> angles;
 ArrayList<ArrayList<Float>> values;
  
 PieToRose(PieGraph pie, RoseChart rose) {
   this.pieG = pie;
   this.roseG = rose;
   this.angles = (ArrayList<Float>)pieG.angles.clone();
   this.values = (ArrayList<ArrayList<Float>>)roseG.values.clone();
   rAngle = 360.0 / angles.size();
   prSetup();
 }
 
 void prSetup() {
  progress = 0; 
  shifting = true; 
  roseG.setTint(255);
 }
 
 void draw(float centerX, float centerY, float rPie, float rRose) {
   if (shifting) {
     shiftPie(centerX, centerY, rPie, rRose);
     if (!shifting)
       progress = 0;
   }
   else if (progress < 1) {
     fadeIn(centerX, centerY, rRose);
     if(progress >= 1) {
       inTransition = false;
       pie = false;
       rose = true;
       toRose = false;
       prSetup();
     }
   }
 }
 
 void shiftPie(float centerX, float centerY, float rPie, float rRose) {
   shifting = false;
   float currentAngle = 270;
   int colorIndex = 0;
   roseG.maxRadius = rRose;
   roseG.calcAxisVals();
   float unit = roseG.unit;
   float tempAngle, tempR;
   
   for (int i = 0; i < angles.size(); ++i) {
     progress += 0.0005;
     fill(lerpColor(colors[colorIndex], colors[1], progress));
     tempR = lerp(rPie, unit * values.get(0).get(i), progress);
     tempAngle = lerp(angles.get(i), rAngle, progress);
     arc(centerX, centerY, 2* tempR, 2* tempR, radians(currentAngle - tempAngle), radians(currentAngle), PIE);
     currentAngle -= tempAngle;
     colorIndex = (colorIndex + 1) % colors.length;
     if (progress < 1)
       shifting = true;
   }
 }
 
 void fadeIn(float centerX, float centerY, float radius) {
   progress += 0.01;
   int tintVal = int(lerp(0, 255, progress));
   roseG.setTint(tintVal);
   roseG.draw(centerX, centerY, radius);
 }
 
}


