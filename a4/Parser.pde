import java.util.Date;
import java.text.SimpleDateFormat;
class Node {
/* The format of the csv file, for quick reference */
//Time,       Source IP,      Source port,    Destination IP,     Destination port,   Syslog priority,    Operation,  Protocol
//8:52:50,    *.2.130-140,    4000-5000,      *.1.0-10,           0-1000,             Info,               Built,      TCP
//
    int id;                 // ID of Node
    Date time;              // Time of transmission
    String sIP;             // Source IP
    String sPort;           // Source Port
    String dIP;             // Destination IP
    String dPort;           // Destination Port
    String sysPriority;     // Syslog Priority
    String op;              // Operation 
    String prot;            // Protocol of transmission
    SimpleDateFormat sdf;   // Date Formatter, for reading in and printing

    Node (int _id, String _time, String _sIP, String _sPort, String _dIP, String _dPort, String _sysPriority, String _op, String _prot) {
        this.sdf = new SimpleDateFormat("HH:mm:ss");
        try {
            this.time = sdf.parse(_time); 
        } catch (Exception e) {
            e.printStackTrace();
        }
        this.id = _id;
        this.sIP = _sIP;
        this.sPort = _sPort;
        this.dIP = _dIP;
        this.dPort = _dPort;
        this.sysPriority = _sysPriority;
        this.op = _op;
        this.prot = _prot;
    }

    Node(Node n) {
        this.id = n.id;
        this.time = n.time;
        this.sIP = n.sIP;
        this.sPort = n.sPort;
        this.dIP = n.dIP;
        this.dPort = n.dPort;
        this.sysPriority = n.sysPriority;
        this.op = n.op;
        this.prot = n.prot;
        this.sdf = n.sdf;
    }

    /* converts to String in the format:
     * Node ID at HH:MM:SS: sourceIP -> destIP
     * So,
     * Node 0 at 12:30:17: .1.0-10 -> *.2.140-150
     */
    String toString() {
        String timeString = sdf.format(this.time);
        return String.format("Node %d at %s: %s -> %s", this.id, timeString, this.sIP, this.dIP);
    }
}

class Parser {
    String file_name;
    Table table;
    ArrayList<Node> nodes; 
    HashSet<String> destinations;
    ArrayList<fNode> fNodes;

    
    /*Initialize the parser, but don't the actual parsing yet*/
    Parser(String _file_name) {
        this.file_name = _file_name;
        this.table = loadTable(this.file_name, "header");
        nodes = new ArrayList<Node>();
        destinations = new HashSet<String>();
        fNodes = new ArrayList<fNode>();
    }

    /* 
     * Go through table and create new node representing each row.
     * Build a list of these nodes.
     */ 
    ArrayList<Node> parse() {
        int id_incrementer = 0;
        for(TableRow row : this.table.rows()) {
            String time = row.getString("Time");
            String sIP = row.getString("Source IP");
            String sPort = row.getString("Source port");
            String dIP = row.getString("Destination IP");
            String dPort = row.getString("Destination port");
            String sysPriority = row.getString("Syslog priority");
            String op = row.getString("Operation");
            String prot = row.getString("Protocol");
            Node n = new Node(id_incrementer,
                              time,
                              sIP,
                              sPort,
                              dIP,
                              dPort,
                              sysPriority,
                              op,
                              prot);
            if (! destinations.contains(dIP)) {
                println("DOES NOT CONTAIN " + dIP);
                fNodes.add(new fNode(id_incrementer, dIP, MASS_CONSTANT));
            }
            id_incrementer++;

            nodes.add(n);
        }
        return nodes;
    }

    ArrayList<fNode> getDestinations() {
        return fNodes;
    }
}
