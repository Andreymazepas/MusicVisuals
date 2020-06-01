import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer track1;
FFT fft;

float speed;
int mode;
boolean hasChosenTrack = false;

Star[] stars = new Star[400];
Circle[] circle = new Circle[5];

//buttons
PImage start, play1, pause, volume, back;
Button[] buttons = new Button[5];

void setup() {

  //fullScreen(P3D);
  size(1280, 720, P3D);
  mode=0;

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
  selectInput("Select a music fille:", "finishSetup");
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
    circle[0] = new Circle(200, 200);
    circle[1] = new Circle(200, (200*-1));
    circle[2] = new Circle((200*-1), 200);
    circle[3] = new Circle((200*-1), (200*-1));
    circle[4] = new Circle((200), (200*-1));
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

      //calls every draw function of each circle
      //yeah, more than one
      for (int i = 0; i < circle.length; i++) {
        circle[i].desenha1();
        circle[i].desenha2();
        circle[i].desenha3();
        circle[i].desenha4();
        circle[i].desenha5();
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
