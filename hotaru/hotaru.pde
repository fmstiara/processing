int w, h;
final int CELL_SIZE = 2;
final boolean DEAD = false;
final boolean ALIVE = true;
int cell_row;
int cell_col;

boolean [][]field;
boolean [][]tmpField;
PVector [][]ab;

void setup() {
  size(displayWidth, displayHeight);
  w = width;
  h = height;
  cell_row = w/CELL_SIZE + 2;
  cell_col = h/CELL_SIZE + 2;
  field = new boolean[cell_row][cell_col];
  tmpField = new boolean[cell_row][cell_col];
  ab = new PVector[cell_row][cell_col];
  
  noStroke();
  colorMode(HSB, 100, 100, 100);
  
  initialization();
}

void draw() {
  background(0);
  
  getNextCell();
  setNextCell();
  
  fill(28+4*abs(sin(radians(frameCount))), 100, 40 + 10*cos(radians(frameCount*3)));
  float isou = 100*sin( radians(frameCount) );
  for (int y = 1; y < cell_col-1; y++) {
    for (int x = 1; x < cell_row-1; x++) {
      float addX = ab[x][y].x*isou;
      float addY = ab[x][y].y*isou;
      if(field[x][y])rect((x-1)*CELL_SIZE + addX, (y-1)*CELL_SIZE + addY, CELL_SIZE, CELL_SIZE);
    }
  }
    
}

void initialization() {
  for (int y = 0; y < cell_col; y++) {
    for (int x = 0; x < cell_row; x++) {
      field[x][y] = (random(0, 2)>1)?ALIVE:DEAD;
      ab[x][y] = new PVector(int(random(-5,5)),int(random(-5,5)) );
    }
  }
}

void getNextCell() {
  for (int y = 1; y < cell_col-1; y++) {
    for (int x = 1; x < cell_row-1; x++) {

      int alive_cells_size = countAliveCells(x, y);
      
      if (field[x][y]) {
        //when the cell is alive
        if (alive_cells_size == 2 || alive_cells_size == 3) {
          tmpField[x][y] = ALIVE;
        } else {
          tmpField[x][y] = DEAD;
        }
      } else {
        //when the cell is dead
        if (alive_cells_size == 3) {
          tmpField[x][y] = ALIVE;
        } else {
          tmpField[x][y] = DEAD;
        }
      }
    }
  }
}

void setNextCell() {
  for (int y = 1; y < cell_col-1; y++) {
    for (int x = 1; x < cell_row-1; x++) {
      field[x][y] = tmpField[x][y];
    }
  }
}

int countAliveCells(int _x, int _y) {
  int counter = 0;
  for (int y = -1; y < 2; y++) {
    for (int x = -1; x < 2; x++) {
      if (x == 0&& y==0) {
      } else {
        if (field[_x+x][_y+y]) {
          counter++;
        }
      }
    }
  }
  return counter;
}