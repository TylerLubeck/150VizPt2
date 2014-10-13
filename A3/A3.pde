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

	Parser parser = new Parser(file);
    nodeList = parser.parse();
        
}

void draw()  {
    pickbuffer = createGraphics(width, height);
    background(255);
    drawPickBuffer();

    if (keyPressed) {
        image(pickbuffer, 0, 0);
    }

    for(Node n: nodeList)  {
        n.drawRelations();
    }

    for(Node n: nodeList) {
        if (n.isClickedOn) {
            n.setPos(mouseX, mouseY);
        }

        if (n.isect(pickbuffer)) {
            n.setHighlighted(); 
        } else {
            n.unsetHighlighted();
        }
        n.drawPosition(); 
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





/* Calculate total energy of the whole node system */
float systemEnergy() {
	float universeEnergy = 0;
	for(int i = 0; i < nodeList.size(); i++) {
		universeEnergy += nodeList.get(i).kinEnergy();
	}
	return universeEnergy;
}
