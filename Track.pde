ArrayList<PVector> Track = new ArrayList<PVector>();
ArrayList<PVector> Checkpoints = new ArrayList<PVector>();
Boolean creatingTrack = false;
Boolean creatingCheckpoints = false;
Boolean useSavedTrack = false;
Boolean trackSaved = false;
Boolean trackLoaded = false;
//************************************************************************************************************************************
//  System used to build the tracks for the car:
//  Left click to add a vertex to the wall
//  Right click to remove the last added vertex
//  Center click (the mouse wheel) to disconnect the wall so you can make a different one (e.g. an outside wall and an inside wall)
//************************************************************************************************************************************
void trackSetup() {
  if (creatingTrack) {
    makeCheckpoints.drawButton();
    saveTrack.drawButton();
    if (!creatingCheckpoints && makeCheckpoints.buttonClicked()) {
      creatingCheckpoints = true;
    } else if (!trackSaved && saveTrack.buttonClicked()) {
      saveTrack();
      useSavedTrack = true;
      trackSaved = true;
      creatingTrack = false;
    } else if (creatingCheckpoints) {
      createTrackCheckpoints();
    } else {
      createTrackVertex();
    }
  } else {
    if (createTrack.buttonClicked()) {
      creatingTrack = true;
    } 
    if (loadTrack.buttonClicked()) {
      useSavedTrack = true;
    }
    createTrack.drawButton();
    loadTrack.drawButton();
  }
}

void createTrackVertex() {
  if (leftClicked && mouseReleased) {
    Track.add(new PVector(mouseX, mouseY)); 
    leftClicked = false;
    mouseReleased = false;
  } else if (Track.size() != 0 && rightClicked && mouseReleased) {
    Track.remove(Track.size() - 1); 
    rightClicked = false;
    mouseReleased = false;
  } else if (middleClicked && mouseReleased) {
    Track.add(new PVector(100000, 0)); //100000 is an arbitrary number, just used it to know which vertex to skip over
    middleClicked = false;
    mouseReleased = false;
  }
}

public int checkpointCount = 0;

void createTrackCheckpoints() {
  if (leftClicked && mouseReleased) {
    Checkpoints.add(new PVector(mouseX, mouseY, checkpointCount++)); 
    leftClicked = false;
    mouseReleased = false;
  } else if (Checkpoints.size() != 0 && rightClicked && mouseReleased) {
    Checkpoints.remove(Checkpoints.size() - 1); 
    rightClicked = false;
    mouseReleased = false;
  }
}

//saves Track and Checkpoints to a text file so you can reuse tracks
void saveTrack() {
  String stringOfTracks = "";
  String stringOfCheckpoints = "";
  for (int i = 0; i < Track.size(); i++) {
    stringOfTracks += (int)Track.get(i).x + "/" + (int)Track.get(i).y + "/" + (int)Track.get(i).z + "/";
  }
  for (int i = 0; i < Checkpoints.size(); i++) {
    stringOfCheckpoints += (int)Checkpoints.get(i).x + "/" + (int)Checkpoints.get(i).y + "/" + (int)Checkpoints.get(i).z + "/";
  }
  String[] arrayOfTracks = split(stringOfTracks, "/");
  String[] arrayOfCheckpoints = split(stringOfCheckpoints, "/");
  saveStrings("track.txt", arrayOfTracks);
  saveStrings("checkpoints.txt", arrayOfCheckpoints);
}

//loads the saved track into the Track and Checkpoints ArrayLists
void loadTrack() {
  String[] arrayOfTracks = loadStrings("track.txt");
  String[] arrayOfCheckpoints = loadStrings("checkpoints.txt");
  Track.clear();
  Checkpoints.clear();
  for (int i = 0; i < arrayOfTracks.length - 2; i += 3) {
    Track.add(new PVector(Integer.parseInt(arrayOfTracks[i]), Integer.parseInt(arrayOfTracks[i + 1]), Integer.parseInt(arrayOfTracks[i + 2])));
  }
  for (int i = 0; i < arrayOfCheckpoints.length - 2; i += 3) {
    Checkpoints.add(new PVector(Integer.parseInt(arrayOfCheckpoints[i]), Integer.parseInt(arrayOfCheckpoints[i + 1]), Integer.parseInt(arrayOfCheckpoints[i + 2])));
  }
}

//Fairly self explanatory, draws the track so we can see it
void drawTrack() {
  for (int i = 0; i < Track.size() - 1; i++) {
    if (Track.get(i + 1).x != 100000 && Track.get(i).x != 100000) { 
      //wall style
      //future style option look into begin/endContour();
      strokeWeight(3);
      stroke(255);
      line(Track.get(i).x, Track.get(i).y, Track.get(i + 1).x, Track.get(i + 1).y);
    }
  }
  for (int i = 0; i < Checkpoints.size() - 1; i += 2) {

    strokeWeight(2);
    stroke(255, 255, 0);
    line(Checkpoints.get(i).x, Checkpoints.get(i).y, Checkpoints.get(i + 1).x, Checkpoints.get(i + 1).y);
  }
}
