//Not the prettiest solution to keyboard/mouse input but it functions pretty well. Will keep unless I think of something better.
public Boolean mouseReleased = false;
public Boolean keyReleased = false;
public Boolean leftClicked = false;
public Boolean rightClicked = false;
public Boolean middleClicked = false;
public Boolean enterClicked = false;

void mousePressed() {
  if (mouseButton == LEFT) {
    leftClicked = true;
  } else if (mouseButton == RIGHT) {
    rightClicked = true;
  } else if (mouseButton == CENTER) {
    middleClicked = true;
  }
}

void mouseReleased() {
  mouseReleased = true;
}

void keyPressed() {
  if (keyCode == ENTER) {
    enterClicked = true;
  }
}

void keyReleased() {
  if (enterClicked) {
    keyReleased = true;
  }
}
