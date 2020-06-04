class Sphere {
  float[] x,y;
  float[] angle1;
  float[] angle2;
  float transPos;
  float transPos2;
 

  Sphere(float transPos, float transPos2) {
    angle1 = new float[fft.specSize()];
    angle2 = new float[fft.specSize()];
    x = new float[fft.specSize()];
    y = new float[fft.specSize()];
    this.transPos=transPos;
    this.transPos2=transPos2;
    
  } 

  void desenha1() {
    noStroke();
    pushMatrix();
    translate(width/2, height/2, 0);
    for (int i = 0; i < fft.specSize(); i++) {
      angle1[i] = angle1[i]+fft.getFreq(i)/2000;
      rotateX(sin(angle1[i]/5)/30);
      rotateY(cos(angle1[i]/5)/30);
      fill(20, 255-fft.getFreq(i)*2, 255-fft.getBand(i)*5); 
      pushMatrix();
      translate((x[i]+transPos), (x[i]+transPos2));
      box(fft.getFreq(i)/50+fft.getFreq(i)/100);
      popMatrix();
    }
    popMatrix();
  }
  void desenha2(){
    noStroke();
    pushMatrix();
    translate(width/2, height/2, 0);
    for (int i = 0; i < fft.specSize(); i++) {   
      angle2[i] = angle2[i]+fft.getFreq(i)/2000;
      rotateX(sin(angle2[i]/10)/30);
      rotateY(cos(angle2[i]/10)/30);
      fill(30, 255-fft.getFreq(i), 255-fft.getBand(i)*2); 
      pushMatrix();
      translate((x[i]+transPos), (x[i]+transPos2));
      box(fft.getFreq(i)/100+fft.getFreq(i)/50);
      popMatrix();
    }
    popMatrix();
  }
  void desenha3(){
    noStroke();
    pushMatrix();
    translate(width/2, height/2, 0);
    for (int i = 0; i < fft.specSize(); i++) {
      angle1[i] = angle1[i]+fft.getFreq(i)/1500;
      rotateX(-sin(angle1[i]/5)/30);
      rotateY(-cos(angle1[i]/5)/30);
      fill(180, 255-fft.getFreq(i)*5, 255-fft.getBand(i)*5); 
      pushMatrix();
      translate((x[i]+transPos), (x[i]+transPos2));
      box(fft.getFreq(i)/60+fft.getFreq(i)/60);
      popMatrix();
    }
    popMatrix();
  }
  void desenha4(){
    noStroke();
    pushMatrix();
    translate(width/2, height/2, 0);
    for (int i = 0; i < fft.specSize(); i++) {
      angle2[i] = angle2[i]+fft.getFreq(i)/1000;
      rotateX(sin(angle2[i]/5)/50);
      rotateY(-cos(angle2[i]/5)/50);
      fill(70, 255-fft.getFreq(i)*5, 255-fft.getBand(i)*2); 
      pushMatrix();
      translate((x[i]+transPos), (x[i]+transPos2));
      box(fft.getFreq(i)/40+fft.getFreq(i)/100);
      popMatrix();
    }
    popMatrix();
  }
  
  void desenha5(){
     noStroke();
    pushMatrix();
    translate(width/2, height/2, 0);
    for (int i = 0; i < fft.specSize(); i++) {
      angle2[i] = angle2[i]+fft.getFreq(i)/1800;
      rotateX(-sin(angle1[i]/5)/40);
      rotateY(cos(angle1[i]/5)/40);
      fill(200, 255-fft.getFreq(i)*5, 255-fft.getBand(i)*5); 
      pushMatrix();
      translate((x[i]+transPos), (x[i]+transPos2));
      box(fft.getFreq(i)/100+fft.getFreq(i)/100);
      popMatrix();
    }
    popMatrix();
  } 
}
