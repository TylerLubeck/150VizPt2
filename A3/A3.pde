String file = "data.csv";
PGraphics pickbuffer = null;

ArrayList<Node> nodeList;
float k = 0.1;

int currentSelectedId = -1;
boolean hasBeenSelected = false;

void setup() {
    size(400, 400);
    background(255);
    frame.setResizable(true);

	//nodeList = new ArrayList<Node>();
	Parser parser = new Parser(file);
    nodeList = parser.parse();
    /* Draw all those relations right quick */
        
}

void draw()  {
    pickbuffer = createGraphics(width, height);
    background(255);
    drawPickBuffer();

    if (keyPressed) {
        image(pickbuffer, 0, 0);
    }

    for(Node n: nodeList) {
        if (n.isClickedOn) {
            n.setPos(mouseX, mouseY);
        }
        n.drawPosition();
    }

    for(int i = 0; i < nodeList.size(); i++) {
    	nodeList.get(i).drawRelations();
    }

    for(Node n: nodeList) {
        if (n.isect(pickbuffer)) {
            println("INTERSECTING WITH " + n.id);
        }
    }

}

void drawPickBuffer() {
    pickbuffer.beginDraw();

    for(Node n: nodeList) {
        n.renderISect(pickbuffer);
    }

    pickbuffer.endDraw();
}

void mousePressed() {
    for (Node n : nodeList) {
        if (n.isect(pickbuffer)) {
            n.isClickedOn = true;

        }
    }
}

void mouseReleased() {
    for (Node n : nodeList) {
        n.isClickedOn = false;
    }
}
