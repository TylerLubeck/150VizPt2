class StackedView extends AbstractView {
     float[] xArray = null;
     float[] yArray = null;
     String xTitle = null;
     String yTitle = null;

    float xMax = -1;
    float yMax = -1;
    float xMin = -1;
    float yMin = -1;
    float gap = 20;

    int xIndex = -1;
    int yIndex = -1;

    HashMap<String, ArrayList<Integer>> operations;
    HashMap<String, ArrayList<Integer>> syslogs;
    HashMap<String, ArrayList<Integer>> protocols;

    // this deals with selection when items are under the mouse cursor
    public void hover() {
        // create the highlight Conditions to send as a message to all other scatter plots
        // through the Controller using the messages architecture
        // (highlight based on square surrounding the point with width 2*radius)
        Condition cond1 = new Condition(xTitle, "<=", inverseToXReal(mouseX));
        Condition cond2 = new Condition(xTitle, ">=", inverseToXReal(mouseX));
        Condition cond3 = new Condition(yTitle, "<=", inverseToYReal(mouseY));
        Condition cond4 = new Condition(yTitle, ">=", inverseToYReal(mouseY));
        Condition[] conds = new Condition[4];
        conds[0] = cond1;
        conds[1] = cond2;
        conds[2] = cond3;
        conds[3] = cond4;
         
        // Finish this:
        // Send a message to the Controller to provide the current conditions for highlighting
        // 1. create a new message instance (see Message.pde)
        Message msg = new Message();
        // 2. set the source of this message (see Message.pde)
        msg.setSource(this.name);
        // 3. set the conditions of this message (see Message.pde)
        msg.setConditions(conds);
        // 4. send the message (see AbstractView.pde)
        this.sendMsg(msg);
    }

    // handle sending messages to the Controller when a rectangle is selected
    public void handleThisArea(Rectangle rect) {
        // this rectangle holds the _pixel_ coordinates of the selection rectangle 
        Rectangle rectSub = getIntersectRegion(rect);

        if (rectSub != null) {
            Condition[] conds = new Condition[4];


            Condition cond1 = new Condition(xTitle, "<=", inverseToXReal(rectSub.p2.x));
            Condition cond2 = new Condition(xTitle, ">=", inverseToXReal(rectSub.p1.x));
            Condition cond3 = new Condition(yTitle, "<=", inverseToYReal(rectSub.p1.y));
            Condition cond4 = new Condition(yTitle, ">=", inverseToYReal(rectSub.p2.y));
            conds[0] = cond1;
            conds[1] = cond2;
            conds[2] = cond3;
            conds[3] = cond4;            

            // send out the message
            Message msg = new Message();
            msg.setSource(name)
               .setConditions(conds);
            sendMsg(msg);
        }
    }

    public void display() {
        pushStyle();
        stroke(0);
        strokeWeight(1);
        fill(255);
        rectMode(CORNER);


        rect(leftX, leftY, w, h);


        // for (int i = 0; i < xArray.length; i++) {
        //     if (marks[i]) {
        //         fill(pointHighLight);
        //     } else {
        //         fill(pointColor);
        //     }
        //     noStroke();
        //     // draw points
        //     ellipse(xScale(xArray[i]), yScale(yArray[i]*) *) 2);
        // }

        fill(0);
        
        // draw labels
        if(yIndex == 0){
            text(xTitle, leftX + w / 2.0, leftY - fontSize / 2.0);
        }

        if(xIndex == 0){
            pushMatrix();
            translate(leftX - fontSize / 2.0, leftY + w / 2.0);
            rotate(radians(-90));
            text(yTitle, 0, 0);
            popMatrix();
        }
        popStyle();
    }

    public StackedView setXYIndice(int x, int y) {
        this.xIndex = x;
        this.yIndex = y;
        return this;
    }

    // set the indice of columns that this view can see
    public StackedView setData() {
        
        operations = new HashMap<String, ArrayList<Integer>>();
        syslogs = new HashMap<String, ArrayList<Integer>>();
        protocols = new HashMap<String, ArrayList<Integer>>();

        for(Node n : nodes) {
            String op = n.op;
            String syslog = n.sysPriority;
            String prot = n.prot;

            if (operations.containsKey(op)) {
                operations.get(op).add(n.id);
            } else {
                ArrayList<Integer> newList = new ArrayList<Integer>();
                newList.add(n.id);
                operations.put(op, newList);
            }

            if (syslogs.containsKey(syslog)) {
                syslogs.get(syslog).add(n.id);
            } else {
                ArrayList<Integer> newList = new ArrayList<Integer>();
                newList.add(n.id);
                syslogs.put(syslog, newList);
            }

            if (protocols.containsKey(prot)) {
                protocols.get(prot).add(n.id);
            } else {
                ArrayList<Integer> newList = new ArrayList<Integer>();
                newList.add(n.id);
                protocols.put(prot, newList);
            }
        }

        return this;
    }

    public StackedView setTitles(String xStr, String yStr) {
        this.xTitle = xStr;
        this.yTitle = yStr;
        return this;
    }

    public StackedView initXYRange() {
        xMin = 0;//min(xArray);
        xMax = max(xArray) * 1.2;
        yMin = 0;//min(yArray);
        yMax = max(yArray) * 1.2;

        return this;
    }

    float xScale(float x) {
        return leftX + (x - xMin) / (xMax - xMin) * w;
    }

    float yScale(float y) {
        return leftY + h - ((y - yMin) / (yMax - yMin) * h);
    }

    // convert from pixel coordinates to data coordinates
    float inverseToXReal(float px) {
        return (px - leftX) / w * (xMax - xMin) + xMin;
    }

    // convert from pixel coordinates to data coordinates
    float inverseToYReal(float py) {
        return (h - (py - leftY)) / h * (yMax - yMin) + yMin;
    }
}

class Bar {
    float x, y;
    float w, h;
    ArrayList<Integer> indices;


    Bar(float x_, float y_, float w_, float h_, ArrayList<Integer> inds) {
        indices = new ArrayList<Integer>();
        x = x_;
        y = y_;
        w = w_;
        h = h_;
        //swag
        for(int i : inds) {
            indices.add(i);
        }
        rect(x, y, w, h);
    }
}