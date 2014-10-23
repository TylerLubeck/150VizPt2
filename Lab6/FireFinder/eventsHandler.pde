import java.sql.ResultSet;

String table_name = "forestfire";


class DataPoint {
    float X;
    float Y;
    String month, day;
    float temp, hum, wind;

    DataPoint(float _X, float _Y, String _month, String _day, float _temp, float _hum, float _wind) {
        this.X = _X;
        this.Y = _Y;
        this.month = _month;
        this.day = _day;
        this.temp = _temp;
        this.hum = _hum;
        this.wind = _wind;
    }
}

ArrayList<DataPoint> data = new ArrayList<DataPoint>();

/**
 * @author: Fumeng Yang
 * @since: 2014
 * we handle the events from the interface for you
 */

void controlEvent(ControlEvent theEvent) {
    if (interfaceReady) {
        if (theEvent.isFrom("checkboxMon") ||
            theEvent.isFrom("checkboxDay")) {
            submitQuery();
        }
        if (theEvent.isFrom("Temp") ||
            theEvent.isFrom("Humidity") ||
            theEvent.isFrom("Wind")) {
            queryReady = true;
        }

        if (theEvent.isFrom("Close")) {
            closeAll();
        }
    }
}

/**
 * generate and submit a query when mouse is released.
 * don't worry about this method
 */
void mouseReleased() {
    if (queryReady == true) {
        submitQuery();
        queryReady = false;
    }
}

void submitQuery() {
    /**
     ** Finish this
     **/

    /** extract information from the interface and generate a SQL
     ** use int checkboxMon.getItems().size() to get the number of items in checkboxMon
     ** use boolean checkboxMon.getState(index) to check if an item is checked
     ** use String checkboxMon.getItem(index).getName() to get the name of an item
     **
     ** checkboxDay (Mon-Sun) is similar with checkboxMon
     **/
    String months = "";
    for(int i = 0; i < checkboxMon.getItems().size(); i++) {
        if(checkboxMon.getState(i)) {
            String month = checkboxMon.getItem(i).getName();
            if (months.length() > 0) {
                months += ",'" + month.toLowerCase() + "'";
            } else {
                months += "'" + month.toLowerCase() + "'";
            }
        }
    }

    String days = "";
    for(int i = 0; i < checkboxDay.getItems().size(); i++) {
        if(checkboxDay.getState(i)) {
            String day = checkboxDay.getItem(i).getName();
            if (days.length() > 0) {
                days += ",'" + day.toLowerCase() + "'";
            } else {
                days += "'" + day.toLowerCase() + "'";
            }
        }
    }

//    println(days);

    /** use getHighValue() to get the upper value of the current selected interval
     ** use getLowValue() to get the lower value
     **
     ** rangeHumidity and rangeWind are similar with rangeTemp
     **/
    float maxTemp = rangeTemp.getHighValue();
    float minTemp = rangeTemp.getLowValue();

    float maxHumid = rangeHumidity.getHighValue();
    float minHumid = rangeHumidity.getLowValue();

    float maxWind = rangeWind.getHighValue();
    float minWind = rangeWind.getLowValue();

    /** Finish this
     **
     ** finish the sql
     ** do read information from the ResultSet
     **/
    String sql = "SELECT X,Y, month, day, temp, humidity, wind FROM forestfire WHERE month in (" + months + ") AND day in (" + days + ") ";
    sql += "AND temp BETWEEN " + minTemp + " AND " + maxTemp;
    sql += " AND wind BETWEEN " + minWind + " AND " + maxWind;
    sql += " AND humidity BETWEEN " + minHumid + " AND " + maxHumid;
    ResultSet rs = null;

    data.clear();

    try {
        // submit the sql query and get a ResultSet from the database
       rs  = (ResultSet) DBHandler.exeQuery(sql);
        
       while(rs.next()) {
//            println("(" + rs.getFloat("X") + "," + rs.getFloat("Y") + ")");
            DataPoint p = new DataPoint(rs.getFloat("X"), rs.getFloat("Y"), rs.getString("month"), 
                  rs.getString("day"), rs.getFloat("temp"), rs.getFloat("humidity"), rs.getFloat("wind"));
            data.add(p);
       }

    } catch (Exception e) {
        // should be a java.lang.NullPointerException here when rs is empty
        e.printStackTrace();
    } finally {
        closeThisResultSet(rs);
    }
}

void closeThisResultSet(ResultSet rs) {
    if(rs == null){
        return;
    }
    try {
        rs.close();
    } catch (Exception ex) {
        ex.printStackTrace();
    }
}

void closeAll() {
    DBHandler.closeConnection();
    frame.dispose();
    exit();
}
