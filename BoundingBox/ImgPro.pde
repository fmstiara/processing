class ImgPro {
  PImage pre_img_live;
  PImage img_live;
  float [][]brightnesses;
  int [][]label;
  int threshold;
  HashMap<Integer, Integer>table;

  ImgPro() {
    pre_img_live = null;
    table=new HashMap<Integer, Integer>();
    threshold = 30;
  }

  void draw() {
    img_live = movie.copy();
    if (img_live!=null) {
      if (pre_img_live == null) {
        pre_img_live = img_live.copy();
        brightnesses = new float[img_live.width][img_live.height];
        label = new int[img_live.width][img_live.height];
      }
      if (brightnesses != null) {
        PImage sub = sub(pre_img_live, img_live);
        PImage bin = binarize(sub);

        PImage res = clopen(bin);
        labeling();
        image(img_live, 0, 0, 320, 180);
        image(pre_img_live, 320, 0, 320, 180);
        image(bin, 0, 180, 320, 180);
        image(res, 320, 180, 320, 180);
      }
    }
  }

  PImage clopen(PImage bin_) {
    PImage out = opening(closing(bin_));
    for (int y = 0; y < out.height; y++) {
      for (int x = 0; x < out.width; x++) {
        color out_color = out.get(x, y);
        float r = red(out_color);
        float g = green(out_color);
        float b = blue(out_color);

        float brightness = 0.299*r + 0.587*g + 0.114*b;
        if (brightness > threshold) {
          brightnesses[x][y] = 1;
        } else {
          brightnesses[x][y] = 0;
        }
      }
    }
    return out;
  }

  void labeling() {
    int count = 1;
    for (int y=1; y<img_live.height-1; y++) {
      for (int x=1; x<img_live.width-1; x++) {
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

    for (int y=1; y<img_live.height-1; y++) {
      for (int x=1; x<img_live.width-1; x++) {
        if (label[x][y]==0) {
        } else {
          label[x][y] = table.get(label[x][y]);
        }
      }
    }
    Collection l = table.values();
    //Iterator ite = ;
    println(table.values());
  }

  PImage sub(PImage pre, PImage live) {
    PImage sub_img = createImage(live.width, live.height, RGB);
    for (int y = 0; y < pre.height; y++) {
      for (int x = 0; x < pre.width; x++) {
        color pre_color = pre.get(x, y);
        color live_color = live.get(x, y);
        float r = abs(red(pre_color)-red(live_color));
        float g = abs(green(pre_color)-green(live_color));
        float b = abs(blue(pre_color)-blue(live_color));

        sub_img.set(x, y, color(r, g, b));
      }
    }

    return sub_img;
  }

  PImage binarize(PImage input) {
    PImage out = createImage(input.width, input.height, RGB);  
    for (int y = 0; y < input.height; y++) {
      for (int x = 0; x < input.width; x++) {
        color input_color = input.get(x, y);
        float r = red(input_color);
        float g = green(input_color);
        float b = blue(input_color);

        float brightness = 0.299*r + 0.587*g + 0.114*b;
        if (brightness > threshold) {
          out.set(x, y, color(255));
          brightnesses[x][y] = 1;
        } else {
          out.set(x, y, color(0));
          brightnesses[x][y] = 0;
        }
      }
    }
    return out;
  }

  PImage closing(PImage input) {
    // input img must be binarized
    int n = 5;
    for (int i = 0; i < n; i++) {
      input = dilation(input);
    }
    for (int i = 0; i < n; i++) {
      input = erosion(input);
    }
    return input;
  }
  PImage opening(PImage input) {
    // input img must be binarized
    int n = 5;
    for (int i = 0; i < n; i++) {
      input = erosion(input);
    }
    for (int i = 0; i < n; i++) {
      input = dilation(input);
    }
    return input;
  }

  PImage dilation(PImage input) {
    // input img must be binarized
    PImage out = createImage(input.width, input.height, RGB);
    out = input.copy();

    for (int y = 1; y < input.height-1; y++) {
      for (int x = 1; x < input.width-1; x++) {
        for (int i = -1; i<2; i++) {
          for (int j = -1; j<2; j++) {
            if (i==0&&j==0) {
            } else {
              if (brightnesses[x+i][y+j]==1) {
                out.set(x, y, color(255));
              }
            }
          }
        }
      }
    }
    return out;
  }

  PImage erosion(PImage input) {
    // input img must be binarized
    PImage out = createImage(input.width, input.height, RGB);
    out = input.copy();

    for (int y = 1; y < input.height-1; y++) {
      for (int x = 1; x < input.width-1; x++) {
        for (int i = -1; i<2; i++) {
          for (int j = -1; j<2; j++) {
            if (i==0&&j==0) {
            } else {
              if (brightnesses[x+i][y+j]==0) {
                out.set(x, y, color(0));
              }
            }
          }
        }
      }
    }
    return out;
  }
}