public class Brain {

  ArrayList<Float> LayerOneNodes = new ArrayList<Float>();
  public ArrayList<Float> LayerOneWeights = new ArrayList<Float>();
  public ArrayList<Float> LayerOneBiases = new ArrayList<Float>();

  ArrayList<Float> LayerTwoNodes = new ArrayList<Float>();
  public ArrayList<Float> LayerTwoWeights = new ArrayList<Float>();
  public ArrayList<Float> LayerTwoBiases = new ArrayList<Float>();

  ArrayList<Float> LayerThreeNodes = new ArrayList<Float>();
  public ArrayList<Float> LayerThreeWeights = new ArrayList<Float>();
  public ArrayList<Float> LayerThreeBiases = new ArrayList<Float>();

  float speedOutput = 1;
  float dirOutput;
  
  public Boolean isRandom = false;

  public Brain() {
    for (int i = 0; i < 36; i++) {
      this.LayerOneWeights.add(random(-5.0, 5.0));
      this.LayerTwoWeights.add(random(-5.0, 5.0));
      if (i % 3 == 0) {
        this.LayerThreeWeights.add(random(-5.0, 5.0));
      }
    }
    for (int i = 0; i < 6; i++) {
      this.LayerOneBiases.add(random(-5.0, 5.0)); 
      this.LayerTwoBiases.add(random(-5.0, 5.0)); 
      if (i % 3 == 0) {
        this.LayerThreeBiases.add(random(-5.0, 5.0));
      }
    }
  }
  
  

  public Brain(Brain parentBrain) {
    for (int i = 0; i < 36; i++) {
      this.LayerOneWeights.add(parentBrain.LayerOneWeights.get(i) + randomGaussian()*mutationFactor);
      this.LayerTwoWeights.add(parentBrain.LayerTwoWeights.get(i) + randomGaussian()*mutationFactor);
      if (i % 3 == 0) {
        this.LayerThreeWeights.add(parentBrain.LayerThreeWeights.get(i / 3) + randomGaussian()*mutationFactor);
      }
    }
    for (int i = 0; i < 6; i++) {
      this.LayerOneBiases.add(parentBrain.LayerOneBiases.get(i) + randomGaussian()*mutationFactor); 
      this.LayerTwoBiases.add(parentBrain.LayerTwoBiases.get(i) + randomGaussian()*mutationFactor); 
      if (i % 3 == 0) {
        this.LayerThreeBiases.add(parentBrain.LayerThreeBiases.get(i / 3) + randomGaussian()*mutationFactor);
      }
    }
  }

  public void brainThink(int n) {
    LayerOneNodes.clear();
    LayerTwoNodes.clear();
    LayerThreeNodes.clear();

    Car currentCar = cars.get(n);
    LayerOneNodes.add(currentCar.left);
    LayerOneNodes.add(currentCar.upperLeft);
    LayerOneNodes.add(currentCar.ahead);
    LayerOneNodes.add(currentCar.upperRight);
    LayerOneNodes.add(currentCar.right);
    LayerOneNodes.add(currentCar.behind);

    float tempValue;

    for (int i = 0; i < 6; i++) {
      tempValue = 0;
      for (int j = 0; j < 6; j++) {
        tempValue += (LayerOneNodes.get(j) * LayerOneWeights.get((6 * i) + j));
      } 
      tempValue += LayerOneBiases.get(i);
      LayerTwoNodes.add(sigmoid(tempValue));
    }

    for (int i = 0; i < 6; i++) {
      tempValue = 0;
      for (int j = 0; j < 6; j++) {
        tempValue += (LayerTwoNodes.get(j) * LayerTwoWeights.get((6 * i) + j));
      } 
      tempValue += LayerTwoBiases.get(i);
      LayerThreeNodes.add(sigmoid(tempValue));
    }


    tempValue = 0;
    for (int j = 0; j < 6; j++) {
      tempValue += (LayerThreeNodes.get(j) * LayerThreeWeights.get(j));
    } 
    tempValue += LayerThreeBiases.get(0);
    dirOutput = sigmoid(tempValue);


    cars.get(n).movement(speedOutput, dirOutput);
  }

  private float sigmoid(float x) {
    return sigmoidFunction[(int)(constrain(6 + x, 0, 12.01) * 100)];
  }
}
