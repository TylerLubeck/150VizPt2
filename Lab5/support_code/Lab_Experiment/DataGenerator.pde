class Data {
    /* Public indices of the "chosen" marked values */
    public int m1;
    public int m2;

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
         ** generate a dataset and mark two of the datapoints
         **/
        // NUM is a global varibale in support.pde
        data = new DataPoint[NUM];
        for(int i = 0; i < NUM; i++) {
            data[i] = new DataPoint(random(0.0, 100.0), false);
        }

        m1 = random(0, NUM);
        m2 = random(0, NUM);
        /* No repeat indices */
        while(m2 != m1) {
            m2 = random(0, NUM);
        }

        data[m1].setMark(true);
        data[m2].setMark(true);
    }

    /* Pass either 0 for the first marked, and 1 for the other 
     *  Returns the value of the passed index. 
     *  Will need this to get "truePerc" in Lab_Experiment"
     */
    float getMarkedVal(int num) {
        if(num != 0) {
            return data[m1];
        } else {
            return data[m2];
        }
    }
        /**
         ** finish this: the rest methods and variables you may want to use
         ** 
         **/
}
