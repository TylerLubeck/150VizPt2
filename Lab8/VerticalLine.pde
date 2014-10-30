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

    String toString() {
        return String.format("%s: %f -> %f", 
                             this.title, 
                             this.min, 
                             this.max);
    }
}
