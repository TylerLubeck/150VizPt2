Drawing = {};
var Drawing = function() {
    var result;
    this.closedPotholes = {};  
    this.allPotholes = {}; 
    this.openPotholes = {}; 
    var intColor = 0;
    this.mode = 0;
    var _this = this;

    this.nextMode = function() {
        this.mode++;
        if (this.mode > 2) {
            this.mode = 0;
        }
    }

    this.prevMode = function() {
        this.mode--;
        if (this.mode < 0) {
            this.mode = 2;
        }
    }

    function countFrequency(result) {
        var count = {}; 
        for (var i = 0; i < result.length; i++) {
            if (Boolean(count[result[i].zip])) {
                count[result[i].zip]++;
            } else {
                count[result[i].zip] = 1; 
            }
        }
        return count; 
    }

    this.init = function() {
        d3.csv("pothole_callins.csv", function(d){
            return {
                zip : d.LOCATION_ZIPCODE 
              };		
        }, function(err, d){
            if(err) {
                return console.log('Oops! csv died.');
            }
            allPotholes = countFrequency(d);
            console.log(allPotholes); 
        });

        d3.csv("closed_potholes.csv", function (d) {
            return {
                zip : d.LOCATION_ZIPCODE
            }; 
        }, function(err, d) {
            if(err) {
                return console.log('Oops! csv died.');
            }
            closedPotholes = countFrequency(d); 
            console.log(closedPotholes);  
        }); 

        d3.csv("open_potholes.csv", function (d) {
            return {
                zip : d.LOCATION_ZIPCODE
            }; 
        }, function(err, d) {
            if(err) {
                return console.log('Oops! csv died.');
            }
            openPotholes = countFrequency(d); 
            console.log(openPotholes);  
        }); 
    }
    
    function sketchProc(p) {	
        var margin = 30, iWidth = 600, iHeight = 400;

        function step0() {
              
        }
       
        p.setup = function(){ 
            p.size(iWidth + 2 * margin, iHeight + 2 * margin, p.P2D);
            $("#canvas1").css("width","" + p.width);
            $("#canvas1").css("height","" + p.height);
            p.smooth();   	 
            p.rectMode(p.CORNER);
            p.ellipseMode(p.RADIUS);
        };
       
        p.draw = function() {
            p.background(p.color(250));
            p.rect(0, 0, 100, 100);
            switch (_this.mode) {
                case 0:
                   //step0();
                   console.log("STEP 0");
                   break; 
               case 1:
                   //step1();
                   console.log("STEP 1");
                   break;
               case 2:
                   //step2();
                   console.log("STEP 2");
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

    $('#pre').click(function(e) {
        drawing.prevMode();
    });
    $('#next').click(function(e) {
        drawing.nextMode();
    });

    drawing.run();

});

