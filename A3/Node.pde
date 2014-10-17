class Node {
    final float RADIUS_FACTOR = 4;
	int id, mass;
	ArrayList<Node> neighbors;
	ArrayList<Spring> springs;
    float radius;
    float r, g, b;
    boolean isClickedOn;
    PVector netVel;
    PVector position;
    color highlightColor;
    color defaultColor;
    color fillColor;

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
        
        this.highlightColor = color(255, 0, 0);
        this.defaultColor = color(0, 255, 0);
        this.fillColor = this.defaultColor;

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
        netVel.add(acceleration);
        netVel.mult(currTime);

        float velX_ = netVel.x;
        float velY_ = netVel.y;
        /* s = so + vt + .5 a t^2 */
        float posX = this.position.x + velX_ * currTime + 
                     .5 * (acceleration.x) * sq(currTime);
        float posY = this.position.y + velY_ * currTime + 
                     .5 * (acceleration.y) * sq(currTime);


        setPos(posX, posY);
    }

    PVector totalSpringForces(float k_hooke) {
        PVector totalForce = new PVector(0f,0f);
        for(int i = 0; i < springs.size(); i++) { /* Cause neighbors and springs indices line up */
            PVector dir = new PVector(this.position.x - neighbors.get(i).position.x, 
                                      this.position.y - neighbors.get(i).position.y);
            /* calculate total forces exerted by attached springs */
            totalForce.add(springs.get(i).getForce(k_hooke, dir));
        }
        println("SPRING FORCE: " + totalForce);
        return totalForce;
        //return new PVector(0f, 0f);
    }


    void drawPosition() {
        fill(this.fillColor);
        stroke(this.fillColor);
        ellipse(this.position.x, this.position.y, 2 * this.radius, 2 * this.radius);
        fill(this.defaultColor);
        stroke(this.defaultColor);
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
        this.fillColor = this.highlightColor;
    }

    void unsetHighlighted() {
        this.fillColor = this.defaultColor;
    }
}