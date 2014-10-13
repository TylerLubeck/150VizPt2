class Spring {
	double springL, cur_length;

	Spring(double sprL) {
		this.springL = sprL;
	}

	float getForce() {
		return (springL - cur_length) * k;
	}
}
