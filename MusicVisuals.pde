import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer track;
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
  if (hasChosenTrack) { 
    background(0);
    fft.forward(track.mix);
    noStroke();

    //calls every draw function of each spheres
    //yeah, more than one
    for (int i = 0; i < spheres.length; i++) {
      spheres[i].desenha1();
      spheres[i].desenha2();
      spheres[i].desenha3();
      spheres[i].desenha4();
      spheres[i].desenha5();
    }

    // star background
    for (int i=0; i<stars.length; i++) {
      stars[i].desenha();
      stars[i].update();
    }

    for (int i = 0; i < buttons.length; i++) {
      buttons[1].pp(); 
      buttons[2].pp();
      buttons[3].pp();
    }

    for (int i = 0; i< fft.specSize(); i++) {
    speed = fft.getFreq(i);
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
    track.close();
    noLoop();
    selectInput("Select a music file:", "finishSetup");
  }
}

void stop() {
  track.close();
  minim.stop();
  super.stop();
}
