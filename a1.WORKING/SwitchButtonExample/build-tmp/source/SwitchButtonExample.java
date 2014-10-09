import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Collections; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SwitchButtonExample extends PApplet {



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

	public void draw() {
		fill(200, 150, 10);
		rect(x, y, w, h);
		fill(255, 255, 255);
		textAlign(CENTER, CENTER);
        textSize(10);
        text(title, x + w/2, y + h/2);
	}

	// GETTERS
	public String getTitle() 	{ return title; }
	public float getWidth() 	{ return w; }
	public float getCenterX() 	{ return x + w/2; }
	public float getCenterY() 	{ return y + h/2; }
	public float getX() 		{ return x; }
	public float getY() 		{ return y; }
	public float getInitX() 	{ return initX; }

	// SETTERS
	public void setAlwaysLocked() 	{ this.alwaysLocked = true; }
	public void unlock() 			{ locked = false; }
	public void lock()  		 	{ locked = true; }
	public void moveUnlockedButton() {
		if (!alwaysLocked && !locked) {
			x = mouseX - w/2;
		}
	}

	public void setX(float x) {
		if (!alwaysLocked) {
			this.x = x;
		}
	}

	public void setInitX(float x) {
		if (!alwaysLocked) {
			this.initX = x;
		}
	}

	// BOOLS
	public boolean isAlwaysLocked() 	{ return alwaysLocked; }
	public boolean isLocked() 			{ return locked; }
	public boolean isIntersect() {
		if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
			return true;
		} else {
			return false;
		}
	}

	public boolean isRightNeighbor(Button b) {
		// immediately right
		if (initX == b.getInitX() + w) {
			return true;
		} else {
			return false;
		}
	}

	public boolean isLeftNeighbor(Button b) {
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
			// Add string title to buttonORder arraylist<String>
			this.buttonOrder.add(data.get(i));
			// Create new button and add to buttons arraylist<Button>
			Button b = new Button(xPos, y0, buttonWidth, buttonHeight, data.get(i) );
			this.buttons.add(b);	
			xPos += buttonWidth;
		}
		// Last button cannot be moved
		this.buttons.get(this.buttons.size()-1).setAlwaysLocked();
	}

	public void draw() {
		for(int i=0; i<buttons.size(); i++) {
			buttons.get(i).draw();
		}
	}

	// Used by Treemap to get order of categories
	public ArrayList<String> getButtonOrder() { 
		return buttonOrder; 
	}

	public void buttonDragged() {
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

	public void unlockClickedButton() {
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
	public boolean isOverlapped(Button current) {
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
	public void swapButtonOrder(Button currentButton, Button toSwapButton) {
		int currentIndex = getButtonIndex(currentButton);
		int toSwapIndex = getButtonIndex(toSwapButton);

		if (currentIndex != -1 && toSwapIndex != -1) {
			Collections.swap(buttonOrder, currentIndex, toSwapIndex);
		}
	}

	// Get the index of the button in the buttonOrder arraylist
	// Returns -1 if Button is not in buttons arraylist
	public int getButtonIndex(Button b) {
		for (int i=0; i<buttons.size(); i++) {
			// This assumes the buttons are all labeled differently
			if (buttonOrder.get(i) == b.getTitle()) {
				return i;
			}
		}
		return -1;
	}

	// Resets all buttons to locked, snap current button back into place
	public void buttonReleased() {
		for (int i=0; i<buttons.size(); i++){
			Button b = buttons.get(i);
			b.lock();
			b.setX(b.getInitX());
		}
		buttonUnlocked = false;
	}
};

SwitchButton switchButton;

public void setup() {
	size(600,600);

	ArrayList categories = new ArrayList<String>();
	categories.add("department");
	categories.add("sponsor");
	categories.add("year");
	categories.add("total");

	switchButton = new SwitchButton(categories, 100.00f, 100.00f);

}

public void draw() {
	background(255,255,255);
	switchButton.draw();
}


public void mouseDragged() {
	switchButton.buttonDragged();
}

public void mouseReleased() {
	switchButton.buttonReleased();
}





  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SwitchButtonExample" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
