/** the first element of is the min value of the column
 ** the second element of is the max value of the column
 **/

float[] rangeTempValue = {0, 1};  // slider of temp 
float[] rangeHumidityValue = {0, 1}; // slider of humidity 
float[] rangeWindValue = {0, 1}; // slider of wind 

/**
 * this function is called before initializing the interface
 */
void initSetting() {
    /** Finish this
     **
     ** initialize those three arrays
     ** initialize the first element of each array to the min value of the column
     ** initialize the second element of each array to the max value of the column
     **/

    String sql = null;
    ResultSet rs = null;
     
    try {
        // submit the sql query and get a ResultSet from the database
        String temps = "MAX(temp) AS MaxTemp, MIN(temp) as MinTemp, ";
        String humids = "MAX(humidity) AS MaxHumid, MIN(humidity) as MinHumid, ";
        String winds = "MAX(wind) AS MaxWind, MIN(wind) as MinWind";
        sql = "SELECT " + temps + humids + winds + " FROM forestfire";
        rs = (ResultSet) DBHandler.exeQuery(sql);
        while(rs.next()) {
            rangeTempValue[0] = rs.getInt("MinTemp");
            rangeTempValue[1] = rs.getInt("MaxTemp");

            rangeHumidityValue[0] = rs.getInt("MinHumid");
            rangeHumidityValue[1] = rs.getInt("MaxHumid");


            rangeWindValue[0] = rs.getInt("MinWind");
            rangeWindValue[1] = rs.getInt("MaxWind");

        }

    } catch (Exception e) {
        // should be a java.lang.NullPointerException here when rs is empty
        e.printStackTrace();
    } finally {
        closeThisResultSet(rs);
    }
}
