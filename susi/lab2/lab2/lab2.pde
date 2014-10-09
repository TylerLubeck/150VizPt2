
int curr = 0;
int NUM_SLIDES = 3;
Button nextButton;
int margin = 30, iWidth = 800, iHeight = 600;
Adult adults[];

void setAdults(Adult a[]) { adults = a; }

void setup() {
  size(iWidth + 2 * margin, iHeight + 2 * margin, P2D);
  //size(800, 500);
  //size(width, height);
  background(255);
  nextButton = new Button(0.04*width, 0.93*height, 0.08*width, 0.05*height);
}

void draw() {
  background(255);
  switch (curr) {
    case 0: step0(); break;
    case 1: step1(); break;
    case 2: step2(); break;
  }
  //nextButton.draw();
}

void changeSlide(int n) { curr = n; }

void mouseClicked() {
  if (nextButton.contains(mouseX,mouseY)) {    
    curr = (curr + 1) % NUM_SLIDES;
  }
}

class Adult {
  String age;
  String workClass;
  String fnlwgt;
  String education;
  String educationNum;
  String maritalStatus;
  String occupation;
  String relationship;
  String race;
  String sex;
  String capitalGain;
  String capitalLoss;
  String hoursPerWeek;
  String country;
  String income;
  
  Adult(String data) {
    String d[] = splitTokens(data, ",");
    age = d[0];
    workClass = d[1];
    fnlwgt = d[2];
    education = d[3];
    educationNum = d[4];
    maritalStatus = d[5];
    occupation = d[6];
    relationship = d[7];
    race = d[8];
    sex = d[9];
    capitalGain = d[10];
    capitalLoss = d[11];
    hoursPerWeek = d[12];
    country = d[13];
    income = d[14];
  }
}

