class RelationshipNode {
    color[] colors = {
   color(199,233,180),color(127,205,187),color(65,182,196),color(44,127,184),color(37,52,148)};
  
  
    ArrayList<String> names;
    int [][] links; 
    int id, mass;
    float maxL, totalSize;
    PVector position, netVel;
    ArrayList<RelationshipNode> neighbors;
    ArrayList<Spring> springs;
    boolean isClickedOn;
    float offsetX, offsetY;
    
    RelationshipNode(int _id, ArrayList<String> _names) {
         neighbors = new ArrayList<RelationshipNode>();
         springs = new ArrayList<Spring>();
         this.id = _id;
         this.names = _names;
         Collections.sort(this.names);
         this.links = new int[this.names.size()][this.names.size()];
         this.maxL = getNameLength();
         this.totalSize = names.size() > 1 ? names.size() * SQUARE_SIZE + 2 * maxL : maxL;
         
         float x = random(0.5 * totalSize, width - 0.5 * totalSize);
         float y = random(0.5 * totalSize, height - 0.5 * totalSize);
         this.position = new PVector(x, y);
         this.mass = 1;//names.size();
         this.netVel = new PVector(0f, 0f);
         isClickedOn = false;
         offsetX = offsetY = 0;
    }
    
    void setPos(PVector pos) {
         setPos(pos.x, pos.y);  
    }
    
    void setPos(float newX, float newY) {
         if (isClickedOn) {
             newX = newX + offsetX;
             newY = newY + offsetY;
         }
         newX = newX < totalSize * 0.5 ? totalSize * 0.5 : newX;
         newX = newX > width - totalSize * 0.5 ? width - totalSize * 0.5 : newX;
         
         newY = newY < totalSize * 0.5 ? totalSize * 0.5 : newY;
         newY = newY > height - totalSize * 0.5 ? height - totalSize * 0.5 : newY;
         position.set(newX, newY);
    }
    
    void updatePosition(float currTime, PVector force) {
        PVector acceleration = PVector.div(force, this.mass);
        
        /* v = vo + a * t */
        acceleration.mult(currTime);
        netVel.add(acceleration);
        netVel.mult(DAMPENING);
        
        /* s = so + vt + .5 a t^2 */
        PVector at = PVector.mult(acceleration, .5 * currTime);
        PVector vt = PVector.mult(netVel, currTime);

        PVector newPos = PVector.add(this.position, vt);
        newPos.add(at);

        setPos(newPos);
        
    }
    
    
    PVector totalSpringForces(float k_hooke) {
        PVector totalForces = new PVector(0f, 0f);
        for(int i = 0; i < this.springs.size(); i++) {
            RelationshipNode neighbor = this.neighbors.get(i);
            Spring spring = this.springs.get(i);
            PVector thisForce = PVector.sub(this.position, neighbor.position);

            float currLength = dist(this.position.x, this.position.y, 
                                    neighbor.position.x, neighbor.position.y);
            currLength *= -1;

            float magnitude = currLength - spring.springL;
            magnitude *= k_hooke;


            thisForce.normalize();
            thisForce.mult(magnitude);
            
            // Get length of spring - goal length
            totalForces.add(thisForce);
        }
        return totalForces;
    }

    float kinEnergy() {
      return (.5 * this.mass * netVel.mag());
    }

    
    void setLink(String name1, String name2, int strength) {
         links[names.indexOf(name1)][names.indexOf(name2)] = strength;
         links[names.indexOf(name2)][names.indexOf(name1)] = strength;
    }
    
    PVector getNameLocation(PVector center, String name) {
        PVector location;
        float xdiff = position.x - center.x;
        float ydiff = position.y - center.y;
        int nameIndex = names.indexOf(name);
        if (xdiff <= 0 && abs(ydiff) <= abs(xdiff)){ // right block
            if (names.size() > 1) 
                location = new PVector(position.x + 0.5 * SQUARE_SIZE * names.size() + maxL, 
                                   position.y + SQUARE_SIZE * (nameIndex + 0.5 - names.size() * 0.5));
            else
                location = new PVector(position.x + 0.5 * maxL, position.y);
        } 
        else if (xdiff >= 0 && abs(ydiff) <= abs(xdiff)) { // left block
            if (names.size() > 1)
                location = new PVector(position.x - 0.5 * SQUARE_SIZE * names.size() - maxL, 
                                   position.y + SQUARE_SIZE * (nameIndex + 0.5 - names.size() * 0.5));       
            else
                location = new PVector(position.x - 0.5 * maxL, position.y);
        }
        else if (ydiff <= 0 && abs(xdiff) <= abs(ydiff)) { // bottom block
            if (names.size() > 1)
                location = new PVector(position.x + SQUARE_SIZE * (nameIndex + 0.5 - names.size() * 0.5), 
                                   position.y + 0.5 * SQUARE_SIZE * names.size() + maxL);        
            else
                location = new PVector(position.x, position.y + 0.5 * SQUARE_SIZE);
        }
        else { // top block
            if (names.size() > 1)
                location = new PVector(position.x + SQUARE_SIZE * (nameIndex + 0.5 - names.size() * 0.5), 
                                   position.y - 0.5 * SQUARE_SIZE * names.size() - maxL);        
            else
                location = new PVector(position.x, position.y - 0.5 * SQUARE_SIZE);
        }
        return location;
    }
    
