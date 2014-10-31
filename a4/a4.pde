import java.util.HashSet;
StackedView stackedView;
void setup() {
    size(600, 600);
    selected_nodes = new HashSet<Integer>();
    stackedView = new StackedView();
    Parser parser = new Parser("data_aggregate.csv");
    nodes = parser.parse();
    println("PARSED");

}

void draw() {
    background(255);
    stackedView.display(0, 0, width, height);
}
