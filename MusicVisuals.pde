import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer track1;
FFT fft;

float speed;
int mode = 0;
boolean hasChosenTrack = false;

Star[] stars = new Star[400];
Sphere[] spheres = new Sphere[5];

//buttons
PImage start, play1, pause, volume, exit;
Button[] buttons = new Button[5];

void setup() {

  //fullScreen(P3D);
  size(1280, 720, P3D);

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
  } else {
    track1 = minim.loadFile(selection.getAbsolutePath());
    fft = new FFT(track1.bufferSize(), track1.sampleRate());

    //instantiate the circles, which currently require fft loaded
    spheres[0] = new Sphere(200, 200);
    spheres[1] = new Sphere(200, (200*-1));
    spheres[2] = new Sphere((200*-1), 200);
    spheres[3] = new Sphere((200*-1), (200*-1));
    spheres[4] = new Sphere((200), (200*-1));
    hasChosenTrack = true;
    loop();
  }
}

void draw() {
  background(0);
  if (hasChosenTrack) {
    fft.forward(track1.mix);

    //mode 0 : certainly does something
    //mode 1 : run the visuals and draw buttons
    //mode 2 : same as mode 0 but calls setup?
    // DO A SWITCH

    if (mode == 0) {
      background(0);
      for (int i = 0; i < buttons.length; i++) {
        buttons[0].inicio();
      }
    }

    if (mode==1) { 
      background(0);
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
    }

    if (mode == 2) {
      background(0);
      setup();
      for (int i = 0; i < buttons.length; i++) {
        buttons[0].inicio();
      }
    }

    //not sure if this should be here
    for (int i = 0; i< fft.specSize(); i++) {
      speed = fft.getFreq(i);
    }
  }
}


void mousePressed() {

  //play button
  if (buttons[0].containsMouseIn()) {
    track1.play();
    mode=1;
  } 

  //pause/resume button
  if (buttons[1].containsMousePP() && track1.isPlaying()) { 
    for (int i = 0; i < buttons.length; i++) {
      buttons[1].setImg(play1);
      track1.pause();
    }
  } else {
    buttons[1].setImg(pause);
    track1.play();
  }

  //goes back and choose other music
  if (buttons[3].containsMousePP()) {
    track1.close();
    mode = 2;
  }
}

void stop() {
  track1.close();
  minim.stop();
  super.stop();
}
