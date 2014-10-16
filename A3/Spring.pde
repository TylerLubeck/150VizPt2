class Spring {
	double springL;

	Spring(double sprL) {
		this.springL = sprL;
	}

	double getForce(float k, float cur_length) {
		return (this.springL - cur_length) * k;
	}
}
