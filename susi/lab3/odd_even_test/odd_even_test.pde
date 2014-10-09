
int numPoints = 20;
Point[] shape;

Point endP;

void setup() {
    size(400, 400);
    smooth();
    shape = new Point[numPoints];
    endP = new Point();

    makeRandomShape();

    frame.setResizable(true);
}

void draw() {
    background(255, 255, 255);
    stroke(0, 0, 0);

    drawShape();
    if (mousePressed == true) {
        stroke(255, 0, 0);
        line(mouseX, mouseY, endP.x, endP.y);

        fill(0, 0, 0);
        boolean isect = isectTest();
        if (isect) {
            text("Inside", mouseX, mouseY);
        } else {
            text("Outside", mouseX, mouseY);
        }
    }
}

void mousePressed() {
    endP.x = random(-1, 1) * 2 * width;
    endP.y = random(-1, 1) * 2 * height;
}

void drawShape() {
    for (int i = 0; i < numPoints; i++) {
        int start = i;
        int end = (i + 1) % numPoints;

        line(shape[start].x + width/2.0f, 
             shape[start].y + height/2.0f,
             shape[end].x + width/2.0f, 
             shape[end].y + height/2.0f);
    }
}

boolean ccw(float x1, float y1, float x2, float y2,
            float x3, float y3) {
  return (y3-y1)*(x2-x1) > (y2-y1)*(x3-x1);
}

//boolean intersect(float x1, float y1, float x2, float y2,
//                  float x3, float y3, float x4, float y4) {
//  return (
//  return (ccw(x1,y1,x3,y3,x4,y4) != ccw(x2,y2,x3,y3,x4,y4))
//      && (ccw(x1,y1,x2,y2,x3,y3) != ccw(x1,y1,x2,y2,x4,y4));
//}

/*
boolean intersect(
  float x1,float y1,float x2,float y2, 
  float x3, float y3, float x4,float y4
  ) {
  
  float d = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);
  if (d == 0) return false;
  
  float xi = ((x3-x4)*(x1*y2-y1*x2)-(x1-x2)*(x3*y4-y3*x4))/d;
  float yi = ((y3-y4)*(x1*y2-y1*x2)-(y1-y2)*(x3*y4-y3*x4))/d;
  
  Point p = new Point(); p.x = xi; p.y = yi;
  if (xi < Math.min(x1,x2) || xi > Math.max(x1,x2)) return false;
  if (xi < Math.min(x3,x4) || xi > Math.max(x3,x4)) return false;
  return true;
}*/

boolean lineIsect(Point p1, Point q1, Point p2, Point q2) {
float a1 = p1.y - q1.y;
float b1 = q1.x - p1.x;
float c1 = q1.x * p1.y - p1.x * q1.y;
float a2 = p2.y - q2.y;
float b2 = q2.x - p2.x;
float c2 = q2.x * p2.y - p2.x * q2.y;
float det = a1 * b2 - a2 * b1;
//if (det == 0) {
if (isBetween(det, -0.0000001, 0.0000001)) {
return false;
} else {
float isectx = (b2 * c1 - b1 * c2) / det;
float isecty = (a1 * c2 - a2 * c1) / det;
//println ("isectx: " + isectx + " isecty: " + isecty);
if ((isBetween(isecty, p1.y, q1.y) == true) &&
(isBetween(isecty, p2.y, q2.y) == true) &&
(isBetween(isectx, p1.x, q1.x) == true) &&
(isBetween(isectx, p2.x, q2.x) == true)) {
return true;
}
}
return false;
}


        //line(shape[start].x + width/2.0f, 
        //     shape[start].y + height/2.0f,
        //     shape[end].x + width/2.0f, 
        //     shape[end].y + height/2.0f);

boolean isectTest() {
  int intersections = 0;
  Point s = new Point(); 
  Point e = new Point(); 
  Point sM = new Point();
  Point eM;
  float x1,y1,x2,y2,xM1,yM1,xM2,yM2;
  for (int i = 0; i < numPoints; i++) {
    s.x = shape[i].x + width/2.0f;
    s.y = shape[i].y + height/2.0f;
    e.x = shape[(i+1)%numPoints].x + width/2.0f;
    e.y = shape[(i+1)%numPoints].y + height/2.0f;
    sM.x = mouseX;
    sM.y = mouseY;
    eM = endP;
    if (lineIsect(s,e,sM,eM)) {
      intersections += 1;
    }
  }
  println(numPoints,intersections);
  return (intersections % 2) != 0;
}

boolean isBetween(float val, float range1, float range2) {
    float largeNum = range1;
    float smallNum = range2;
    if (smallNum > largeNum) {
        largeNum = range2;
        smallNum = range1;
    }

    if ((val < largeNum) && (val > smallNum)) {
        return true;
    }
    return false;
}

void makeRandomShape() {
    float slice = 360.0 / (float) numPoints;
    for (int i = 0; i < numPoints; i++) {
        float radius = (float) random(5, 100);
        shape[i] = new Point();
        shape[i].x = radius * cos(radians(slice * i));
        shape[i].y = radius * sin(radians(slice * i));
    }
}
