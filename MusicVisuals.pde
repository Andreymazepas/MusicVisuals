import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer track;
BeatDetect beat;
FFT fft;

float speed;
boolean hasChosenTrack = false;

Star[] stars = new Star[400];
Sphere[] spheres = new Sphere[5];

//buttons
PImage start, play1, pause, volume, exit;
Button[] buttons = new Button[5];

void setup() {

  //fullScreen(P3D);
  size(1280, 720, P3D);
  surface.setTitle("MusicVisuals");
  surface.setResizable(true);

  start = loadImage("play.png");
  play1 = loadImage("play1.png");  
  pause = loadImage("pause.png");
  volume = loadImage("vol.png");
  exit = loadImage("exit.png");
  buttons[0] = new Button(start, new PVector(width/2, height/2)); 
  buttons[1] = new Button(pause, new PVector(30, height-30));
  buttons[2] = new Button(volume, new PVector(width/2 + 600, height-30));
  buttons[3] = new Button(exit, new PVector(width/2+600, 50));

  //sound
  minim = new Minim(this);
  selectInput("Select a music file:", "finishSetup");
  noLoop();


  smooth();
  stroke(255);
  strokeWeight(5);
  for (int i=0; i<stars.length; i++) {
    stars[i] = new Star();
  }
}

void finishSetup(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    //keep playing if already has music
    if(hasChosenTrack)
    {
      track.play();
      loop();
    }
  } else {
    if(hasChosenTrack){
      track.close();
    }
    track = minim.loadFile(selection.getAbsolutePath());
    fft = new FFT(track.bufferSize(), track.sampleRate());
    beat = new BeatDetect(track.bufferSize(), track.sampleRate());
    beat.setSensitivity(5);  

    //instantiate the circles, which currently require fft loaded
    spheres[0] = new Sphere(200, 200);
    spheres[1] = new Sphere(200, (200*-1));
    spheres[2] = new Sphere((200*-1), 200);
    spheres[3] = new Sphere((200*-1), (200*-1));
    spheres[4] = new Sphere((200), (200*-1));
    hasChosenTrack = true;
    track.play();
    loop();
  }
}

void draw() {
  // avoid nullPointerException while the user has not chosen a track yet
  if (hasChosenTrack) { 
    background(0);
    fft.forward(track.mix);
    beat.detect(track.mix);
    noStroke();

    for (int i = 0; i < spheres.length; i++) {
      spheres[i].render();
    }

    for (int i=0; i<stars.length; i++) {
      stars[i].render();
    }

    for (int i = 0; i < buttons.length; i++) {
      buttons[1].pp(); 
      buttons[2].pp();
      buttons[3].pp();
    }

    int lowBand = 5;
    int highBand = 15;
    // at least this many bands must have an onset 
    // for isRange to return true
    int numberOfOnsetsThreshold = 4;
    if (beat.isRange(lowBand, highBand, numberOfOnsetsThreshold)){
      speed = 50;
    } else {
      speed = 20;
    }
  }

}


void mousePressed() {

  //pause/resume button
  if (buttons[1].containsMousePP() && track.isPlaying()) { 
    buttons[1].setImg(play1);
    track.pause();
  } else {
    buttons[1].setImg(pause);
    track.play();
  }

  //goes back and choose other music
  if (buttons[3].containsMousePP()) {
    noLoop();
    selectInput("Select a music file:", "finishSetup");
  }
}

void stop() {
  track.close();
  minim.stop();
  super.stop();
}
