class Node implements Comparable<Node>{
    final float RADIUS_FACTOR = 3;
	int id, mass;
	ArrayList<Node> neighbors;
	ArrayList<Spring> springs;
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
    Textbox label_node;

	Node() {
        this(-1, -1);
	}


	Node(int id) {
        this(id, -1);
	}


	Node(int id, int mass) {
		this.id = id;
        this.mass = mass;
        this.r = red(id); this.g = green(id); this.b = blue(id);
        this.intersected = false;
        
        float _X = random(0, width - this.radius);
        float _Y = random(0, height - this.radius);
        this.position = new PVector(_X, _Y);
        
        this.fillColor = COLOR_DEFAULT;

        this.isClickedOn = false;
        this.radius = RADIUS_FACTOR * this.mass;

        neighbors = new ArrayList<Node>();
        springs = new ArrayList<Spring>();
		
        this.netVel = new PVector(0f, 0f);
        setPos(this.position);
        String l = ("id: " + this.id + ", mass: " + this.mass);
        label_node = new Textbox(l, this.position.x, this.position.y);
        drawPosition();
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
        newX = newX > width - this.radius ? width - this.radius : newX;

        newY = newY < this.radius ? this.radius : newY;
        newY = newY > height - this.radius ? height - this.radius : newY;
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

    PVector totalSpringForces(float k_hooke) {
        PVector totalForces = new PVector(0f, 0f);
        for(int i = 0; i < this.springs.size(); i++) {
            Node neighbor = this.neighbors.get(i);
            Spring spring = this.springs.get(i);
            PVector thisForce = PVector.sub(this.position, neighbor.position);

            float currLength = dist(this.position.x, this.position.y, 
                                    neighbor.position.x, neighbor.position.y);
            currLength *= -1;

            float magnitude = currLength - spring.springL;
            magnitude *= k_hooke;


            thisForce.normalize();
            thisForce.mult(magnitude);
            
            // Get length of spring - goal length
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
            label_node.setTextPos(this.position.x, this.position.y);
            label_node.render();
        }

    }

//    void drawRelations() {
//        stroke(COLOR_STROKE);
//    	for(int i = 0; i < neighbors.size(); i++) {
//    		line(position.x, position.y, neighbors.get(i).position.x, neighbors.get(i).position.y);
//    	}
//    }

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

    int compareTo(Node other) {
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
            /* WITH NOSTROKE, MIDDLE NODE MYSTERIOUSLY LOSES RELATION
             * LINES DURING HOVER.
             * MONEY FOR WHO LEARNS WHY THE HELL THIS IS THE CASE.
             */
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
