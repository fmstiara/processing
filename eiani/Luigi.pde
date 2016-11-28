class Luigi {
  //
  PVector pos, v, a;//座標, 速度, 加速度
  float m, mu, g;//質量, 摩擦係数
  float time=0;
  //
  boolean is_moving;
  boolean reach; //真ん中越えた
  boolean accel;
  int num;
  int direction;
  //
  PImage []img;
  Luigi() {
    pos = new PVector(200, 580);
    v = new PVector(0, 0);
    a = new PVector(0, 0); 

    m = 50.0;//50kg
    mu = 0.095;//摩擦係数
    g = 9.8;//9.8m/s^2

    is_moving = false;
    reach = false;
    accel = false;

    img = new PImage[8];
    for (int i = 1; i < 9; i++) {
      img[i-1] = loadImage(i+".png");
    }
  }

  void init() {
  }

  void draw() {

    if (!keyPressed)forceToObject(0);

    fill(200);
    noStroke();
    pushMatrix();
    translate(pos.x, 0);
    if (is_moving) {
      num = (frameCount/3)%8;
    }
    scale(direction, 1);
    image(img[num], -100, pos.y-60, 200, 112);
    popMatrix();
  }



  void forceToObject(int force) {
    int vdirection = int(v.x/abs(v.x));
    float R = vdirection * (mu * m * g); //50*9.8*0.2

    //運動方程式
    a.x = (force - R)/m;

    //速度、変位の計算

    v.add(a); 
    if (abs(v.x) > 16) {
      v.x = vdirection * 16;
    }

    if (abs(v.x) < 2.0) {
      //止まらせる
      is_moving = false;
    } else {
      is_moving = true;
      pos.add(v);
    }

    //位置調整
    if (direction == 1) {
      if (pos.x > 600+threshold*cnt) {
        pos.x = 600+threshold*cnt;
        reach = true;
      }
    } else if (direction == -1) {
      if (pos.x < 320+threshold*cnt) {
        pos.x = 320+threshold*cnt;
        reach = true;
      }
    } else {
      reach = false;
    }
  }


  void sidePressed() {

    int num = 120;

    if (keyCode == RIGHT) {
      direction = 1;
      forceToObject(num);
      draw();
    } else if (keyCode == LEFT) {
      direction = -1;
      forceToObject(-num);
      draw();
    }
  }

  void sideReleased() {
  }
}