    void drawPosition() {
         if (names.size() > 1) {
             drawNamesV(position.x - 0.5 * names.size() * SQUARE_SIZE, 
                     position.y - 0.5 * names.size() * SQUARE_SIZE - maxL);
             drawNamesV(position.x - 0.5 * names.size() * SQUARE_SIZE, 
                     position.y + 0.5 * names.size() * SQUARE_SIZE);
             drawNamesH(position.x - 0.5 * names.size() * SQUARE_SIZE - maxL, 
                     position.y - 0.5 * names.size() * SQUARE_SIZE);  
             drawNamesH(position.x + 0.5 * names.size() * SQUARE_SIZE, 
                     position.y - 0.5 * names.size() * SQUARE_SIZE);
             drawHM();
         }
         else {
             drawNamesH(position.x - 0.5 * maxL, position.y - 0.5 * SQUARE_SIZE);
         }  
    }
    
    void drawNamesV(float x, float y) {
         for (int i = 0; i < names.size(); ++i) {
             fill(255);
             rect(x, y, SQUARE_SIZE, maxL);
             fill(0);
             textSize(12);
             textAlign(CENTER, CENTER);
             pushMatrix();
             translate(x + 0.5 * SQUARE_SIZE, y + 0.5 * maxL);
             rotate(-HALF_PI);
             text(names.get(i), 0, 0);
             popMatrix();
             x += SQUARE_SIZE;
         }
    }
    
    
    void drawNamesH(float x, float y) {
         for (int i = 0; i < names.size(); ++i) {
             fill(255);
             rect(x, y, maxL, SQUARE_SIZE);
             fill(0);
             textSize(12);
             textAlign(CENTER, CENTER);
             text(names.get(i), x + 0.5 * maxL, y + 0.5 * SQUARE_SIZE);
             y += SQUARE_SIZE;
         }
    }
    
    void drawHM() {
         float startX, startY;
         for (int i = 0; i < names.size(); ++i) {
              startX = position.x - 0.5 * names.size() * SQUARE_SIZE;
              startY = position.y - 0.5 * names.size() * SQUARE_SIZE + i * SQUARE_SIZE;
              for (int j = 0; j < names.size(); ++j) {
                  if (links[i][j] == 0) {
                        fill(255);
                  }
                  else {
                        fill(colors[links[i][j] -1]);
                  }
                  rect(startX, startY, SQUARE_SIZE, SQUARE_SIZE);
                  startX += SQUARE_SIZE;
              }
         }
    }
    
    float getNameLength() {
         float maxLength = 0;
         textSize(12);
         for (int i = 0; i < names.size(); i++) {
             if (textWidth(names.get(i)) > maxLength) {
                 maxLength = textWidth(names.get(i));
             }
         }
         return maxLength + 4;
     }
    
     boolean intersects() {
         if (names.size() > 1) {
             if( ( mouseX >= position.x - 0.5 * names.size() * SQUARE_SIZE - maxL &&
                      mouseX <= position.x + 0.5 * names.size() * SQUARE_SIZE + maxL &&
                      mouseY >= position.y - 0.5 * names.size() * SQUARE_SIZE &&
                      mouseY <= position.y + 0.5 * names.size() * SQUARE_SIZE) ||
                    ( mouseX >= position.x - 0.5 * names.size() * SQUARE_SIZE &&
                      mouseX <= position.x + 0.5 * names.size() * SQUARE_SIZE &&
                      mouseY >= position.y - 0.5 * names.size() * SQUARE_SIZE - maxL &&
                      mouseY <= position.y + 0.5 * names.size() * SQUARE_SIZE + maxL)) {
                  offsetX = position.x - mouseX;
                  offsetY = position.y - mouseY;
                  return true;
            }
         }
         else {
             if( mouseX >= position.x - 0.5 * maxL && 
                    mouseX <= position.x + 0.5 * maxL &&
                    mouseY >= position.y - 0.5 * SQUARE_SIZE &&
                    mouseY <= position.y + 0.5 * SQUARE_SIZE) {
                offsetX = position.x - mouseX;
                offsetY = position.y - mouseY;
                return true;
            }
         }
        return false;
     }
    
}
