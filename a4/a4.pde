import java.util.HashSet;
//StackedView stackedView;
void setup() {
    size(1200, 600);
    frame.setResizable(true);
    frame.setTitle("CMV");
    Parser parser = new Parser("data_aggregate.csv");
    nodes = parser.parse();
    hover = true;
    logAnd = logOr = false;
    println("PARSED");
    selected_nodes = new HashSet<Integer>();
    stackedView = new StackedView();
    heatmap = new Heatmap();
    buttonFrame = new ButtonFrame();
}

void draw() {
    background(255);
    buttonFrame.display(width * 0.75, 0, width * 0.25, height * 0.15);
    stackedView.display(width * 0.75, height * 0.15, width * 0.25, height * 0.60);
    heatmap.display(0, height * 0.75, width, height * .25);
}

void mouseMoved(MouseEvent e) {
   if (hover) {
       selected_nodes.clear();
       if(inStackedView()) {
           stackedView.hover();
       }
       else if (inHeatmap()) {
           heatmap.hover(); 
       }
   }
}

boolean inStackedView() {
    return mouseX >=width * 0.75 && mouseX <= width 
            && mouseY >= height * 0.15 && mouseY <= height  * 0.75;
}

boolean inHeatmap() {
    return mouseY >= height * 0.75 && mouseY <= height;
}


void mouseClicked(MouseEvent e) {
//    contrl.cleanSelectedArea();
    pressPos = null;
}

void mouseDragged(MouseEvent e) {
    if (e.getButton() == RIGHT) {
//        contrl.cleanSelectedArea();
        return;
    }
    if (pressPos != null) {
//        contrl.setSelectedArea(pressPos.x, pressPos.y, mouseX, mouseY);
    }  
}

void mousePressed(MouseEvent e) {
//    contrl.cleanSelectedArea();
//    pressPos = new PVector(mouseX, mouseY);
//    contrl.setSelectedArea(pressPos.x, pressPos.y, mouseX, mouseY);
}
