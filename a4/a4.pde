import java.util.HashSet;
StackedView stackedView;
void setup() {
    Parser parser = new Parser("data_aggregate.csv");
    nodes = parser.parse();
    println("PARSED");
    selected_nodes = new HashSet<Integer>();
    stackedView = new StackedView();
    size(600, 600);

}

void draw() {
    background(255);
    stackedView.display(0, 0, width, height);
}
