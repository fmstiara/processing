/*
ルイージの動き
 ＆
 後ろの背景の動き
 
 ジャンプしない
 */
Luigi L;
Background B;
int x = 0;
int px = 0;
int cnt = 0;
int threshold = 150;
boolean flag = false;

void setup() {
  size(960, 720);
  L = new Luigi();
  B = new Background();
  
  frameRate(40);
}

void draw() {
  background(-1);
  if (L.reach && L.v.x > 15.5) { 
    if ( (x - px) < threshold) {
      x+=10;
    } 
  }
  translate(-(x-px + threshold*cnt), 0);
  B.moveLine(L);
  B.draw();
  L.draw();
}

void keyPressed() {
  L.sidePressed();
}

void keyReleased() {
  px = (x/threshold)*threshold;
  cnt=x/threshold;
}