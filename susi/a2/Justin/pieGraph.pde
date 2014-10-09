// class PieGraph implements Drawable, Cloneable{
//   color[] colors = {
//     color(0, 0, 255), color(0, 255, 0), color(255, 0, 0), color(0, 255, 255), color(255, 0, 255)};
//   color highlight = color(255, 255, 0);
  
//   ArrayList<String> categories;
//   ArrayList<Float> peoplePerCat;
//   ArrayList<Float> angles;
//   int totalNumPeople;
//   String toolTip;
//   boolean lastLevel, pbChange;
//   float centerX, centerY, radius;
//   float pbExplRad, pbSpreadRad, pbSqRad, pbX, pbY, pbSpreadIncrement;
  
//   ArrayList<Float> pbRadii;
//   ArrayList<Float> pbThetas;
  
  
//   PieGraph(ArrayList<String> categories, ArrayList<Float> peoplePerCat, boolean lastLevel) {
//     this.categories = categories;
//     this.peoplePerCat = peoplePerCat;
//     angles = new ArrayList<Float>();
//     calcTotalNum();
//     calcAngles();
//     toolTip = "";
//     this.lastLevel = lastLevel;
//     pbExplRad = 0;
//     pbChange = false;
//   }
  
//   String getSelectedCategory() {
//     float currentAngle = 270;
//     for (int i = 0; i < angles.size(); ++i) {
//       if(testIntersect(centerX, centerY, radius, (currentAngle - angles.get(i)), currentAngle)) {
//         return categories.get(i);
//       }
//       currentAngle -= angles.get(i);
//     }
//     return "";
//   }
  
//   void calcTotalNum() {
//     totalNumPeople = 0;
//     for (int i=0; i<peoplePerCat.size(); ++i) {
//       totalNumPeople += peoplePerCat.get(i);
//     }
//   }
  
//   void calcAngles() {
//     for (int i = 0; i<peoplePerCat.size(); ++i) {
//       angles.add(((float)peoplePerCat.get(i) / (float)totalNumPeople) * 360.0);
//     }
//   }
  
//   void draw(float x, float y, float w, float h) {
//     draw((x + w)/2.0, (y + h)/2.0, w < h ? 0.9*(w/2) : 0.9*(h/2));
//   }

//   void draw(float centerX, float centerY, float radius) {
//     this.centerX = centerX;
//     this.centerY = centerY;
//     this.radius = radius;
//     float currentAngle = 270;
//     toolTip = "";
//     int colorIndex = 0;
//     for (int i =0; i < angles.size(); ++i) {
//       if(testIntersect(centerX, centerY, radius, (currentAngle - angles.get(i)), currentAngle)) {
//         fill(highlight);
//         toolTip = categories.get(i) + " - " + peoplePerCat.get(i);
//       }
//       else {
//         fill(colors[colorIndex]);
//       }
//       arc(centerX, centerY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
//       currentAngle -= angles.get(i);
//       colorIndex = (colorIndex + 1) % colors.length;
//     }
//     if (toolTip != "") {
//       if (! lastLevel)
//         toolTip += "\nClick for more information";
//       textSize(15);
//       textAlign(LEFT);
//       float textW = textWidth(toolTip);
//       fill(255);
//       rect(mouseX, mouseY-40, textW*1.1, 45);
//       fill(0);
//       text(toolTip, mouseX+ textW*0.05, mouseY-23);
//       textAlign(CENTER, BOTTOM);
//     }
//   }
  
//   boolean testIntersect(float centerX, float centerY, float radius, float lowerAngle, float upperAngle) {
//     float distance = sqrt((mouseX - centerX) * (mouseX - centerX) + (mouseY - centerY) * (mouseY - centerY));
//     if (distance > radius) 
//       return false;
//     float mouseAngle = degrees(atan2((mouseY - centerY),(mouseX - centerX)));
//     if (mouseAngle < 0) 
//       mouseAngle += 360.0;
//     if (lowerAngle < 0 && upperAngle < 0) {
//       lowerAngle += 360;
//       upperAngle += 360;
//     }
//     else if (lowerAngle < 0) {
//       lowerAngle += 360;
//       if (lowerAngle > upperAngle)
//         return (! (upperAngle < mouseAngle && mouseAngle < lowerAngle));
//     }
//     return (lowerAngle < mouseAngle && mouseAngle < upperAngle);
//   }
  
