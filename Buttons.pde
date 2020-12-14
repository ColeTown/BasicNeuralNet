public class Button {

  private String buttonText;
  private float buttonXPos;
  private float buttonYPos;
  private float buttonWidth;
  private float buttonHeight;
  private int fontSize;

  public Button(String buttonText, float buttonXPos, float buttonYPos, float buttonWidth, float buttonHeight, int fontSize) {
    this.buttonText = buttonText;
    this.buttonXPos = buttonXPos;
    this.buttonYPos = buttonYPos;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.fontSize = fontSize;
  }

  public void drawButton() {
    rectMode(CENTER);
    if (overRect()) { //if hovering over button, highlight that button
      fill(220);
    } else {
      fill(250);
    }
    noStroke();
    rect(buttonXPos, buttonYPos, buttonWidth, buttonHeight, 7); //create rectangle for button
    fill(0);
    textSize(fontSize);
    textAlign(CENTER, CENTER);
    text(buttonText, buttonXPos, buttonYPos, buttonWidth, buttonHeight); //create text for button
  }


  public boolean buttonClicked() { //returns true if button is clicked, false if not
    if (leftClicked) {
      if (overRect()) {
        if (mouseReleased) {
          leftClicked = false;
          mouseReleased = false;
          return true;
        }
      } else {
        if (mouseReleased) {
          return false;
        }
      }
    }
    return false;
  }

  private boolean overRect() { //checks if mouse pointer is over a button
    //half width and height is used because the rectangles are drawn with CENTER mode
    float halfRectWidth = (buttonWidth / 2);
    float halfRectHeight = (buttonHeight / 2);
    if (mouseX >= buttonXPos - halfRectWidth && mouseX <= buttonXPos + halfRectWidth && mouseY >= buttonYPos - halfRectHeight && mouseY <= buttonYPos + halfRectHeight) {
      return true;
    } else {
      return false;
    }
  }
}
