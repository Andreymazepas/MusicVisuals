class Button {
  PVector pos; //position
  PImage img;
  color tint;
  int raio;

  Button(PImage _img, PVector _pos) {
    pos = _pos;
    img=_img;
    raio=100;
  }

  void inicio() { //play incial
    if (containsMouseIn()) {
      tint=50;
    } else {
      tint=200;
    }
    imageMode(CENTER);
    tint(tint);
    img.resize(2*raio, 2*raio);
    image(img, pos.x, pos.y);
  }

  void pp() { //play/pause
    if (containsMousePP()) {
      tint=50;
    } else {
      tint=200;
    }
    imageMode(CENTER);
    tint(tint);
    img.resize(50, 50);
    image(img, pos.x, pos.y);
  }
  
  void setImg(PImage img2){
    img=img2;
  }

  boolean containsMouseIn() {
    if (dist(pos.x, pos.y, mouseX, mouseY)<raio) {
      return true;
    } else {
      return false;
    }
  }
  
    boolean containsMousePP() {
    if (dist(pos.x, pos.y, mouseX, mouseY)<25) {
      return true;
    } else {
      return false;
    }
  }
}
