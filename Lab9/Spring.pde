class Spring {
	float springL;
    float currLength;

	Spring(double sprL) {
        this.springL = (float)sprL;
        this.springL *= 1/4;
	}
}
