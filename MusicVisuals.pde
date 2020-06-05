import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer track;
AudioMetaData meta;
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
  textFont(createFont("Serif", 20));
  minim = new Minim(this);
  
  start = loadImage("play.png");
  play1 = loadImage("play1.png");  
  pause = loadImage("pause.png");
  volume = loadImage("vol.png");
  exit = loadImage("exit.png");

  buttons[0] = new Button(start, new PVector(width/2, height/2)); 
  buttons[1] = new Button(pause, new PVector(30, height-30));
  buttons[2] = new Button(volume, new PVector(width/2 + 600, height-30));
  buttons[3] = new Button(exit, new PVector(width/2+600, 50));

  for (int i=0; i<stars.length; i++) {
    stars[i] = new Star();
  }

  noLoop();
  selectInput("Select a music file:", "finishSetup");  
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
    meta = track.getMetaData();
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

int ys = 25;
int yi = 20;

void draw() {
  // avoid nullPointerException while the user has not chosen a track yet
  if (hasChosenTrack) { 
    background(0);
    fft.forward(track.mix);
    beat.detect(track.mix);
    noStroke();

    int y = ys;
    text(meta.title(), 10, y+=yi);
    text(meta.album(), 10, y+=yi);
    text(meta.author(), 10, y+=yi);

    // gray progress line
    stroke( 100, 100 ,100);
    line( width / 2 - 450, height - 20, width / 2 + 450, height - 20 );

    // white elapsed progress line
    stroke( 255, 255, 255);
    float position = map( track.position(), 0, track.length(), 0, 900 );
    line( width / 2 - 450, height - 20, width / 2 - 450 + position, height - 20 );
    circle(width / 2 - 450 + position, height - 20, 3);

    // elapsed time
    text(
          miliToMin(track.position()) + ":" 
          + miliToSeg(track.position()),
          width / 2 - 510,
          height - 15);

    // total time
    text(
          miliToMin(track.length()) + ":" 
          + miliToSeg(track.length()),
          width / 2 + 470, 
          height - 15);

    // main spheres
    for (int i = 0; i < spheres.length; i++) {
      spheres[i].render();
    }

    // background stars
    for (int i=0; i<stars.length; i++) {
      stars[i].render();
    }

    // update buttons
    for (int i = 1; i < 4; i++) {
      buttons[i].update(); 
    }


    // beat detection to speedup stars
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

String miliToMin(int mili){
  return nf(mili/1000 / 60, 2);
}

String miliToSeg(int mili){
  return nf(mili/1000 % 60, 2);
}


void mousePressed() {

  //pause/resume button
  if (buttons[1].containsMouseIn() && track.isPlaying()) { 
    buttons[1].setImg(play1);
    track.pause();
  } else {
    buttons[1].setImg(pause);
    track.play();
  }

  //goes back and choose other music
  if (buttons[3].containsMouseIn()) {
    noLoop();
    selectInput("Select a music file:", "finishSetup");
  }

  // terrible way to check if mouseclick on progressBar
  if( mouseX > width / 2 - 450  &&
      mouseX < width / 2 + 450  &&
      mouseY > height - 25      &&
      mouseY < height - 15)
    {
      int position = int( map( mouseX, width / 2 - 450, width / 2 + 450, 0, track.length() ) );
      track.cue( position );
    }
}

void keyPressed()
{
  if (key == ' '){
    if ( track.isPlaying() )
    {
      track.pause();
    }
    // if the player is at the end of the file,
    // we have to rewind it before telling it to play again
    else if ( track.position() == track.length() )
    {
      track.rewind();
      track.play();
    }
    else
    {
      track.play();
    }
  }
  
}

void stop() {
  track.close();
  minim.stop();
  super.stop();
}
