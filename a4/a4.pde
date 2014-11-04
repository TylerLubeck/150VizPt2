import java.util.HashSet;
//StackedView stackedView;
void setup() {
    size(1200, 600);
    frame.setResizable(true);
    frame.setTitle("CMV");
    Parser parser = new Parser("data_aggregate.csv");
    nodes = parser.parse();
    fNodes = parser.getDestinations();
    hover = true;
    logAnd = logOr = false;
    selected_nodes = new HashSet<Integer>();
    selectedAreas = new ArrayList<Rectangle>();
    stackedView = new StackedView();
    heatmap = new Heatmap();
    forceView = new ForceView();
    buttonFrame = new ButtonFrame();
}

void draw() {
    background(255);
    //*
    buttonFrame.display(width * 0.75, 0, width * 0.25, height * 0.15);
    stackedView.display(width * 0.75, height * 0.15, width * 0.25, height * 0.60);
    heatmap.display(0, height * 0.75, width, height * .25);
    forceView.display(0, 0, width * 0.75, height * .7);
    //forceView.display(0, 0, width, height);
    //forceView.display(0, 0, width * 0.75, height * 0.75);
    drawSelectedArea();
}

public void drawSelectedArea() {
        pushStyle();
        fill(selectColor);
        stroke(selectColor);
        rectMode(CORNER);
        if (selectedArea != null) {
            rect(selectedArea.p1.x, selectedArea.p1.y,
                selectedArea.p2.x - selectedArea.p1.x, selectedArea.p2.y - selectedArea.p1.y);
        }
        if (!selectedAreas.isEmpty()) {
            for (Rectangle area : selectedAreas) {
              rect(area.p1.x, area.p1.y, area.p2.x - area.p1.x, area.p2.y - area.p1.y);
            }
        }
        popStyle();
    }

boolean inStackedView(float x, float y) {
    return x >width * 0.75 && x < width 
            && y > height * 0.15 && y < height  * 0.75;
}

boolean inHeatmap(float x, float y) {
    return y > height * 0.75 && y < height;
}

boolean inForceView(float x, float y) {
    return x > 0 && x < width * 0.75 && y > 0 && y < height * 0.75;
}

boolean inButtonFrame(float x, float y) {
    return x > width * 0.75 && x < width 
            && y > 0 && y < height  * 0.15;
}

public void setSelectedArea(float x, float y, float x1, float y1) {
        if ((inStackedView(x, y) && inStackedView(x1,y1)) || 
            (inHeatmap(x, y) && inHeatmap(x1, y1)) || 
            (inForceView(x, y) && inForceView(x1, y1))) {
              selectedArea = new Rectangle(x, y, x1, y1);
        }
        else if (inStackedView(x, y)) {
            x1 = x1 < width * 0.75 ? width * 0.75 : x1;
            y1 = y1 < height * 0.15 ? height * 0.15 : y1;
            y1 = y1 > height * 0.75 ? height * 0.75 : y1;
            selectedArea = new Rectangle(x, y, x1, y1);
        }
        else if (inHeatmap(x, y)) {
            y1 = y1 < height * 0.75 ? height * 0.75 : y1;
            selectedArea = new Rectangle(x, y, x1, y1);
        }
        
        else if (inForceView(x, y)) {
            x1 = x1 > width * 0.75 ? width * 0.75 : x1;
            y1 = y1 > height * 0.75 ? height * 0.75 : y1;
            selectedArea = new Rectangle(x, y, x1, y1);
        }
    }
    
    
