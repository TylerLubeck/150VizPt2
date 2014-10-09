
// Debugging - only do this for my user agent
//if (navigator.userAgent.indexOf("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36") == 0) {
  //console.log('yay!');
//  mode = 2;
//}

function containsPoint(x,y,w,h,mX,mY) {
  return (mX > x) && (mY > y) && (mX < (x+w)) && (mY < (y+h));
}

function isNumeric(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}

// occupation, education, gender (color)
var still_need_to_setup = true;
var occ = [], edu = [], sex = [];
var occ_nub = new Object(), edu_nub = new Object(), sex_nub = new Object();
var toolTip = new Object(); var doToolTip = false;
var occ_nub_length = 0, edu_nub_length = 0, sex_nub_length = 0;
function step2(p) {
  //p.triangle(10,10,300,300,10,300);
  p.line(iWidth*0.20, iHeight*0.90, iWidth*0.20, iHeight*0.1);
  p.line(iWidth*0.20, iHeight*0.90, iWidth*0.90, iHeight*0.90);
  dooToolTip = false;

  // Change text of descriptive paragraph:
  var e = document.getElementById("p3");
  if (e.innerHTML.indexOf("And this is a stacked bar plot showing") != 0) {
    e.innerHTML =  "And this is a stacked bar plot showing the male / female divide ";
    e.innerHTML += "for the various occupations. Green indicates the male portion ";
    e.innerHTML += "while blue indicates the female portion. Hover-over tooltips further ";
    e.innerHTML += "show the high school graduation rates of people in their respective ";
    e.innerHTML += "occupations for each gender.";
    //console.log(e);
  }
        
  var i = 0;
  toolTip.x = 1000; toolTip.y = 1000;
  if (still_need_to_setup) {
    function setup_step2() {
      
      for (i = 0; i < adults.length; i++) {
        occ.push(adults[i].Occupation);
        edu.push(adults[i].Education);
        sex.push(adults[i].Sex);

        if (occ_nub[occ[i]] == undefined) {
          occ_nub_length += 1;
          occ_nub[occ[i]] = 0;
        }
        if (edu_nub[edu[i]] == undefined) {
          edu_nub[edu[i]] = 0;
          edu_nub_length += 1;
        }
        if (sex_nub[sex[i]] == undefined) {
          sex_nub[sex[i]] = 0;
          sex_nub_length += 1;
        }
        occ_nub[occ[i]] += 1;
        edu_nub[edu[i]] += 1;
        sex_nub[sex[i]] += 1;
      }
    }
    setup_step2();
    still_need_to_setup = false;
  }

  var tick = 0.1;
  var delta = 0.8 / occ_nub_length;
  i = 0;
  //console.log(occ_nub);
  for (var k in occ_nub) {
    if (occ_nub.hasOwnProperty(k)) {
      p.line(iWidth*0.18, iHeight*tick, iWidth*0.22, iHeight*tick);
      //p.rotate(0 - p.HALF_PI);
      p.textAlign(p.LEFT,p.TOP);
      p.textSize(12);
      p.fill(0);
      p.text(k, 10,iHeight*tick); //iWidth*tick, iHeight*0.95);
      //p.rotate(0 + p.HALF_PI);

      var j;
      var women = 0, men = 0, numppl = 0;
      var postHSMale = 0, postHSFemale = 0;
      for (j = 0; j < sex.length; j++) {
        if (occ[j] == k) {
          numppl = numppl + 1;
        }
        if (occ[j] == k && sex[j] == "Male") {
          men = men + 1;
          if (!isNumeric(edu[j][0])) {
            postHSMale = postHSMale + 1;
          }
          //console.log(edu_nub);
          //console.log(edu[j]);
        }
        if (occ[j] == k && sex[j] == "Female") {
          women = women + 1;
          if (!isNumeric(edu[j][0])) {
            postHSFemale = postHSFemale + 1;
          }
        }
      }
      women = 1.0*women / numppl;
      men = 1.0*men / numppl;
      //console.log(men,women);

      //console.log(iWidth,men,women,numppl);
      //p.fill(20,100+100*tick,50+100*tick);
      p.fill(20,150,50);
      //if (k == "?") console.log(occ_nub[k]);
      //if (k.indexOf("Prof-specialty") == 0) console.log(occ_nub[k]);
      var xM = iWidth*0.20, yM = iHeight*tick,
          wM = men*occ_nub[k]/10.0, hM = delta*iHeight;
      p.rect(xM,yM,wM,hM);
      p.fill(0,154,205);
      //maybeToolTip(p,xM,yM,wM,hM,k,"male",);
      if (containsPoint(xM,yM,wM,hM,p.mouseX,p.mouseY)) {
        //console.log("Hovering over male "+k+" rectangle");
        doToolTip = true;
        toolTip.x = p.mouseX; toolTip.y = p.mouseY;
        toolTip.gender = "Male";
        toolTip.occup = k;
        var perc = ((100.0 * postHSMale / men / numppl).toFixed(2)).toString()
        toolTip.educ = perc + "% graduated highschool";
      }

      var xF = iWidth*0.20 + men*occ_nub[k]/10.0, yF = iHeight*tick,
          wF = women*occ_nub[k]/10.0, hF = delta*iHeight;
      p.rect(xF,yF,wF,hF);
      //maybeToolTip(p,xF,yF,wF,hF);
      if (containsPoint(xF,yF,wF,hF,p.mouseX,p.mouseY)) {
        doToolTip = true;
        toolTip.x = p.mouseX; toolTip.y = p.mouseY;
        toolTip.gender = "Female";
        toolTip.occup = k;
        var perc = ((100.0 * postHSFemale / women / numppl).toFixed(2)).toString()
        toolTip.educ = perc + "% graduated highschool";
      }
      //console.log(doToolTip);
      
      tick += delta;
    }
  }

  // X-axis
  tick = 0.2;
  delta = 0.1;
  deltaData = 590;
  tickData = 0;
  for (tick = 0.2; tick < 0.9; tick += delta) {
    p.line(iWidth*tick, iHeight*0.90, iWidth*tick, iHeight*0.92);
    p.textAlign(p.LEFT, p.TOP);
    p.textSize(12);
    p.fill(0.0);
    p.text(tickData.toString(), iWidth*(tick - 0.01), iHeight*(0.92));
    tickData += deltaData;
  }
  p.textSize(18);
  p.text("Number of people", iWidth*0.45, iHeight*0.97);

  // Tool Tip:
  if (doToolTip) {
    p.textSize(12);
    p.textAlign(p.LEFT);
    var textW = p.textWidth(toolTip.educ);
    p.fill(255);
    p.rect(toolTip.x+5, toolTip.y-60, textW*1.1, 50);
    p.fill(0.0);
    var txt = toolTip.occup + " " + toolTip.gender + "\n" + toolTip.educ;
    p.text(txt, toolTip.x + 5 + textW*0.05, toolTip.y - 30);
    p.textAlign(p.CENTER, p.BOTTOM);
  }

}

