import java.util.Collections;

class Button {
	float h, w;
	float initX, initY;
	float x, y;
	String title;
	boolean locked, alwaysLocked;

	Button(float x, float y, float w, float h, String title) {
		this.initX = x;
		this.initY = y;
		this.x = x;
		this.y = y;
		this.h = h;
		this.w = w;
		this.title = title;
		this.locked = true;
		this.alwaysLocked = false;
	}

	void draw() {
		fill(200, 150, 10);
		rect(x, y, w, h);
		fill(255, 255, 255);
		textAlign(CENTER, CENTER);
        textSize(10);
        text(title, x + w/2, y + h/2);
	}

	// GETTERS
	String getTitle() 	{ return title; }
	float getWidth() 	{ return w; }
	float getCenterX() 	{ return x + w/2; }
	float getCenterY() 	{ return y + h/2; }
	float getX() 		{ return x; }
	float getY() 		{ return y; }
	float getInitX() 	{ return initX; }

	// SETTERS
	void setAlwaysLocked() 	{ this.alwaysLocked = true; }
	void unlock() 			{ locked = false; }
	void lock()  		 	{ locked = true; }
	void moveUnlockedButton() {
		if (!alwaysLocked && !locked) {
			x = mouseX - w/2;
		}
	}

	void setX(float x) {
		if (!alwaysLocked) {
			this.x = x;
		}
	}

	void setInitX(float x) {
		if (!alwaysLocked) {
			this.initX = x;
		}
	}

	// BOOLS
	boolean isAlwaysLocked() 	{ return alwaysLocked; }
	boolean isLocked() 			{ return locked; }
	boolean isIntersect() {
		if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
			return true;
		} else {
			return false;
		}
	}

	boolean isRightNeighbor(Button b) {
		// immediately right
		if (initX == b.getInitX() + w) {
			return true;
		} else {
			return false;
		}
	}

	boolean isLeftNeighbor(Button b) {
		// immediately left
		if (b.getInitX() == initX + w) {
			return true;
		} else {
			return false;
		}
	}
};


class SwitchButton {

	ArrayList<Button> buttons;
	ArrayList<String> buttonOrder;
	float buttonHeight;
	float buttonWidth;
	float x0, y0;
	float button1X, button2X, button3X;
	boolean buttonUnlocked;

	SwitchButton(ArrayList<String> data, float x0, float y0) {
		this.buttonHeight = 20;
		this.buttonWidth = 80;
		this.buttons = new ArrayList<Button>();
		this.buttonOrder = new ArrayList<String>();
		this.x0 = x0;
		this.y0 = y0;
		this.buttonUnlocked = false;

		float xPos = x0;
		for(int i=0; i<data.size(); i++) {
			// Add string title to buttonOrder arraylist<String>
			this.buttonOrder.add(data.get(i));
			// Create new button and add to buttons arraylist<Button>
			Button b = new Button(xPos, y0, buttonWidth, buttonHeight, data.get(i) );
			this.buttons.add(b);	
			xPos += buttonWidth;
		}
		// Last button cannot be moved
		this.buttons.get(this.buttons.size()-1).setAlwaysLocked();
	}

	void draw() {
		for(int i=0; i<buttons.size(); i++) {
			buttons.get(i).draw();
		}
	}

	// Used by Treemap to get order of categories
	ArrayList<String> getButtonOrder() { 
		return buttonOrder; 
	}

	void buttonDragged() {
		// Make the current clicked button moveable/unlocked
		unlockClickedButton();
		for (int i=0; i<buttons.size(); i++) {
			Button b = buttons.get(i);
			// If mouse intersects with button and is not the last button
			if (b.isIntersect() && !b.isAlwaysLocked()) {
				// Move the button until its x pos overlaps with another button's x pos
				if (!isOverlapped(b)) {
					b.moveUnlockedButton();
				} 
			}
		}
	}

	void unlockClickedButton() {
		//buttonUnlocked allows only one button to be unlocked at a time during mouse dragged
		if (!buttonUnlocked) {
			for (int i=0; i<buttons.size(); i++) {
				if (buttons.get(i).isIntersect()) {
					buttons.get(i).unlock();
					buttonUnlocked = true;
					break;	
				}
			}
		}
	}

	// Iterates through buttons and checks if current has overlapped any of them, 
	// Swaps the positions if so
	boolean isOverlapped(Button current) {
		for (int i=0; i<buttons.size(); i++) {
			Button b = buttons.get(i);
			if (!b.isAlwaysLocked() && b.isLocked()) {
				// Checks for overlap, but only if it is a neighbor button
				if ( (current.getX() > b.getX() && b.isRightNeighbor(current)) || 
					 (current.getX() < b.getX() && b.isLeftNeighbor(current)) ) {
					// Swaps the current and overlapped button's X's
					b.setX(current.getInitX());
					current.setX(b.getInitX());

					// Resets InitX to the swapped X values
					b.setInitX(current.getInitX());
					current.setInitX(current.getX());

					// Swap order of buttonOrder arraylist to reflect changes in button order
					swapButtonOrder(current, b); 
					return true;
				}
			}
		}
		return false;
	}

	// Finds indexes of two buttons and swaps their positions using Collections in
	// buttonOrder arraylist (strings)
	void swapButtonOrder(Button currentButton, Button toSwapButton) {
		int currentIndex = getButtonIndex(currentButton);
		int toSwapIndex = getButtonIndex(toSwapButton);

		if (currentIndex != -1 && toSwapIndex != -1) {
			Collections.swap(buttonOrder, currentIndex, toSwapIndex);
		}
	}

	// Get the index of the button in the buttonOrder arraylist
	// Returns -1 if Button is not in buttons arraylist
	int getButtonIndex(Button b) {
		for (int i=0; i<buttons.size(); i++) {
			// This assumes the buttons are all labeled differently
			if (buttonOrder.get(i) == b.getTitle()) {
				return i;
			}
		}
		return -1;
	}

	// Resets all buttons to locked, snap current button back into place
	void buttonReleased() {
		for (int i=0; i<buttons.size(); i++){
			Button b = buttons.get(i);
			b.lock();
			b.setX(b.getInitX());
		}
		buttonUnlocked = false;
	}
};

SwitchButton switchButton;

void setup() {
	size(600,600);

	ArrayList categories = new ArrayList<String>();
	categories.add("department");
	categories.add("sponsor");
	categories.add("year");
	categories.add("total");

	switchButton = new SwitchButton(categories, 100.00, 100.00);

}

void draw() {
	background(255,255,255);
	switchButton.draw();
}


void mouseDragged() {
	switchButton.buttonDragged();
}

void mouseReleased() {
	switchButton.buttonReleased();
}





