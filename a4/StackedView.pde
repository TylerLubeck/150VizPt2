import java.util.Map.Entry;
class StackedView {
    ArrayList<Node> my_nodes;
    HashMap<String, ArrayList<Integer>> operations;
    HashMap<String, ArrayList<Integer>> syslogs;
    HashMap<String, ArrayList<Integer>> protocols;

    float leftX, leftY;
    float w, h;
    float topGap, bottom;
    float barHeight;
    float widthGap;
    float barWidth;
    ArrayList<Bar> allBars;

    StackedView() {
        my_nodes = new ArrayList<Node>();
        allBars = new ArrayList<Bar>();
    }

    // this deals with selection when items are under the mouse cursor
    public void hover() {
        selected_nodes.clear();
        for(Bar b : this.allBars) {
            if(b.isHover(mouseX, mouseY)) {
                for(int id : b.indices) {
                    selected_nodes.add(id);
                }
            }
        }
    }

    // handle sending messages to the Controller when a rectangle is selected
    public ArrayList<Integer> handleThisArea(Rectangle rect) {
        // this rectangle holds the _pixel_ coordinates of the selection rectangle 
        //Rectangle rectSub = getIntersectRegion(rect);
        ArrayList<Integer> ids = new ArrayList<Integer>();
        for (Bar b : this.allBars) {
            if(b.withinArea(rect)) {
                println("WITHIN");
                for (int id : b.indices) {
                    ids.add(id);
                }
            }
        }


       return ids;
    }

    private void setDims(float _leftX, float _leftY, float _w, float _h) {
        this.leftX = _leftX;
        this.leftY = _leftY;
        this.w = _w;
        this.h = _h;
        this.topGap = this.h * .05;
        this.bottom = this.leftY + this.h;
        this.barHeight = this.bottom - this.topGap;
    }


    ArrayList<Bar> makeBarsForCollection(HashMap<String, ArrayList<Integer>> collection,
                                         float currentY, float currentX, float barWidth) {

        ArrayList<Bar> bars = new ArrayList<Bar>();
        float initRed = 231, initGreen = 232, initBlue = 163;
        for(Entry<String, ArrayList<Integer>> e : collection.entrySet()) {
            String title = e.getKey();
            float thisHeight = (float)e.getValue().size() / (float)this.my_nodes.size();
            thisHeight *= this.barHeight;
            color c = color(initRed, initGreen, initBlue);
            initRed -= 30;
            initGreen -= 30;
            initBlue -= 30;
            Bar b = new Bar(currentX, currentY, barWidth, thisHeight,
                            e.getValue(), title, c);
            currentY += thisHeight;
            bars.add(b);
        }
        return bars;
    }

    ArrayList<Bar> makeBars() {
        ArrayList<Bar> bars = new ArrayList<Bar>();
        float barWidth = (this.w * .8) / 3;
        float widthGap = (this.w - (3 * barWidth)) / 4;
        float currentX = this.leftX + widthGap;
        float currentY = this.leftY + this.topGap;
        rectMode(CORNER);

        bars.addAll(makeBarsForCollection(this.operations, currentY, currentX, barWidth));
        currentX += barWidth + widthGap;
        bars.addAll(makeBarsForCollection(this.syslogs, currentY, currentX, barWidth));
        currentX += barWidth + widthGap;
        bars.addAll(makeBarsForCollection(this.protocols, currentY, currentX, barWidth));

        return bars;
    }

    public void display(float _leftX, float _leftY, float _w, float _h) {
        setDims(_leftX, _leftY, _w, _h);
        
        pushStyle();
        //TODO: 
        setData();
        allBars.clear();
        allBars = makeBars();


        for(Bar b : allBars) {
            b.display();
        }
        popStyle();
    }

    /*
    public StackedView setXYIndice(int x, int y) {
        this.xIndex = x;
        this.yIndex = y;
        return this;
    }
    */

    // set the indice of columns that this view can see
    public StackedView setData() {
        this.my_nodes.clear();
        if (selected_nodes.isEmpty()) {
           for(Node n : nodes) {
                this.my_nodes.add(new Node(n));
           }
        } else {
            for(Node n : nodes) {
                if(selected_nodes.contains(n.id)) {
                    this.my_nodes.add(new Node(n));
                }
            }
        }
        
        operations = new HashMap<String, ArrayList<Integer>>();
        syslogs = new HashMap<String, ArrayList<Integer>>();
        protocols = new HashMap<String, ArrayList<Integer>>();

        for(Node n : this.my_nodes) {
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

    /*
    public StackedView setTitles(String xStr, String yStr) {
        this.xTitle = xStr;
        this.yTitle = yStr;
        return this;
    }
    (/

    /*
    public StackedView initXYRange() {
        xMin = 0;//min(xArray);
        xMax = max(xArray) * 1.2;
        yMin = 0;//min(yArray);
        yMax = max(yArray) * 1.2;

        return this;
    }
    */

    /*
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
    */

}


class Bar {
    float x, y;
    float w, h;
    String title;
    color c;
    ArrayList<Integer> indices;


    Bar(float x_, float y_, float w_, float h_, ArrayList<Integer> inds,
         String title_, color c_) {
        indices = new ArrayList<Integer>();
        this.x = x_;
        this.y = y_;
        this.w = w_;
        this.h = h_;
        this.title = title_;
        this.c = c_;

        //swag
        for(int i : inds) {
            indices.add(i);
        }
    }

    void display() {
        rectMode(CORNER);
        fill(this.c);
        rect(this.x, this.y, this.w, this.h);
        fill(color(0));
        textAlign(LEFT, TOP);
        text(this.title + ": " + this.indices.size(), 
             this.x, this.y,
             this.w, this.h);
    }

    boolean isHover(float mousex, float mousey) {
        if ( mousex > this.x && mousex < this.x + this.w) {
            if (mousey < this.y + this.h && mousey > this.y) {
                return true;
            }
        }
        return false;    
    }

    boolean withinArea(Rectangle r) {
       return this.x > r.p1.x &&
              this.x + this.y < r.p2.x && 
              this.y > r.p1.y &&
              this.y + this.h < r.p2.y;
    }
}
