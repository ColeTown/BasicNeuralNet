public class Car {

  private float QTR_PI = PI / 4;

  public int checkpointsReached = 0;
  private int nextCheckpoint = 0;
  private PVector carPos = new PVector();
  private PVector carDir = new PVector();
  public Boolean crashed = false;


  //input for neural net. is the distance to the nearest wall in the given direction
  public float left = 0;
  public float upperLeft = 0;
  public float ahead = 0;
  public float upperRight = 0;
  public float right = 0;
  public float behind = 0;

  public Car(PVector position, PVector direction) {
    this.carPos.set(position);
    this.carDir.set(direction);
  }

  public void resetCar() {
    checkpointsReached = 0;
    nextCheckpoint = 0;
    crashed = false;
    this.carPos.set(carPosition);
    this.carDir.set(carDirection);
  }

  public void update(int i) {
    if (!crashed) {
      checkWallCollision();
      checkCheckpointCollision();
      setSensorValues();
      agentBrains.get(i).brainThink(i);
      if (i < numberOfCarsShown) {
        drawCar(i);
      }
    }
  }

  private void drawCar(int i) {
    stroke(0, 255, 0);
    line(this.carPos.x, this.carPos.y, this.carPos.x + this.carDir.x * 11, this.carPos.y + this.carDir.y * 11);
    stroke(150, 0, 0);
    if(agentBrains.get(i).isRandom) {
      fill(0,255,0);
    } else {
      fill(255, 0, 0);
    }
    ellipse(this.carPos.x, this.carPos.y, carRadius + carRadius, carRadius + carRadius);
  }

  private void setSensorValues() {
    ahead = 1;
    left = 1;
    upperLeft = 1;
    upperRight = 1;
    right = 1;
    behind = 1;

    PVector tempDir = new PVector(carDir.x, carDir.y);
    tempDir.x *= 500;
    tempDir.y *= 500;
    float trackX1;
    float trackY1;
    float trackX2 = Track.get(0).x;
    float trackY2 = Track.get(0).y;
    float tempAhead;
    float tempUpperLeft;
    float tempLeft;
    float tempBehind;
    float tempRight;
    float tempUpperRight;
    for (int i = 1; i < Track.size() - 1; i++) {
      trackX1 = trackX2;
      trackY1 = trackY2;
      trackX2 = Track.get(i).x;
      trackY2 = Track.get(i).y;
      tempAhead = lineIntersectionValue(carPos.x, carPos.y, carPos.x + tempDir.x, carPos.y + tempDir.y, trackX1, trackY1, trackX2, trackY2);
      if (tempAhead < ahead) {
        ahead = tempAhead;
      }
      tempDir.rotate(QTR_PI);
      tempUpperLeft = lineIntersectionValue(carPos.x, carPos.y, carPos.x + tempDir.x, carPos.y + tempDir.y, trackX1, trackY1, trackX2, trackY2);
      if (tempUpperLeft < upperLeft) {
        upperLeft = tempUpperLeft;
      }
      tempDir.rotate(QTR_PI);
      tempLeft = lineIntersectionValue(carPos.x, carPos.y, carPos.x + tempDir.x, carPos.y + tempDir.y, trackX1, trackY1, trackX2, trackY2);
      if (tempLeft < left) {
        left = tempLeft;
      }
      tempDir.rotate(HALF_PI);
      tempBehind = lineIntersectionValue(carPos.x, carPos.y, carPos.x + tempDir.x, carPos.y + tempDir.y, trackX1, trackY1, trackX2, trackY2);
      if (tempBehind < behind) {
        behind = tempBehind;
      }
      tempDir.rotate(HALF_PI);
      tempRight = lineIntersectionValue(carPos.x, carPos.y, carPos.x + tempDir.x, carPos.y + tempDir.y, trackX1, trackY1, trackX2, trackY2);
      if (tempRight < right) {
        right = tempRight;
      }
      tempDir.rotate(QTR_PI);
      tempUpperRight = lineIntersectionValue(carPos.x, carPos.y, carPos.x + tempDir.x, carPos.y + tempDir.y, trackX1, trackY1, trackX2, trackY2);
      if (tempUpperRight < upperRight) {
        upperRight = tempUpperRight;
      }
      tempDir.rotate(QTR_PI);
    }
  }

  private float lineIntersectionValue(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

    float denominator = ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / denominator;
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / denominator;

    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
      return uA;
    }
    return 1.0;
  }

  private void checkWallCollision() {
    //checks if circle is touching a wall
    for (int i = 0; i < Track.size() - 1; i++) {
      if (Track.get(i).x == 100000 || Track.get(i + 1).x == 100000) {
        i++;
      } else if (circleTouchingLine(Track.get(i).x, Track.get(i).y, Track.get(i + 1).x, Track.get(i + 1).y)) {
        crashed = true;
      }
    }
  }

  private void checkCheckpointCollision() {
    for (int i = 0; i < Checkpoints.size() - 1; i += 2) {
      if (Checkpoints.get(i).z == nextCheckpoint && circleTouchingLine(Checkpoints.get(i).x, Checkpoints.get(i).y, Checkpoints.get(i + 1).x, Checkpoints.get(i + 1).y)) {
        nextCheckpoint += 2;
        checkpointsReached++;
        if (nextCheckpoint > Checkpoints.size() - 1) {
          nextCheckpoint = 0;
        }
      }
    }
  }

  private boolean circleTouchingLine(float sx1, float sy1, float sx2, float sy2) {

    float xDelta = sx2 - sx1;
    float yDelta = sy2 - sy1;
    float u = ((carPos.x - sx1) * xDelta + (carPos.y - sy1) * yDelta) / (sq(xDelta) + sq(yDelta));
    float closestPointX = 0;
    float closestPointY = 0;

    if (u < 0)
    {
      closestPointX = sx1;
      closestPointY = sy1;
    } else if (u > 1)
    {
      closestPointX = sx2;
      closestPointY = sy2;
    } else
    {
      closestPointX = Math.round(sx1 + u * xDelta);
      closestPointY = Math.round(sy1 + u * yDelta);
    }

    if (dist(carPos.x, carPos.y, closestPointX, closestPointY) <= carRadius)
    {
      return true;
    } 
    return false;
  }

  public void movement(float speed, float direction) {
    step(speed);
    changeDirection(direction);
  }

  private void step(float speed) {
    speed *= 2;
    this.carPos.set(this.carPos.x + this.carDir.x * speed, this.carPos.y + this.carDir.y * speed);
  }

  private void changeDirection(float direction) {
    this.carDir.rotate(direction * maxTurn);
  }
}
