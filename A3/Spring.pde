class Spring {
	PVector springL;

	Spring(double sprL) {
		this.springL = new PVector(1f, 1f);
		this.springL.mult((float)sprL);
	}

	PVector getForce(float k, PVector curr_dir) {
		PVector temp = PVector.sub(this.springL, curr_dir);
		temp.mult(k);
		return temp;

	}
}
