class PieGraph {
  color[] colors = {
    color(0, 0, 255), color(0, 255, 0), color(255, 0, 0), color(0, 255, 255), color(255, 0, 255)};
  color highlight = color(255, 255, 0);
  
  ArrayList<String> categories;
  ArrayList<Integer> peoplePerCat;
  ArrayList<Float> angles;
  int totalNumPeople;
  String toolTip;
  boolean lastLevel;
  float centerX, centerY, radius;
  
  PieGraph(ArrayList<String> categories, ArrayList<Integer> peoplePerCat, boolean lastLevel) {
    this.categories = categories;
    this.peoplePerCat = peoplePerCat;
    angles = new ArrayList<Float>();
    calcTotalNum();
    calcAngles();
    toolTip = "";
    this.lastLevel = lastLevel;
  }
  
  String getSelectedCategory() {
    float currentAngle = 0;
    for (int i = 0; i < angles.size(); ++i) {
      if(testIntersect(centerX, centerY, radius, currentAngle, (currentAngle + angles.get(i)))) {
        return categories.get(i);
      }
      currentAngle += angles.get(i);
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
    float currentAngle = 0;
    toolTip = "";
    int colorIndex = 0;
    for (int i =0; i < angles.size(); ++i) {
      if(testIntersect(centerX, centerY, radius, currentAngle, (currentAngle + angles.get(i)))) {
        fill(highlight);
        toolTip = categories.get(i) + " - " + peoplePerCat.get(i);
      }
      else {
        fill(colors[colorIndex]);
      }
      arc(centerX, centerY, 2*radius, 2*radius, radians(currentAngle), radians(currentAngle + angles.get(i)), PIE);
      currentAngle += angles.get(i);
      colorIndex = (colorIndex + 1) % colors.length;
    }
    if (toolTip != "") {
      if (! lastLevel)
        toolTip += "\nClick for more information";
      textSize(15);
      textAlign(LEFT);
      float textW = textWidth(toolTip);
      fill(255);
      rect(mouseX, mouseY-40, textW*1.1, 45);
      fill(0);
      text(toolTip, mouseX+ textW*0.05, mouseY-23);
      textAlign(CENTER, BOTTOM);
    }
  }
  
  boolean testIntersect(float centerX, float centerY, float radius, float lowerAngle, float upperAngle) {
    float distance = sqrt((mouseX - centerX) * (mouseX - centerX) + (mouseY - centerY) * (mouseY - centerY));
    if (distance < radius) {
      float mouseAngle = degrees(atan2((mouseY - centerY),(mouseX - centerX)));
      if (mouseAngle < 0) {
        mouseAngle += 360.0;
      }
      if (lowerAngle < mouseAngle && mouseAngle < upperAngle) {
        return true;
      }
    }
    return false;
  }
  
}

