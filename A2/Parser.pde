import java.util.LinkedHashMap;
import java.util.HashMap;

class Parser {
    String[] columnNames;
    String xTitle;
    LinkedHashMap<String, HashMap<String, Float>> labelToAttrib;
    HashMap<String, Float> totalSums;

    Parser( String filename) {
        Table t = loadTable(filename, "header");
        this.labelToAttrib = new LinkedHashMap<String, HashMap<String, Float>>();
        this.totalSums = new HashMap<String, Float>();
        String label; 
        HashMap<String, Float> attribs;

        /*
         * getColumnTitles is undocumented in processing. But it seems to work.
         * The first column title in the csv is the title of the labels,
         * so we don't want to use that when we're getting values.
         */
        this.columnNames = t.getColumnTitles();
        this.xTitle = this.columnNames[0];

        for (TableRow row : t.rows()) {
            attribs = new HashMap<String, Float>();
            /* Get the label of the row - "Dog" in our example */
            label = row.getString(xTitle);

            /*
             * Again, because first thing is the title of the label, we don't 
             *  want it.
             */
            for (int i = 1; i < columnNames.length; i++) {
                /* 
                 * Get key and value to put in the attribute map
                 *   "Lenth" and 4.0 in our example. 
                 * Go through all of the column names and do this.
                 */
                String keyName = this.columnNames[i];
                float value = row.getFloat(keyName);

                /* Build the 'attributes' Mapping */
                attribs.put(keyName, value);

                /*
                 * Basic counter implementation to keep track of the 
                 * total sum for any given column
                 */
                if (this.totalSums.containsKey(keyName)) {
                    this.totalSums.put(keyName, attribs.get(keyName) + value);
                } else {
                    this.totalSums.put(keyName, value);
                }
            }

            /* 
             *  In the outer hashmap, set the label to point to its attributes 
             */
            this.labelToAttrib.put(label, attribs);
        }
    }
}
