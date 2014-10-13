class Data {
    class DataPoint {
        private float value = -1;
        private boolean marked = false;

        DataPoint(float f, boolean m) {
            this.value = f;
            this.marked = m;
        }

        boolean isMarked() {
            return marked;
        }

        void setMark(boolean b) {
            this.marked = b;
        }

        float getValue() {
            return this.value;
        }
    }

    private DataPoint[] data = null;

    Data() {
        /**
         ** finish this: how to generate a dataset and mark two of the datapoints
         ** 
         **/
        // NUM is a global varibale in support.pde
        data = new DataPoint[NUM];
        for(int i = 0; i < NUM; i++) {
            data[i] = new DataPoint(random(0.0, 100.0), false);
        }

        int m1 = int(random(0, int(NUM)));
        int m2 = int(random(0, int(NUM)));
        /* No repeat indices */
        while(m2 != m1) {
            m2 = int(random(0, NUM));
        }

        data[m1].setMark(true);
        data[m2].setMark(true);

    }
    
        /**
         ** finish this: the rest methods and variables you may want to use
         ** 
         **/
}