void dealWithArea() {
    ArrayList<Integer> temp;
    if (hover || logOr) {
        if (! selectedAreas.isEmpty()) {
               for (Rectangle rect : selectedAreas) {
                   temp = stackedView.handleThisArea(rect);
                   if (temp != null) {
                       selected_nodes.addAll(temp);
                   }
                   temp = heatmap.handleThisArea(rect);
                   if (temp != null) {
                       selected_nodes.addAll(temp);
                   }
                   temp = forceView.handleThisArea(rect);
                   if (temp != null) {
                       selected_nodes.addAll(temp);
                   }
               }
       }
       if (selectedArea != null) {
           temp = stackedView.handleThisArea(selectedArea);
           if (temp != null) {
               selected_nodes.addAll(temp);
           }
           temp = heatmap.handleThisArea(selectedArea);
           if (temp != null) {
               selected_nodes.addAll(temp);
           }
           temp = forceView.handleThisArea(selectedArea);
           if (temp != null) {
               selected_nodes.addAll(temp);
           }
       }
    }
    else {
      selected_nodes.clear();
        if (! selectedAreas.isEmpty()) {
               for (Rectangle rect : selectedAreas) {
                   temp = stackedView.handleThisArea(rect);
                   if (temp != null && ! temp.isEmpty()) {
                       if (selected_nodes.isEmpty()) {
                           selected_nodes.addAll(temp);
                       }
                       else {
                           selected_nodes.retainAll(temp);
                      }    
                   }
                   temp = heatmap.handleThisArea(rect);
                   if (temp != null && !temp.isEmpty()) {
                       if (selected_nodes.isEmpty()) {
                           selected_nodes.addAll(temp);
                       }
                       else {
                           selected_nodes.retainAll(temp);
                       }    
                   }
                   temp = forceView.handleThisArea(rect);
                   if (temp != null && !temp.isEmpty()) {
                       if (selected_nodes.isEmpty()) {
                           selected_nodes.addAll(temp);
                       }
                       else {
                           selected_nodes.retainAll(temp);
                       }    
                   }
               }
         }
         if (selectedArea != null) {
             temp = stackedView.handleThisArea(selectedArea);
             if (temp != null && !temp.isEmpty()) {
                 if (selected_nodes.isEmpty()) {
                     selected_nodes.addAll(temp);
                 }
                 else {
                     selected_nodes.retainAll(temp);
                 }    
             }
             temp = heatmap.handleThisArea(selectedArea);
             if (temp != null && !temp.isEmpty()) {
                 if (selected_nodes.isEmpty()) {
                     selected_nodes.addAll(temp);
                 }
                 else {
                     selected_nodes.retainAll(temp);
                 }    
             }
             temp = forceView.handleThisArea(selectedArea);
             if (temp != null && !temp.isEmpty()) {
                 if (selected_nodes.isEmpty()) {
                     selected_nodes.addAll(temp);
                 }
                 else {
                     selected_nodes.retainAll(temp);
                 }    
             }
         }
    }
        
}


void mouseMoved(MouseEvent e) {
   if (hover) {
       selected_nodes.clear();
       if(inStackedView(mouseX, mouseY)) {
           stackedView.hover();
       }
       else if (inHeatmap(mouseX, mouseY)) {
           heatmap.hover();
       }
       else if (inForceView(mouseX, mouseY)) {
           forceView.hover();
       }
   }
   dealWithArea();
}

void mousePressed(MouseEvent e) {
    if (e.getButton() == RIGHT) {
        selected_nodes.clear();
        selectedArea = null;
        selectedAreas.clear();
        return;
    }
    if (hover) {
        selected_nodes.clear();
        selectedAreas.clear();
        pressPos = new PVector(mouseX, mouseY);
        setSelectedArea(pressPos.x, pressPos.y, mouseX, mouseY);
    }
    else if (logAnd || logOr) {
        pressPos = new PVector(mouseX, mouseY);
        setSelectedArea(pressPos.x, pressPos.y, mouseX, mouseY);
    }
    dealWithArea();
}

void mouseDragged(MouseEvent e) {
    if (e.getButton() == RIGHT) {
        selected_nodes.clear();
        selectedArea = null;
        selectedAreas.clear();
        return;
    }
    setSelectedArea(pressPos.x, pressPos.y, mouseX, mouseY);
    dealWithArea();
}

void mouseReleased(MouseEvent e) {
    if (e.getButton() == RIGHT) {
        selected_nodes.clear();
        selectedArea = null;
        selectedAreas.clear();
        return;
    }
    else if(inButtonFrame(mouseX, mouseY)) {
       buttonFrame.interpretClick();
       return;
    }
   
    setSelectedArea(pressPos.x, pressPos.y, mouseX, mouseY);
    selectedAreas.add(selectedArea);
    selectedArea = null;
    pressPos = null;
    dealWithArea();
}

