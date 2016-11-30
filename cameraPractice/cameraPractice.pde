PVector eye, center, up;


void setup(){
  size(400,400,P3D);
  eye = new PVector(0,0,200);
  center = new PVector(width/2,height/2,0);
  up = new PVector(0,1,0);
  
}


void draw(){
  camera(
    eye.x, eye.y, eye.z, 
    center.x, center.y, center.z,
    up.x, up.y, up.z
  );
  
  translate(200,200);
  background(-1);
  box(100);
  
}

void mouseMoved(){
  eye.x = mouseX;
  eye.y = mouseY;
}


