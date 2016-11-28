int [][]brightnesses;
int [][]label;
HashMap<Integer, Integer>table=new HashMap<Integer, Integer>();
PImage p;
void setup() {
  size(100, 100);
  brightnesses = new int[width][height];
  label = new int[width][height];
  p = loadImage("bw.jpg");
}

void draw() {
  background(0);
  fill(-1);
  rect(100, 100, 50, 50);
  setBrightnesses();
  labeling();
}

void setBrightnesses() {
  for (int y = 1; y < height-1; y++) {
    for (int x = 1; x < width-1; x++) {
      color c = p.get(x, y);
      float r = red(c);
      float g = green(c);
      float b = blue(c);

      float brightness = 0.299*r + 0.587*g + 0.114*b;
      if (brightness > 30) {
        brightnesses[x][y] = 1;
      } else {
        brightnesses[x][y] = 0;
      }
    }
  }
}
void labeling() {
  int count = 1;
  for (int y=1; y<height-1; y++) {
    for (int x=1; x<width-1; x++) {
      if (brightnesses[x][y]==1) {
        if (brightnesses[x][y-1]==0) {
          if (brightnesses[x-1][y]==1) {
            label[x][y] = label[x-1][y];
          } else {
            label[x][y] = count;
            table.put(count, count);
            count++;
          }
        } else if (brightnesses[x][y-1]==1) {
          if (brightnesses[x-1][y]==1) {
            int above = label[x][y-1];
            int left = label[x-1][y];
            label[x][y] = (above<left)?above:left;
            table.put((above>left)?above:left, label[x][y]);
          } else {
            label[x][y] = label[x][y-1];
          }
        }
      }
    }
  }

  for (int y = 1; y < height-1; y++) {
    for (int x = 1; x < width-1; x++) {
      print(label[x][y]);
    }
    println("");
  }
  
  for (int y=1; y<height-1; y++) {
    for (int x=1; x<width-1; x++) {
      if (label[x][y]==0) {
      } else {
        label[x][y] = table.get(label[x][y]);
      }
    }
  }
  
  for (int y = 1; y < height-1; y++) {
    for (int x = 1; x < width-1; x++) {
      print(label[x][y]);
    }
    println("");
  }
  println("");
  println(table);
}