import ddf.minim.analysis.*;
import ddf.minim.*;

//som
Minim minim;
AudioPlayer track1;
FFT fft;

float speed;
int mode;

//universo
Estrela[] estrelas = new Estrela[400];

//circunferencia principal
Circle[] circle = new Circle[5];

//botao
PImage inicio, play1, pause, volume, voltar;
Button[] buttons = new Button[5];
boolean hasChosenTrack = false;

void setup() {
  
  //fullScreen(P3D);
  size(1280, 720, P3D);
  mode=0;

  //botao e imagem
  inicio = loadImage("play.png");
  play1 = loadImage("play1.png");  
  pause = loadImage("pause.png");
  volume = loadImage("vol.png");
  voltar = loadImage("voltar.png");
  buttons[0] = new Button(inicio, new PVector(width/2, height/2)); //inicio
  buttons[1] = new Button(pause, new PVector(30, height-30)); //play/pause
  buttons[2] = new Button(volume, new PVector(width/2 + 600, height-30)); //volume
  buttons[3] = new Button(voltar, new PVector(width/2+600, 50)); //volta/encerra visualizacao

  //som
  minim = new Minim(this);
  selectInput("Select a file to process:", "finishSetup");
  noLoop();
  //universo
  smooth();
  stroke(255);
  strokeWeight(5);
  for (int i=0; i<estrelas.length; i++) {
    estrelas[i] = new Estrela();
  }

}

void finishSetup(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    track1 = minim.loadFile(selection.getAbsolutePath());
    fft = new FFT(track1.bufferSize(), track1.sampleRate());
  //circunferencia central
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
  if(hasChosenTrack){
    fft.forward(track1.mix);

    //Inicio
    if (mode == 0) {
      background(0);
      for (int i = 0; i < buttons.length; i++) {
        buttons[0].inicio();
      }
    }

    //Tela de reproducao
    if (mode==1) { 
      background(0);
      visualizador();

      //desenha os botoes
      for (int i = 0; i < buttons.length; i++) {
        buttons[1].pp(); 
        buttons[2].pp();
        buttons[3].pp();
      }
    }

    //Reinicia
    if (mode == 2) {
      background(0);
      setup();
      for (int i = 0; i < buttons.length; i++) {
        buttons[0].inicio();
      }
    }

    //velocidade das estrelas em funcao da frequencia
    for (int i = 0; i< fft.specSize(); i++) {
      speed = fft.getFreq(i);
    }
  }

}

void visualizador() {
  noStroke();
  
  //circunferencia - ellipse central
  for (int i = 0; i < circle.length; i++) {
    circle[i].desenha1();
    circle[i].desenha2();
    circle[i].desenha3();
    circle[i].desenha4();
    circle[i].desenha5();
  }

  //universo - background
  for (int i=0; i<estrelas.length; i++) {
    estrelas[i].desenha();
    estrelas[i].update();
  }
}

void mousePressed() {
  
  //tela de inicio desencadeia reproducao
  if (buttons[0].containsMouseIn()) {
    track1.play();
    mode=1;
  } 

  //Interacao com o botao play/pause
  if (buttons[1].containsMousePP() && track1.isPlaying()) { 
    for (int i = 0; i < buttons.length; i++) {
      buttons[1].setImg(play1);
      track1.pause();
    }
  } else {
    buttons[1].setImg(pause);
    track1.play();
  }

  //botao para retornar a tela de inicio e reiniciar reproducao
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
