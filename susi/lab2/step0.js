var Gender = function(maleCount, femaleCount, totalCount) {
	this.male 		= maleCount;
	this.female 	= femaleCount;
	this.totalCount = totalCount;
};

Gender.prototype.updateMale = function() {
	this.male++;
	this.totalCount++;
};

Gender.prototype.updateFemale = function() {
	this.female++;
	this.totalCount++;
};


var stil_need_tp_setup = true;
var edu_distinct = [];
var edu_length = 0;
//var edu_num = 0, male = 0, female = 0, numppl = 0;


function getMaxTotalCount() {
	var max = 0;
	for(var key in edu) {
		if (max < edu[key].totalCount) {
			max = edu[key].totalCount;
		}
	}
	return max;
};


function getMaxMaleCount() {
	var max = 0;
	for(var key in edu) {
		if (max < edu[key].male) {
			max = edu[key].male;
		}
	}
	return max;
};

function getMaxFemaleCount() {
	var max = 0;
	for(var key in edu) {
		if (max < edu[key].female) {
			max = edu[key].female;
		}
	}
	return max;
}

function step0(p) {

	// X/Y Axis
	p.line(iWidth*0.20, iHeight*0.90, iWidth*0.20, iHeight*0.1);
	p.line(iWidth*0.20, iHeight*0.90, iWidth*0.90, iHeight*0.90);

	var i;
			// Main assoc array of education types, each with a Gender object
	if (stil_need_tp_setup) {
		function setup_step0() {
			for (i in adults) {

				// Creates array of distinct education types
			    if (typeof(edu[adults[i].Education]) == "undefined") {
			    	// If new education type, create a new Gender object
			    	edu[adults[i].Education] = new Gender(0, 0, 0);
			    	// Push new edu type into array of distinct types
			    	edu_distinct.push(adults[i].Education);
			    	edu_length += 1;
			    } 

			    // Counts num of sex
			    if (adults[i].Sex == "Male") {
			    	edu[adults[i].Education].updateMale();
			    } else {
			    	edu[adults[i].Education].updateFemale();
			    }
			}
		}
		setup_step0();
		stil_need_tp_setup = false;
	}


	// X - Axis
	var delta = (iWidth*.7)/(edu_distinct.length + 1);
	var tickX = iWidth*0.2 + delta;
	var halfTick = iHeight*0.01;
	var zeroY = iHeight*0.91;

	for (var i=0; i<edu_distinct.length; i++) {
		//console.log(i);
		p.line(tickX, zeroY - halfTick, tickX, zeroY+ halfTick);
		p.textAlign(p.LEFT, p.TOP);
		p.textSize(12);
		//p.rotate(p.HALF_PI);
		p.fill(0);
		p.text(edu_distinct[i], tickX, iHeight*(0.92));
		tickX += delta;
	}

	// Y - Axis
	// halfTick = iWidth * 0.01;
	// var maxTotal = getMaxTotalCount();
	// var range = maxTotal/20;
	// var unit = ((iHeight * 0.8 / maxTotal)/1.1);
	// //console.log(unit);
	// for (var i=0; i<= range; i++) {
	// 	p.line(iWidth*.02 - halfTick, zeroY-unit*i, iWidth*.02 + halfTick, zeroY-unit*i);
	// } 


}
