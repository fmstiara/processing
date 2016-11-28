final int cellSize = 4;
int cellNumX, cellNumY;
int[][]cellStatus;

void setup() {
  size(640, 480);

  cellInit();
  noStroke();
}

void draw() {
  background(20);
  updateCells();
  drawCells();
  
}

void cellInit() {
  cellNumX = width/cellSize;
  cellNumY = height/cellSize;

  cellStatus = new int[cellNumX+2][cellNumY+2];
  for (int y = 1; y<=cellNumY; y++) {
    for (int x = 1; x<=cellNumX; x++) {
      cellStatus[x][y] = int(random(0, 2));
    }
  }
}

void drawCells() {
  for (int y = 1; y<=cellNumY; y++) {
    for (int x = 1; x<=cellNumX; x++) {
      noFill();
      if(cellStatus[x][y]==1){
        fill(0,200,0);
      }
      rect(cellSize*(x-1),cellSize*(y-1),cellSize,cellSize);
    }
  }
}

void updateCells() {
  int[][]tmpCells = new int[cellNumX+2][cellNumY+2];
  for (int y = 1; y<=cellNumY; y++) {
    for (int x = 1; x<=cellNumX; x++) {
      int amongCellNum = getAmongStatus(x, y);

      if (cellStatus[x][y] == 1) {
        if (amongCellNum == 2 || amongCellNum == 3) {
          tmpCells[x][y] = 1;
        } else {
          tmpCells[x][y] = 0;
        }
      } else {
        if (amongCellNum == 3) {
          tmpCells[x][y] = 1;
        } else {
          tmpCells[x][y] = 0;
        }
      };
    }
  }
  
  for (int y = 1; y<=cellNumY; y++) {
    for (int x = 1; x<=cellNumX; x++) {
      cellStatus[x][y] = tmpCells[x][y];
    }
  }
}

int getAmongStatus(int x, int y) {
  int counter = 0;
  for (int ay = -1; ay<=1; ay++) {
    for (int ax = -1; ax<=1; ax++) {
      if (ax == 0&& ay == 0) {//not count
      } else if (cellStatus[x+ax][y+ay]==1) {
        counter++;
      }
    }
  }
  return counter;
}