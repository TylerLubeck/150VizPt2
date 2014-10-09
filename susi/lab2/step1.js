function step1(p, click) {
	if (click) {
		myClick(p);
	}
	p.textSize(15);
	p.fill(0);
	if(firstTime) {
		parseForSusi();
		var temp = new PieGraph(categories0, numPeople0, currentIndex, p);
		temp.calcTotalNum();
		temp.calcAngles();
		pies.push(temp);
		firstTime = false;
	}
	pies[currentIndex].draw(iWidth/2, iHeight/1.9, iHeight/6, p);

	if (currentIndex == 0) {
		p.textSize(20);
		p.textAlign(p.CENTER);
		p.fill(0);
		p.text("Breakdown of overall Population by education level", iWidth/2, iHeight * 0.1);
	}
	if (currentIndex == 1) {
		p.textSize(20);
		p.textAlign(p.CENTER);
		p.fill(0);
		p.text("Breakdown of people with education level\n" + cat1 + " by marital Status", iWidth/2, iHeight * 0.1);
		pies[0].lastLevel = true;
		pies[0].draw(iWidth * 0.1, iHeight * 0.95, iHeight/18, p);
		p.textSize(10);
		p.textAlign(p.CENTER);
		p.fill(0);
		p.text("Breakdown of overall Population \nby education level", iWidth * 0.3, iHeight + 20);
	}
	if (currentIndex == 2) {
		p.textSize(20);
		p.textAlign(p.CENTER);
		p.fill(0);
		p.text("Breakdown of people with education level\n"  + cat1 + " and marital Status " + cat2 + " by Race", iWidth/2, iHeight * 0.1);
		pies[0].lastLevel = true;
		pies[0].draw(iWidth * 0.1, iHeight * 0.95, iHeight/18, p);
		p.textSize(10);
		p.textAlign(p.CENTER);
		p.fill(0);
		p.text("Breakdown of overall Population \nby education level", iWidth * 0.3, iHeight + 20);
		pies[1].lastLevel = true;
		pies[1].draw(iWidth * 0.85, iHeight*0.95, iHeight/18, p);	
		p.textSize(10);
		p.textAlign(p.CENTER);
		p.fill(0);
		p.text("Breakdown of people with education\nlevel" + cat1 + " by marital Status", iWidth * 0.65, iHeight + 20);

	}
	var e = document.getElementById("p3");
  if (e.innerHTML.indexOf("And this is a stacked bar plot showing") != 0) {
    e.innerHTML =  "This pie chart first shows the overall population sample split by education level. ";
    e.innerHTML += "Each education sector can be zoomed into for a breakdown by marital status ";
    e.innerHTML += "and then each marital status can be broken into race by clicking on the ";
    e.innerHTML += "corresponding wedge in the pie chart. ";
  }
}

var categories0 = [], categories1 = [], categories2 = [];
var numPeople0 = [], numPeople1 = [], numPeople2 = [];
var pies = [];
var currentIndex = 0;
var firstTime = true;
var cat1 = "", cat2 = "";


function PieGraph (cat, num, level, p) {
	this.colors = [
	p.color(0, 0, 255), p.color(0, 255, 0), p.color(255, 0, 0), p.color(0, 255, 255), p.color(255, 0, 255)];
	this.highlight = p.color(255, 255, 0);

	this.categories = cat;
	this.peoplePerCat = num;
	this.totalNumPeople = 0;
	this.angles = [];
	this.toolTip = "";
	this.level = level;
	this.centerX = 0.0;
	this.centerY = 0.0;
	this.radius = 0.0;
}

PieGraph.prototype.getSelectedCategory = function(p) {
	var currentAngle = 0.0;
	for (i = 0; i < this.angles.length; ++i) {
		if(this.testIntersect(this.centerX, this.centerY, 2*this.radius, currentAngle, (currentAngle + this.angles[i]), p)) {
			return this.categories[i];
		}
		currentAngle += this.angles[i];
	}
	return "";
};

PieGraph.prototype.calcTotalNum = function() {
	this.totalNumPeople = 0;
	for (i=0; i<this.peoplePerCat.length; ++i) {
		this.totalNumPeople += this.peoplePerCat[i];
	}
};

PieGraph.prototype.calcAngles = function() {
	for (i = 0; i<this.peoplePerCat.length; ++i) {
		this.angles.push((parseFloat(this.peoplePerCat[i]) / parseFloat(this.totalNumPeople)) * 360.0);
	}
};

PieGraph.prototype.testIntersect = function (centerX, centerY, radius, lowerAngle, upperAngle, p) {
	var distance = Math.sqrt((p.mouseX - centerX) * (p.mouseX - centerX) + (p.mouseY - centerY) * (p.mouseY - centerY));
	if (distance < radius) {
		var mouseAngle = p.degrees(p.atan2((p.mouseY - centerY),(p.mouseX - centerX)));
		if (mouseAngle < 0) {
			mouseAngle += 360.0;
		}
		if (lowerAngle < mouseAngle && mouseAngle < upperAngle) {
			return true;
		}
	}
	return false;
};

