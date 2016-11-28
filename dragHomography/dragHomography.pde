import org.apache.commons.math3.linear.*;

ArrayList<PVector> XY;
ArrayList<PVector> UV;

PImage test;
PImage result;
void setup() {
  size(500, 400);

  XY = new ArrayList();
  UV = new ArrayList();
  test = loadImage("neko.png");
  result = createImage(500, 400, RGB);
  setPos();
  
  homography();
  image(result, 0 ,0);
  for (PVector pos : UV) {
    fill(255,0,0);
    ellipse(pos.x, pos.y, 20, 20);
  }
}

void draw() {
}

void homography() {
  RealMatrix H = getH();
  H = MatrixUtils.inverse(H);

  for (int y = 0; y < 400; y++) {
    for (int x = 0; x < 500; x++) {
      double[]a = {x, y, 1};
      RealVector v = MatrixUtils.createRealVector(a);
      v = H.operate(v);
      double b = v.getEntry(2);
      int _u = (int)(v.getEntry(0)/b);
      int _v = (int)(v.getEntry(1)/b);
      result.set(x, y, test.get(_u, _v));
    }
  }
}

void setPos() {
  XY.add(new PVector(0, 0));
  XY.add(new PVector(500, 0));
  XY.add(new PVector(500, 400));
  XY.add(new PVector(0, 400));

  UV.add(new PVector(0, 0));
  UV.add(new PVector(500, 0));
  UV.add(new PVector(500, 400));
  UV.add(new PVector(0, 400));
}

void mouseDragged() {
  for (PVector pos : UV) {
    if (dist(mouseX, mouseY, pos.x, pos.y) < 10) {
      pos.x = mouseX;
      pos.y = mouseY;
      fill(0,0,255);
      ellipse(pos.x, pos.y, 10,10);
    }
  }
}

void mouseReleased() {
  background(-1);
  
  homography();
  image(result, 0, 0);
  for (PVector pos : UV) {
    fill(255,0,0);
    ellipse(pos.x, pos.y, 20, 20);
  }
}

void moveUV() {
}

RealMatrix getH() {
  double[]v = new double[8];

  RealMatrix A = getMatrixA();
  RealMatrix At = A.transpose();
  RealMatrix _a = A.multiply(At);
  _a = MatrixUtils.inverse(_a);
  RealMatrix m = At.multiply(_a);

  RealVector B = getVectorB();
  RealVector r = m.operate(B);
  v = r.toArray();
  double [][]res = new double[3][3];
  for (int y = 0; y < 3; y++) {
    for (int x = 0; x < 3; x++) {
      if (y*3+x < 8) {
        res[y][x] = v[y*3+x];
      }
    }
  }
  res[2][2] = 1;

  RealMatrix M = MatrixUtils.createRealMatrix(res);
  showMatrix(M);
  return M;
}

/*
x = (at*a)-1 * at * b
 */

/* 
 in : xy
 out : uv
 */

RealVector getVectorB() {
  double[] v = new double[UV.size()*2];
  for (int i = 0; i < UV.size(); i++) {
    v[2*i] = UV.get(i).x;
    v[2*i+1] = UV.get(i).y;
  }
  RealVector V = MatrixUtils.createRealVector(v);
  println("B");
  showVector(V);
  return V;
}
RealMatrix getMatrixA() {
  double[][]array_v = new double[XY.size()*2][8];
  for (int i = 0; i < XY.size(); i++) {
    float x = XY.get(i).x;
    float y = XY.get(i).y;
    float u = UV.get(i).x;
    float v = UV.get(i).y;
    array_v[2*i][0] = x;
    array_v[2*i][1] = y;
    array_v[2*i][2] = 1;
    array_v[2*i][3] = 0;
    array_v[2*i][4] = 0;
    array_v[2*i][5] = 0;
    array_v[2*i][6] = -1*x*u;
    array_v[2*i][7] = -1*y*u;

    array_v[2*i+1][0] = 0;
    array_v[2*i+1][1] = 0;
    array_v[2*i+1][2] = 0;
    array_v[2*i+1][3] = x;
    array_v[2*i+1][4] = y;
    array_v[2*i+1][5] = 1;
    array_v[2*i+1][6] = -1*x*v;
    array_v[2*i+1][7] = -1*y*v;
  }

  RealMatrix M = MatrixUtils.createRealMatrix(array_v);
  println("A");
  showMatrix(M);
  return M;
}

void showMatrix(RealMatrix M) {
  println("---");
  for (int i=0; i<M.getRowDimension(); i++) {
    for (int j=0; j<M.getColumnDimension(); j++) {

      print( M.getEntry(i, j) + "  " );
    }
    println();
  }
  println("---");
  println();
}

void showVector(RealVector v) {
  println("---");
  for (int i=0; i<v.getDimension(); i++) {
    println( v.getEntry(i) );
  }
  println("---");
  println();
}