//   void pbTransform(float centerX, float centerY, float radius, float barWidth) {
//     this.centerX = centerX;
//     this.centerY = centerY;
//     this.radius = radius;
    
//     if (pbExplRad  < radius /2) {
//       explode();
//       pbSpreadRad = pbExplRad;
//       pbSpreadIncrement = (radius * 1.2 - pbExplRad)/ (log((100 * radius)/ pbExplRad) / log(1.01));
//     }
//     else if (pbSpreadRad <= 100 *radius){
//       spread();
//       pbSqRad = pbSpreadRad;
//       pbSqStartCond();
//     }
//     else
//       squarify(barWidth);
//   }
    
//   void explode() {
//     float currentAngle = 270;
//     int colorIndex = 0;
//     float transX, transY;
//     for (int i =0; i < angles.size(); ++i) {
//       fill(colors[colorIndex]);
//       transX = centerX + pbExplRad * cos(radians(currentAngle - angles.get(i)/2));
//       transY = centerY + pbExplRad * sin(radians(currentAngle - angles.get(i)/2));
//       arc(transX, transY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
//       currentAngle -= angles.get(i);
//       colorIndex = (colorIndex + 1) % colors.length;
//     }
//     if (pbExplRad < radius/2)
//         pbExplRad += 0.5;
//   }  
  
//   void spread() {
//     float currentAngle = 270;
//     int colorIndex = 0;
//     float transX, transY, tempAngle;
//     for (int i =0; i < angles.size(); ++i) {
//       fill(colors[colorIndex]);
//       tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
//       transX = centerX + pbSpreadRad * cos(tempAngle);
//       transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
//       arc(transX, transY, 2*radius, 2*radius, (tempAngle - radians(angles.get(i)/2)), (tempAngle + radians(angles.get(i)/2)),  PIE);
//       currentAngle -= angles.get(i);
//       colorIndex = (colorIndex + 1) % colors.length;
//     } 
//     if (pbSpreadRad < 100 *radius){
//         pbSpreadRad *= 1.01;
//         if (pbExplRad < radius * 1.3)
//           pbExplRad += pbSpreadIncrement;
//     }
//   }
  
//   void pbSqStartCond() {
//     pbRadii = new ArrayList<Float>();
//     pbX = new ArrayList<Float>();
//     pbY = new ArrayList<Float>();
//     float currentAngle = 270;
//     for (int i = 0; i < angles.size(); ++i) {
//       pbRadii.add(radius);
//       tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
//       transX = centerX + pbSpreadRad * cos(tempAngle);
//       transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
//       pbX.add(transX);
//       pbY.add(transY);
//       currentAngle -= angles.get(i);

//     }  
//     pbThetas = (ArrayList<Float>)angles.clone();
//   }
  
//   void squarify(float barWidth) {
//     pbChange = false;
//     float currentAngle = 270;
//     int colorIndex = 0;
//     float transX, transY, tempAngle;
//     for (int i =0; i < angles.size(); ++i) {
//       fill(colors[colorIndex]);
//       if (pbThetas.get(i) * pbRadii.get(i) < barWidth) {
//          pbChange = true; 
//       }
//       tempAngle = PI/2 + pbExplRad / pbSpreadRad * (radians(currentAngle - angles.get(i)/2) - PI/2);
//       transX = centerX + pbSpreadRad * cos(tempAngle);
//       transY = centerY + pbSpreadRad * sin(tempAngle) - (pbSpreadRad - pbExplRad);
//       arc(transX, transY, 2*radius, 2*radius, (tempAngle - radians(angles.get(i)/2)), (tempAngle + radians(angles.get(i)/2)),  PIE);
//       currentAngle -= angles.get(i);
//       colorIndex = (colorIndex + 1) % colors.length;
//     } 
//     if (pbSpreadRad < 100 *radius){
//         pbSpreadRad *= 1.01;
//         if (pbExplRad < radius * 1.3)
//           pbExplRad += pbSpreadIncrement;
//     }
    
//   }
    
// }

