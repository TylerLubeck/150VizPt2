class Spring {
	float springL;
    float currLength;

	Spring(double sprL) {
        this.springL = (float)sprL;
	}

    /*
	PVector getForce(float k, PVector curr_dir) {
		PVector temp = PVector.sub(this.springL, curr_dir);
		temp.mult(k);
		return temp;
	}
    */

    /*
    float getLength() {
        return dist(left.position.x, left.position.y, 
                    right.position.x, right.position.y);
    }
    */
}
