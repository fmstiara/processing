import org.apache.commons.math3.linear.*;

DragImage p;
PImage img;
boolean isTint = true;
void setup() {
  size(1240, 960);
  img = loadImage("pic1.jpg");
  p = new DragImage(loadImage("pic2.jpg"), 640, 100);
  noStroke();
}

void draw() {
  background(-1);
  image(img, 0, 100);
  p.draw();
  
}

void keyPressed(){
  p.keyPressed();
}

void mousePressed(){
  p.mousePressed();
}