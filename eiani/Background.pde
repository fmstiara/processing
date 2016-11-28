class Background{
  int x;
  PImage back;
  Background(){
    init();
  }
  
  void init(){
    this.x=0;
    back = loadImage("back.png");
  }
  
  void draw(){
    image(back, x, 0,1728*2, 720);
  }
  //
  
  void moveLine(Luigi _L){
    if(_L.reach && _L.is_moving){
      this.x-=_L.v.x;
      if(abs(this.x) > 1728)x=0;
    } else if (!keyPressed && _L.is_moving){
      this.x-=_L.v.x;
      if(abs(this.x) > 1728)x=0;
    }
    
  }
}
