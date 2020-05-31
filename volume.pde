class Volume extends Button {
  AudioPlayer som;

  Volume(PImage _img, PVector _pos, AudioPlayer track1) {
    super(_img, _pos);
    som=track1;
  }

  void inicio() {
    stroke(200);
    strokeWeight(4);
    line(pos.x, pos.y-30, pos.x, pos.y-100);
  }
}
