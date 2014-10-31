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

    StackedView() {
        my_nodes = new ArrayList<Node>();
    }

    // this deals with selection when items are under the mouse cursor
    public void hover() {
        selected_nodes.clear();
        //TODO: Set selected_nodes set to be the indices of selected nodes
    }

    // handle sending messages to the Controller when a rectangle is selected
    public void handleThisArea(Rectangle rect) {
        // this rectangle holds the _pixel_ coordinates of the selection rectangle 
        //Rectangle rectSub = getIntersectRegion(rect);

        //if (rectSub != null) {
       // }
    }

    private void setDims(float _leftX, float _leftY, float _w, float _h) {
        this.leftX = _leftX;
        this.leftY = _leftY;
        this.w = _w;
        this.h = _h;
        this.topGap = this.leftY + this.h * .05;
        this.bottom = this.leftY + this.h;
        this.barHeight = this.bottom - this.topGap;
    }

    ArrayList<Bar> makeBars() {
        ArrayList<Bar> bars = new ArrayList<Bar>();
        float currentY = this.h;
        float barWidth = (this.w * .9) / this.my_nodes.size();
        float widthGap = this.w * .05;
        float currentX = this.w + widthGap;

        for(Entry<String, ArrayList<Integer>> e : operations.entrySet()) {
            String title = e.getKey();
            float thisHeight = e.getValue().size() / this.my_nodes.size();
            //currentY *= this.barHeight;
            Bar b = new Bar(currentX, currentY, barWidth, thisHeight,
                            e.getValue(), title, color(255, 0, 0));
            currentY -= thisHeight;
            bars.add(b);
        }
        
        currentY = this.h;
        currentX += barWidth + widthGap;

        for(Entry<String, ArrayList<Integer>> e : syslogs.entrySet()) {
            String title = e.getKey();
            float thisHeight = e.getValue().size() / this.my_nodes.size();
            //currentY *= this.barHeight;
            Bar b = new Bar(currentX, currentY, barWidth, thisHeight,
                            e.getValue(), title, color(255, 0, 0));
            currentY -= thisHeight;
            bars.add(b);
        }

        currentY = this.h;
        currentX += barWidth + widthGap;

        for(Entry<String, ArrayList<Integer>> e : protocols.entrySet()) {
            String title = e.getKey();
            float thisHeight = e.getValue().size() / this.my_nodes.size();
            //currentY *= this.barHeight;
            Bar b = new Bar(currentX, currentY, barWidth, thisHeight,
                            e.getValue(), title, color(255, 0, 0));
            currentY -= thisHeight;
            bars.add(b);
        }
        return bars;
    }

    public void display(float _leftX, float _leftY, float _w, float _h) {
        setDims(_leftX, _leftY, _w, _h);
        
        pushStyle();
        //TODO: 
        setData();
        ArrayList<Bar> bars = makeBars();
        println(bars);

        for(Bar b : bars) {
            b.display();
            println("DREW THE BAR");
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
        x = x_;
        y = y_;
        w = w_;
        h = h_;
        this.title = title_;
        this.c = c_;

        //swag
        for(int i : inds) {
            indices.add(i);
        }
    }

    void display() {
        fill(color(255, 0, 0));
        rect(this.x, this.y, this.w, this.h);
    }
}