PieGraph.prototype.draw = function (centerX, centerY, radius, p) {
	this.centerX = centerX;
	this.centerY = centerY;
	this.radius = radius;
	var currentAngle = 0;

	this.toolTip = "";
	var colorIndex = 0;
	for (i =0; i < this.angles.length; ++i) {
		if(this.testIntersect(centerX, centerY, 2*radius, currentAngle, (currentAngle + this.angles[i]), p)) {
			p.fill(this.highlight);
			if(this.level == 2)
				this.toolTip = cat1 + " - " + cat2 + " \n" + this.categories[i] + " - " + this.peoplePerCat[i];
			else if(this.level == 1 && currentIndex != this.level)
				this.toolTip = cat1 + " - " + "\n" + this.categories[i] + " - " + this.peoplePerCat[i];
			else if (this.level == 1)
				this.toolTip = cat1 + " - " + this.categories[i] + " - " + this.peoplePerCat[i];				
			else 
				this.toolTip = this.categories[i] + " - " + this.peoplePerCat[i];
		}
		else if (this.level == currentIndex || this.level == 0 && cat1 == this.categories[i] || this.level == 1 && cat2 == this.categories[i]) {
			p.fill(this.colors[colorIndex]);
		}
		else {
			p.fill(this.colors[colorIndex], 128);	
		}
		p.arc(centerX, centerY, 2*radius, 2*radius, p.radians(currentAngle), p.radians(currentAngle + this.angles[i]), p.PIE);
		currentAngle += this.angles[i];
		colorIndex = (colorIndex + 1) % this.colors.length;
	}
	if (this.toolTip != "") {
		if (this.level == currentIndex && this.level != 2)
			this.toolTip += "\nClick for more information";
		p.textSize(15);
		p.textAlign(p.LEFT);
		var textW = p.textWidth(this.toolTip);
		p.fill(255);
		p.rect(p.mouseX, p.mouseY-40, textW*1.1, 40);
		p.fill(0);
		p.text(this.toolTip, p.mouseX+ textW*0.05, p.mouseY-23);
		p.textAlign(p.CENTER, p.BOTTOM);
	}
	p.stroke(4);
};



function parseForSusi() {
	for (i = 0; i < adults.length; ++i) {
		switch(currentIndex) {
			case 0: if (categories0.indexOf(uberCategories(adults[i].Education)) < 0) {
						categories0.push(uberCategories(adults[i].Education));
						numPeople0.push(1);
					}
					else {
						numPeople0[categories0.indexOf(uberCategories(adults[i].Education))]++;
					}
					break;
			case 1: if (uberCategories(adults[i].Education) == cat1) {
						if (categories1.indexOf(uberCategories(adults[i].MaritalStatus)) < 0) {
							categories1.push(uberCategories(adults[i].MaritalStatus));
							numPeople1.push(1);
						}
						else {
							numPeople1[categories1.indexOf(uberCategories(adults[i].MaritalStatus))]++;	
						}
					}
					break;
			case 2: if (uberCategories(adults[i].Education) == cat1 
							&& uberCategories(adults[i].MaritalStatus) == cat2) {
						if (categories2.indexOf(uberCategories(adults[i].Race)) < 0) {
							categories2.push(uberCategories(adults[i].Race));
							numPeople2.push(1);
						}
						else {
							numPeople2[categories2.indexOf(uberCategories(adults[i].Race))]++;	
						}
					}
					break;
		}
	}
}


function uberCategories(cat) {
	if (cat == "Married-civ-spouse" || cat == "Married-spouse-absent" || cat == "Married-AF-spouse")
		return "Married";
	if (cat == "11th" || cat == "9th" || cat == "7th-8th" || cat == "12th" || cat == "10th" || cat == "5th-6th")
		return "Some-HS";
	if (cat == "Prof-school" || cat == "Assoc-acdm" || cat == "Assoc-voc")
		return "Associate/Professional";
	if (cat == "1st-4th" || cat == "Preschool")
		return "Elementary-School";
	return cat
}


function myClick(p) {
	var selection = pies[currentIndex].getSelectedCategory(p);
	if (selection != "") {  		    
		if (currentIndex == 0) {
			currentIndex++;
			cat1 = selection;
			parseForSusi();
			var temp = new PieGraph(categories1, numPeople1, currentIndex, p);
			temp.calcTotalNum();
			temp.calcAngles();
			pies.push(temp);
		}
		else if (currentIndex == 1){
			currentIndex++;
			cat2 = selection;
			parseForSusi();
			temp = new PieGraph(categories2, numPeople2, currentIndex, p);
			temp.calcTotalNum();
			temp.calcAngles();
			pies.push(temp);
			pies[currentIndex].lastLevel = true;
		}
	}
	else {
		if (currentIndex > 0) {
			selection = pies[0].getSelectedCategory(p);
			if(selection != "") {
				cat1 = "";
				cat2 = ""; 	
				currentIndex = 0;
				pies[0].lastLevel = false;
				while(pies.length > 1)
					pies.pop();
			}
			else {
				console.log("made it into here");
				selection = pies[1].getSelectedCategory(p);
				if(selection != "") {
					cat2 = "";
					currentIndex = 1;
					pies[1].lastLevel = false;
					while(pies.length > 2)
						pies.pop();
				}
			}
		}
	console.log(currentIndex);
}
}
	


