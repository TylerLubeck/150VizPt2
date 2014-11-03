class fNode implements Comparable<fNode>{
    final float RADIUS_FACTOR = 3;
	int id, mass;
    String myIP;
	ArrayList<Edge> edges;
    float radius;
    float r, g, b;
    boolean isClickedOn;
    PVector netVel;
    PVector position;
    color COLOR_HIGHLIGHT;
    color COLOR_DEFAULT;
    color fillColor;
    color COLOR_STROKE;
    boolean intersected;
    Textbox label_fnode;
    ArrayList<fNode> neighbors;
    float w, h;

	fNode() {
        this(-1, "", -1, 10, 10);
	}

	fNode(int id) {
        this(id, "", -1, 10, 10);
	}

	fNode(int id, String myIP_, int mass, float _w, float _h) {
        this.w = _w;
        this.h = _h;
		this.id = id;
        this.myIP = myIP_;
        this.mass = mass;
        this.r = red(id); this.g = green(id); this.b = blue(id);
        this.intersected = false;
        
        float _X = random(0, this.w - this.radius);
        float _Y = random(0, this.h - this.radius);
        this.position = new PVector(_X, _Y);
        
        this.fillColor = COLOR_DEFAULT;

        this.isClickedOn = false;
        this.radius = RADIUS_FACTOR * this.mass;

        neighbors = new ArrayList<fNode>();
        edges = new ArrayList<Edge>();
		
        this.netVel = new PVector(0f, 0f);
        setPos(this.position);
        String l = ("ip: " + this.myIP + ", mass: " + this.mass);
        label_fnode = new Textbox(l, this.position.x, this.position.y);
        drawPosition();
	}

    String toString() {
        return String.format("ip: %s, mass: %d", this.myIP, this.mass);
    }

    void setPos(PVector pos) {
        setPos(pos.x, pos.y);
    }

    void setColors() {
        int cf = this.mass * 5;
        COLOR_HIGHLIGHT = color(27, 166 - cf, 166);
        COLOR_DEFAULT = color(27, 112 - cf, 166 -  cf);
        COLOR_STROKE = color(52, 92, 166);
    }

    void setPos(float newX, float newY) {

        /* Bound the circles */
        newX = newX < this.radius ? this.radius : newX;
        newX = newX > this.w - this.radius ? this.w - this.radius : newX;

        newY = newY < this.radius ? this.radius : newY;
        newY = newY > this.h - this.radius ? this.h - this.radius : newY;
        /*******/

        this.position.set(newX, newY);
    }

    void updatePosition(float currTime, PVector force) {
        PVector acceleration = PVector.div(force, this.mass);
        
        /* v = vo + a * t */
        acceleration.mult(currTime);
        netVel.add(acceleration);
        netVel.mult(DAMPENING);
        
        /* s = so + vt + .5 a t^2 */
        PVector at = PVector.mult(acceleration, .5 * currTime);
        PVector vt = PVector.mult(netVel, currTime);

        PVector newPos = PVector.add(this.position, vt);
        newPos.add(at);

        setPos(newPos);
        
    }

    PVector totalEdgeForces(float k_hooke) {
        PVector totalForces = new PVector(0f, 0f);
        for(int i = 0; i < this.edges.size(); i++) {
            fNode neighbor = this.neighbors.get(i);
            Edge edge = this.edges.get(i);
            PVector thisForce = PVector.sub(this.position, neighbor.position);

            float currLength = dist(this.position.x, this.position.y, 
                                    neighbor.position.x, neighbor.position.y);
            currLength *= -1;

            float magnitude = currLength - edge.springL;
            magnitude *= k_hooke;


            thisForce.normalize();
            thisForce.mult(magnitude);
            
            // Get length of Edge - goal length
            totalForces.add(thisForce);
        }
        return totalForces;
    }

    void drawPosition() {
        fill(this.fillColor);
        stroke(COLOR_STROKE);
        ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
        fill(this.fillColor);
        if (this.intersected) {
            label_fnode.setTextPos(this.position.x, this.position.y);
            label_fnode.render();
        }

    }

    void drawRelations() {
      stroke(COLOR_STROKE);
      for(int i = 0; i < neighbors.size(); i++) {
                float x1, x2, y1, y2, L, dX, dY;
                dX = neighbors.get(i).position.x - this.position.x;
                dY = neighbors.get(i).position.y - this.position.y;
                L = sqrt((dX * dX) + (dY * dY));
                x1 = dX * this.radius / L + this.position.x;
                y1 = dY * this.radius / L + this.position.y;
                x2 = dX * (L-neighbors.get(i).radius)/L + this.position.x;
                y2 = dY * (L-neighbors.get(i).radius)/L + this.position.y;
                println(this.edges.size());
         //       strokeWeight(this.edges.get(i).edgeWeight);
                line(x1, y1, x2, y2);
      }
    }

    void renderISect(PGraphics pg) {
        pg.fill(this.r, this.g, this.b);
        pg.stroke(this.r, this.g, this.b);
        pg.strokeWeight(3);
        pg.ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
    }

    void renderSelected() {
        strokeWeight(3);
        stroke(this.r, this.g, this.b);
        fill(this.r, this.g, this.b, 128);
        ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
        
    }

    boolean isect(PGraphics img)  {
        if (img.get(mouseX, mouseY) == color(this.r, this.g, this.b)) {
            this.intersected = true;
            return true;
        }
        this.intersected = false;
        return false;
    }

    float kinEnergy() {
        setColors();
    	return (.5 * this.mass * netVel.mag());
    }

    void setHighlighted() {
        this.fillColor = COLOR_HIGHLIGHT;
    }

    void unsetHighlighted() {
        this.fillColor = COLOR_DEFAULT;

    }

    int compareTo(fNode other) {
        return other.mass - this.mass;
    }

    class Textbox {
        String label;
        float x, y;
        int OPACITY = 50;
        Textbox(String label_, float x_, float y_) {
            this.label = label_;
            x = x_;
            y = y_;
            render();
        }

        void render()
        {
            pushMatrix();
            fill(255, 255, 255, OPACITY);
            rectMode(CORNER);
            noStroke();
            rect(x - textWidth(label)/2, y - 16, textWidth(label), 20);
            textAlign(CENTER);
            fill(0);
            text(label, x, y);
            popMatrix();
        }

        void setTextPos(float x_, float y_) {
              x = x_;
              y = y_;
        }
    }
}
