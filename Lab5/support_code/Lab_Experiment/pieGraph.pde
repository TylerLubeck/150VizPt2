class PieGraph extends Graph implements Cloneable {
  
  ArrayList<String> categories;
  ArrayList<Float> peoplePerCat;
  ArrayList<Float> angles;
  int totalNumPeople, tintVal;
  float centerX, centerY, radius;
    
  PieGraph(ArrayList<Float> peoplePerCat, boolean lastLevel) {
    super(categories, peoplePerCat);
    this.categories = categories;
    this.peoplePerCat = peoplePerCat;
    angles = new ArrayList<Float>();
    calcTotalNum();
    calcAngles();
  }
  
  String getSelectedCategory() {
    float currentAngle = 270;
    for (int i = 0; i < angles.size(); ++i) {
      if(testIntersect(centerX, centerY, radius, (currentAngle - angles.get(i)), currentAngle)) {
        return categories.get(i);
      }
      currentAngle -= angles.get(i);
    }
    return "";
  }
  
  void calcTotalNum() {
    totalNumPeople = 0;
    for (int i=0; i<peoplePerCat.size(); ++i) {
      totalNumPeople += peoplePerCat.get(i);
    }
  }
  
  void calcAngles() {
    for (int i = 0; i<peoplePerCat.size(); ++i) {
      angles.add(((float)peoplePerCat.get(i) / (float)totalNumPeople) * 360.0);
    }
  }
  
  void draw(float centerX, float centerY, float radius) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    float currentAngle = 270;
//    toolTip = "";
//    int colorIndex = 0;
    for (int i =0; i < angles.size(); ++i) {
//      if(testIntersect(centerX, centerY, radius, (currentAngle - angles.get(i)), currentAngle)) {
//        fill(highlight);
//        toolTip = categories.get(i) + " - " + peoplePerCat.get(i);
//      }
//      else {
//        fill(colors[colorIndex]);
//      }
      stroke(0);
      arc(centerX, centerY, 2*radius, 2*radius, radians(currentAngle - angles.get(i)), radians(currentAngle),  PIE);
      currentAngle -= angles.get(i);
//      colorIndex = (colorIndex + 1) % colors.length;
    }
//    drawLabels(255);
//    if (toolTip != "") {
//      textSize(15);
//      textAlign(LEFT);
//      float textW = textWidth(toolTip);
//      fill(255);
//      rect(mouseX, mouseY-40, textW*1.1, 45);
//      fill(0);
//      text(toolTip, mouseX+ textW*0.05, mouseY-23);
//      textAlign(CENTER, BOTTOM);
    }
  }
  
//  boolean testIntersect(float centerX, float centerY, float radius, float lowerAngle, float upperAngle) {
//    float distance = sqrt((mouseX - centerX) * (mouseX - centerX) + (mouseY - centerY) * (mouseY - centerY));
//    if (distance > radius) 
//      return false;
//    float mouseAngle = degrees(atan2((mouseY - centerY),(mouseX - centerX)));
//    if (mouseAngle < 0) 
//      mouseAngle += 360.0;
//    if (lowerAngle < 0 && upperAngle < 0) {
//      lowerAngle += 360;
//      upperAngle += 360;
//    }
//    else if (lowerAngle < 0) {
//      lowerAngle += 360;
//      if (lowerAngle > upperAngle)
//        return (! (upperAngle < mouseAngle && mouseAngle < lowerAngle));
//    }
//    return (lowerAngle < mouseAngle && mouseAngle < upperAngle);
//  }  
  
//  void drawLabels(int tintValue) {
//    this.tintVal = tintValue;
//    drawLabels();
//  }
  
//  void drawLabels() {
//    float currentAngle = 270;
//    float startX, startY, endX, endY, lineAngle;
//    for (int i =0; i < angles.size(); ++i) {
//      stroke(0, tintVal);
//      fill(0, tintVal);
//      lineAngle = currentAngle - angles.get(i)/2.0;
//      startX = centerX + radius * cos(radians(lineAngle));
//      startY = centerY + radius * sin(radians(lineAngle));
//      endX = centerX + 1.5 * radius * cos(radians(lineAngle));
//      endY = centerY + 1.5 * radius * sin(radians(lineAngle));
//      line(startX, startY, endX, endY);
//      if (lineAngle < 270 && lineAngle > 180)
//        textAlign(RIGHT, BOTTOM);
//      else if (lineAngle < 180 && lineAngle > 90)
//        textAlign(RIGHT, TOP);
//      else if (lineAngle < 90 && lineAngle > 0)
//        textAlign(LEFT, TOP);
//      else
//        textAlign(LEFT, BOTTOM);
//      text(categories.get(i), endX, endY);
//      currentAngle -= angles.get(i);
//    }
//  }
    
}

