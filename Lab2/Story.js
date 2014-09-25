Number.prototype.map = function ( in_min , in_max , out_min , out_max ) {
      return ( this - in_min ) * ( out_max - out_min ) / ( in_max - in_min ) + out_min;
}

Drawing = {};
var Drawing = function() {
    var result;
    this.closedPotholes = {};  
    this.allPotholes = {}; 
    this.openPotholes = {}; 
    this.remainingPotholes = {};
    var intColor = 0;
    this.mode = 0;
    var _this = this;

    this.nextMode = function() {
        this.mode++;
        if (this.mode > 3) {
            this.mode = 0;
        }
    }

    this.prevMode = function() {
        this.mode--;
        if (this.mode < 0) {
            this.mode = 3;
        }
    }

    function countFrequency(result) {
        var count = {}; 
        for (var i = 0; i < result.length; i++) {
            if (! Boolean(result[i].zip)) {
                continue;
            }
            if (Boolean(count[result[i].zip])) {
                count[result[i].zip]++;
            } else {
                count[result[i].zip] = 1; 
            }
        }
        //TODO: I think if you can turn this dictionary in to a list of the form
        //      [{02155: 20}, {02156: 10}, ...] 
        //      then we'll be in pretty good shape.
        var keys = Object.keys(count);
        keys.sort();
        objects = [];
        for (var k in keys) {
            obj = {}
            obj[keys[k]] = count[keys[k]];
            objects.push(obj);
        }
        //return count; 
        return objects;
    }

    this.init = function() {
        d3.csv("open_potholes.csv", function (d) {
            return {
                zip : d.LOCATION_ZIPCODE
            }; 
        }, function(err, d) {
            if(err) {
                return console.log('Oops! csv died.');
            }
            _this.openPotholes = countFrequency(d); 
            _this.remainingPotholes = countFrequency(d);
            console.log(_this.openPotholes);
            console.log(_this.remainingPotholes);
            console.log("GOT OPEN: " + _this.openPotholes);  

            d3.csv("closed_potholes.csv", function (d) {
                return {
                    zip : d.LOCATION_ZIPCODE
                }; 
            }, function(err, d) {
                if(err) {
                    return console.log('Oops! csv died.');
                }
                _this.closedPotholes = countFrequency(d); 
                console.log("Got closed");
                console.log(_this.closedPotholes);
                for(i in _this.closedPotholes){
                    for(k in _this.closedPotholes[i]){
                        valR = _this.remainingPotholes[i][k];
                        valC = _this.closedPotholes[i][k];
                        valDif = valR - valC;
                        _this.remainingPotholes[i][k]=valDif;
                    }
                }
                console.log("Got remaining");


                d3.csv("pothole_callins.csv", function(d){
                    return {
                        zip : d.LOCATION_ZIPCODE 
                      };		
                }, function(err, d){
                    if(err) {
                        return console.log('Oops! csv died.');
                    }
                    _this.allPotholes = countFrequency(d);
                    console.log(_this.allPotholes); 
                    _this.run();
                });

            }); 
        }); 
    }
    
    function sketchProc(p) {	
        var margin = 30, iWidth = 700, iHeight = 400;
        var x1 = margin, x2 = iWidth;
        function drawLines() {
            p.line(x1, iHeight+margin, x2, iHeight+margin);
            p.line(x1, iHeight+margin, x1, margin);
        }

        function step0(objects, width, offset, r,g,b, caseNum) {
            var leftMost = x1 + 10;
            for (item in objects) {
                for (k in objects[item]) {
                    var val = objects[item][k];
                    if(leftMost + offset < p.mouseX &&
                       p.mouseX < leftMost+offset+width) {
                        p.fill(p.color(r, g, b));
                        if(caseNum==0){
                            $('#display').text("zipcode:" + k + " had " + val + " open potholes");
                        } else if(caseNum==1){
                            $('#display').text("zipcode:" + k + " closed " + val + " potholes");
                        } else{
                            $('#display').text("zipcode:" + k + " still had " + val + " open potholes");
                        }
                    } else {
                    }
                    val = val.map(0, 2221, 0, iHeight-margin);
                    p.rect(leftMost+offset, iHeight+margin, width, -val);
                    leftMost += 20;
                    p.fill(p.color(0));
                }
            }
        }
       
        p.setup = function(){ 
            p.size(iWidth + 2 * margin, iHeight + 2 * margin, p.P2D);
            $("#canvas1").css("width","" + p.width);
            $("#canvas1").css("height","" + p.height);
            p.smooth();   	 
            p.rectMode(p.CORNER);
            p.ellipseMode(p.RADIUS);
            console.log(p)
        };
       
        p.draw = function() {
            p.background(p.color(250));
            p.stroke(p.color(0));
            p.fill(p.color(0));
            drawLines();
            switch (_this.mode) {
                case 0:
                    $('#subtitle').text("During the year of 2012,");
                    step0(_this.openPotholes, 10, 0, 255, 0, 0, 0);
                    break; 
               case 1:
                    $('#subtitle').text("By the end of 2012,");
                   //step1();
                    step0(_this.closedPotholes, 10, 0, 0, 255, 0, 1);
                   break;
               case 2:
                    $('#subtitle').text("During 2012,");
                    step0(_this.closedPotholes, 5, 5, 0, 255, 0, 1);
                    p.fill(p.color(0, 0, 0));
                    step0(_this.openPotholes, 5, 0, 255, 0, 0, 0);
                   break;
               case 3:
                    $('#subtitle').text("By the end of 2012,");
                    p.fill(p.color(0, 0, 0));
                    step0(_this.remainingPotholes, 5, 0, 255, 0, 0, 3);
                   break;
           }
        };
    }

    this.run = function(result) {
        var canvas = document.getElementById("canvas1");
        var processingInstance = new Processing(canvas, sketchProc); 
    }
}

	 

$(function() {
    drawing = new Drawing();
    drawing.init();
    $('#pre').attr('disabled', true);
    
    $('#next').click(function(e) {
        drawing.nextMode();
        if (drawing.mode >= 3) {
            $('#next').attr('disabled', true);
        }
        if (drawing.mode > 0) {
            $('#pre').attr('disabled', false);
        }
    });
    $('#pre').click(function(e) {
        drawing.prevMode();
        if (drawing.mode === 0) {
            $('#pre').attr('disabled', true);
        }
        if (drawing.mode < 3) {
            $('#next').attr('disabled', false);
        }
    });

});

