class Star {
  float x;
  float y;
  float z;
  float setX;
  float setY;
  float r;

  Star() {
    x = random(-width, width);
    y = random(-height, height);
    z = random(width);
  } 

  void update() {
    z=z-speed;        
    if (z < 1) 
      z=width;
  }

  void render() {
    update();
    setX = map(x/z, 0, 1, 100, width);
    setY = map(y/z, 0, 1, 100, height);
    r=map(z, 0, width, 5, 1);
    noStroke();
    fill(255);
    pushMatrix();
    translate(width/2, height/2);
    ellipse(setX, setY, r, r);
    popMatrix();
  }
}
