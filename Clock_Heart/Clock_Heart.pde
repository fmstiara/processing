int w = 640;
int h = 640;

void setup(){
  size(w, h);
  
  
}

void draw(){
  background(-1);
  ellipse(w/2, h/2, w-40, h-40);
  
  PVector c = getClockPos();
  line(w/2,h/2, c.x, c.y);
}


PVector getClockPos(){
  int min = int(frameCount/20);
  float r = radians(min - 90);
  float y = h/2 + 250*sin(r);
  float x = w/2 + 250*cos(r);
  
  return new PVector(x,y);
}


