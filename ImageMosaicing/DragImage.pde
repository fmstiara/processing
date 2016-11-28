class DragImage {
  ArrayList<PVector> XY; //変換前の座標
  ArrayList<PVector> UV; //変換後の座標

  PGraphics pg;
  PVector sub;//位置差分
  PImage img;//変換前
  PImage result;//変換後

  boolean isDragged;
  boolean addXY;
  boolean isConverted;
  DragImage(PImage _img, int _x, int _y) {
    init(_img);
    sub = new PVector(_x, _y);

    updateGraphics();
  }

  void init(PImage _img) {
    img = _img;
    pg = createGraphics(width, height);
    result = createImage(width, height, ARGB);

    XY = new ArrayList();
    UV = new ArrayList();

    isDragged =false;
    addXY =true;
    isConverted = false;
  }

  void draw() {
    updateGraphics();
  }

  void keyPressed() {
    if (key==ENTER) {
      homography();
      isConverted = !isConverted;
    }
  }
  void mousePressed() {
    if (addXY) {
      XY.add(new PVector(mouseX-sub.x, mouseY-sub.y));
      println(XY);
      addXY = !addXY;
    } else {
      UV.add(new PVector(mouseX, mouseY-100));
      println(UV);
      addXY = !addXY;
    }
  }

  void updateGraphics() {

    if (isConverted)image(result, 0, 100);
    else {
      image(img, sub.x, sub.y);

      fill(255, 0, 0);
      for (PVector pos : XY) {
        ellipse(pos.x+sub.x, pos.y+sub.y, 20, 20);
      }
      fill(0, 255, 0);
      for (PVector pos : UV) {
        ellipse(pos.x, pos.y+100, 20, 20);
      }
    }
  }

  void homography() {
    RealMatrix H = getH();
    H = MatrixUtils.inverse(H);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        double[]a = {x, y, 1};
        RealVector v = MatrixUtils.createRealVector(a);
        v = H.operate(v);
        double b = v.getEntry(2);
        int _u = (int)(v.getEntry(0)/b);
        int _v = (int)(v.getEntry(1)/b);

        if (_u > 0 && _u < img.width && _v > 0 &&_v < img.height) {
          color c = img.get(_u, _v);
          result.set(x, y, c);
        } else {
          result.set(x, y, color(0, 0, 0, 0));
        }
      }
    }
    println("homography done");
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
    //showMatrix(M);
    return M;
  }

  RealVector getVectorB() {
    double[] v = new double[UV.size()*2];
    for (int i = 0; i < UV.size(); i++) {
      v[2*i] = UV.get(i).x;
      v[2*i+1] = UV.get(i).y;
    }
    RealVector V = MatrixUtils.createRealVector(v);
    //println("B");
    //showVector(V);
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
    //println("A");
    //showMatrix(M);
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
}
