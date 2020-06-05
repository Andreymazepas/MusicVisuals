class Button {
  PVector pos;
  PImage img;
  color tint;
  int radius;

  Button(PImage _img, PVector _pos) {
    pos = _pos;
    img=_img;
    radius=50;
    imageMode(CENTER);
    img.resize(50, 50);
  }

  void update() {
    if (containsMouseIn()) {
      tint(50);
    } else {
      tint(200);
    }
    image(img, pos.x, pos.y);
  }

  
  void setImg(PImage newImg){
    img=newImg;
    imageMode(CENTER);
    img.resize(50, 50);
  }

  boolean containsMouseIn() {
    return dist(pos.x, pos.y, mouseX, mouseY)<radius;
  }
}
