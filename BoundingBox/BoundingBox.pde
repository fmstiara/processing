
/*
◦ 2枚の画像から差分画像を計算する関数
◦ 2値化処理を行う関数
◦ 2値画像に対する膨張処理を行う関数
◦ 2値画像に対する収縮処理を行う関数
◦ 2値画像に対するラベリングを行う関数
◦ ラベリング結果を表示する関数(※あると良い)
◦ ラベル付けされた領域ごとにbounding boxを計算する関数
*/
import java.util.*;
import processing.video.*;
ImgPro ip;
Movie movie;
void setup(){
  size(640, 360);
  movie = new Movie(this, "cup.mp4");
  movie.loop();

  ip = new ImgPro();
  
}

void draw(){
  ip.draw();
}

void movieEvent(Movie m){
  m.read();
}