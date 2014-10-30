class VerticalLine {
    float min;
    float max;
    String title;
    float x;

    VerticalLine(float _min, float _max, String _title) {
        this.min = _min;
        this.max = _max;
        this.title = _title;
    }

    void setX(float _x) {
        this.x = _x;
    }

    float getYPos(float val) {
        float top = height * .1;
        float bottom = height * .9;
        float pos = map(val, this.min, this.max, top, bottom);
        return pos;
    }

    void drawLine() {
        float top = height * .1;
        float bottom = height * .9;
        strokeWeight(10);
        line(x, bottom, x, top);
        strokeWeight(1);
    }

    String toString() {
        return String.format("%s: %f -> %f", 
                             this.title, 
                             this.min, 
                             this.max);
    }
}
