class Node {
    final float RADIUS_FACTOR = 3;
	int id, mass;
	ArrayList<Node> neighbors;
	ArrayList<Spring> springs;
    float radius;
    float r, g, b;
    boolean isClickedOn;
    PVector netVel;
    PVector position;
    color COLOR_HIGHLIGHT = color(27, 166, 166);
    color COLOR_DEFAULT = color(27, 112, 166);
    color fillColor;
    color COLOR_STROKE = color(52, 92, 166);

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
        drawPosition();
	}

    void setPos(PVector pos) {
        setPos(pos.x, pos.y);
    }

    void setPos(float newX, float newY) {

        newX = newX < this.radius ? this.radius : newX;
        newX = newX > width - this.radius ? width - this.radius : newX;

        newY = newY < this.radius ? this.radius : newY;
        newY = newY > height - this.radius ? height - this.radius : newY;

        this.position.set(newX, newY);
    }


    void updatePosition(float currTime, PVector force) {
        PVector acceleration = PVector.div(force, this.mass);
        //println("acceleration: " + acceleration);
        /* v = vo + a * t */
        acceleration.mult(currTime);
        netVel.add(acceleration);
        netVel.mult(DAMPENING);
        //float velX_ = netVel.x;
        //float velY_ = netVel.y;
        /* Because we are using v1 not v0 */
        /* s = so + vt - .5 a t^2 */

        //println("Force: " + force);
       // PVector vt = PVector.mult(netVel, currTime);
        //println("vt: " + vt);
        
        PVector at = PVector.mult(acceleration, .5 * currTime);
        //println("at: " + at);
        PVector vt = PVector.mult(netVel, currTime);
        /* s = so + vt + 
        float posX = this.position.x + velX_ * currTime + 
                     .5 * (acceleration.x) * sq(currTime);
        float posY = this.position.y + velY_ * currTime + 
                     .5 * (acceleration.y) * sq(currTime);
         */

        PVector newPos = PVector.add(this.position, vt);
        newPos.add(at);
        //println("NODE: " + this.id + ": " + newPos);

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
        stroke(COLOR_STROKE);
    }

    void drawRelations() {
    	for(int i = 0; i < neighbors.size(); i++) {
    		line(position.x, position.y, neighbors.get(i).position.x, neighbors.get(i).position.y);
    	}
    }

    void renderISect(PGraphics pg) {
        pg.fill(this.r, this.g, this.b);
        pg.stroke(this.r, this.g, this.b);
        pg.strokeWeight(5);
        pg.ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
    }

    void renderSelected() {
        strokeWeight(1);
        stroke(this.r, this.g, this.b);
        fill(this.r, this.g, this.b, 128);
        ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
    }

    boolean isect(PGraphics img)  {
        if (img.get(mouseX, mouseY) == color(this.r, this.g, this.b)) {
            return true;
        }
        return false;
    }

    float kinEnergy() {
    	return (.5 * this.mass * netVel.mag());
    }


    void setHighlighted() {
        this.fillColor = COLOR_HIGHLIGHT;
    }

    void unsetHighlighted() {
        this.fillColor = COLOR_DEFAULT;
    }
}
