class Spring {
	double springL, cur_length;

	Spring(double sprL) {
		this.springL = sprL;
	}

	double getForce() {
		return (springL - cur_length) * k;
	}
}
