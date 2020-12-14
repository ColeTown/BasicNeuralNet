public int currentGeneration = 0;

void setup() {
  size(1920, 1080);
  initialButtonSetup();
  smooth();
  numberOfCars = firstGenerationNumber;
  agentBrainsSetup();
  textSize(32);
  frameRate(10000);
}

void draw() {
  background(50);
  drawTrack();
  if (!useSavedTrack) {
    trackSetup();
  } else if (!trackLoaded) {
    loadTrack(); 
    trackLoaded = true;
  } else if (!carPlaced) {
    if(middleClicked) {
      middleClicked = false;
      loadBrain();
    }
    carSetup();
  } else {
    if (allCarsAreDead() || leftClicked) { //second() % timePerGeneration == 0 || 
      leftClicked = false;
      currentGeneration++;
      nextGeneration();
      for (int i = 0; i < numberOfCars; i++) {
        cars.get(i).resetCar();
      }
      delay(1000);
    }
    if (currentGeneration == 1) {
      numberOfCars = allGenerationNumber;
    }
    for (int i = numberOfCars - 1; i >= 0; i--) {
      cars.get(i).update(i);
    }
    if(rightClicked) {
      rightClicked = false;
      saveBrain();
    }
    
  }
  fill(255);
  text(currentGeneration, 50, 50);
  text(frameRate, 50, 100);
}



ArrayList<Car> cars = new ArrayList<Car>();

public PVector carPosition = new PVector(0, 0, 0);
public PVector carDirection = new PVector(0, 0, 0);
public Boolean carPlaced = false;
public Boolean carHasPosition = false;

void carSetup() {
  if (!carHasPosition) {
    setCarPosition();
  } else {
    setCarDirection();
  }
}

void setCarPosition() {
  if (leftClicked && mouseReleased) {
    carPosition = new PVector(mouseX, mouseY);
    leftClicked = false;
    mouseReleased = false;
    carHasPosition = true;
  }
}

void setCarDirection() {
  if (leftClicked && mouseReleased) {
    carDirection = new PVector(mouseX - carPosition.x, mouseY - carPosition.y);
    carDirection = carDirection.normalize();
    makeCars();
    leftClicked = false;
    mouseReleased = false;
    carPlaced = true;
  }
}

void makeCars() {
  for (int i = 0; i < numberOfCars; i++) {
    cars.add(new Car(carPosition, carDirection));
  }
}

Button createTrack;
Button loadTrack;
Button makeCheckpoints;
Button saveTrack;

void initialButtonSetup() {
  createTrack = new Button("Create Track", width / 2, 400, 200, 100, 20);
  loadTrack = new Button("Load Track", width / 2, 505, 200, 100, 20);
  makeCheckpoints = new Button("Make Checkpoints", 60, 30, 100, 50, 15);
  saveTrack = new Button("Save Track", 60, 90, 100, 50, 15);
}

public void saveBrain() {
  String[] stringsOfBrain = new String[6 * numberOfCars];
  for (int i = 0; i < allGenerationNumber; i++) {
    stringsOfBrain[6 * i] = agentBrains.get(i).LayerOneWeights.toString();
    stringsOfBrain[6 * i + 1] = agentBrains.get(i).LayerOneBiases.toString();
    stringsOfBrain[6 * i + 2] = agentBrains.get(i).LayerTwoWeights.toString();
    stringsOfBrain[6 * i + 3] = agentBrains.get(i).LayerTwoBiases.toString();
    stringsOfBrain[6 * i + 4] = agentBrains.get(i).LayerThreeWeights.toString();
    stringsOfBrain[6 * i + 5] = agentBrains.get(i).LayerThreeBiases.toString();
  }
  saveStrings("Brains.txt", stringsOfBrain);
}

public void loadBrain() {
  String[] Brain = loadStrings("Brains.txt");
  for(int i = 0; i < allGenerationNumber; i++) {
    
    String[] temp = Brain[6 * i].substring(1,Brain[6 * i].length() - 1).split(",");
    for(int j = 0; j < temp.length; j++) {
      agentBrains.get(i).LayerOneWeights.set(j, Float.parseFloat(temp[j]));
    }
    
    temp = Brain[6 * i + 1].substring(1,Brain[6 * i + 1].length() - 1).split(",");
    for(int j = 0; j < temp.length; j++) {
      agentBrains.get(i).LayerOneBiases.set(j, Float.parseFloat(temp[j]));
    }
    
    temp = Brain[6 * i + 2].substring(1,Brain[6 * i + 2].length() - 1).split(",");
    for(int j = 0; j < temp.length; j++) {
      agentBrains.get(i).LayerTwoWeights.set(j, Float.parseFloat(temp[j]));
    }
    
    temp = Brain[6 * i + 3].substring(1,Brain[6 * i + 3].length() - 1).split(",");
    for(int j = 0; j < temp.length; j++) {
      agentBrains.get(i).LayerTwoBiases.set(j, Float.parseFloat(temp[j]));
    }
    
    temp = Brain[6 * i + 4].substring(1,Brain[6 * i + 4].length() - 1).split(",");
    for(int j = 0; j < temp.length; j++) {
      agentBrains.get(i).LayerThreeWeights.set(j, Float.parseFloat(temp[j]));
    }
    
    temp = Brain[6 * i + 5].substring(1,Brain[6 * i + 5].length() - 1).split(",");
    for(int j = 0; j < temp.length; j++) {
      agentBrains.get(i).LayerThreeBiases.set(j, Float.parseFloat(temp[j]));
    }
  }
}

ArrayList<Brain> agentBrains = new ArrayList<Brain>();

void agentBrainsSetup() {
  for (int i = 0; i < numberOfCars; i++) {
    agentBrains.add(new Brain());
  }
}

int mostCheckpoints;

void nextGeneration() {
  mutationFactor = Checkpoints.size() / ((mostCheckpoints + 1) );//PI is arbitrary
  float checkpointMultiplier;
  for (int i = 0; i < numberOfParentAgentsPerGen; i++) {
    mostCheckpoints = 0;
    int index = 0;
    for (int j = i; j < numberOfCars; j++) {
      if (agentBrains.get(j).isRandom) {
        checkpointMultiplier = 2;
      } else {
        checkpointMultiplier = 1;
      }
      if (cars.get(j).checkpointsReached * checkpointMultiplier >= mostCheckpoints) {
        mostCheckpoints = cars.get(j).checkpointsReached;
        index = j;
      }
    }
    if (i == 0) {
      println(mostCheckpoints);
      println(agentBrains.get(0).isRandom);
    }
    Car tempCar = cars.get(index);
    cars.set(index, cars.get(i));
    cars.set(i, tempCar);

    Brain tempBrain = agentBrains.get(index);
    agentBrains.set(index, agentBrains.get(i));
    agentBrains.set(i, tempBrain);
  }

  for (int i = numberOfParentAgentsPerGen; i < numberOfCars - numberOfRandomsPerGen; i++) {
    agentBrains.set(i, new Brain(agentBrains.get(i % numberOfParentAgentsPerGen)));
    agentBrains.get(i).isRandom = false;
  }
  for (int i = numberOfCars - numberOfRandomsPerGen; i < numberOfCars; i++) {
    agentBrains.set(i, new Brain());
    agentBrains.get(i).isRandom = true;
  }
}

boolean allCarsAreDead() {
  for (int i = 0; i < numberOfCars; i++) {
    if (cars.get(i).crashed == false) {
      return false;
    }
  }
  return true;
}
