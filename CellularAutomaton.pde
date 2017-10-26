class CellularAutomaton {
  PFont consolas = createFont("Consolas", 32);
  int x, y, w, h;
  int fontX, fontY, interval, timeElapsed, GenerationCount;  
  int[] pixelsBuffer;
  float birthProbability;
  boolean isRunning;


  CellularAutomaton() {
    this(0, 100, width, height-100);
  }

  CellularAutomaton(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    timeElapsed = 0;
    GenerationCount = 0;
    isRunning = false;
    fill(0, 200, 0);
    textFont(consolas);
    textAlign(CENTER, CENTER);
  }

  void SetBirthProbability(float value) {
    birthProbability = value;
  }

  void SetFontPosition(int x, int y) {
    fontX = x;
    fontY = y;
  }

  void Init() {
    pixelsBuffer = new int[width*height];

    if (birthProbability == 0) birthProbability = floor(random(100));
    for (int xx=x; xx<x+w; xx++) {
      for (int yy=y; yy<y+h; yy++) {
        int index = xx + (yy * width);
        if (random(100) > birthProbability) {
          pixelsBuffer[index] = 0;
          pixels[index] = color(0);
        } else {
          pixelsBuffer[index] = 1;  // cell is alive
          pixels[index] = color(0, 200, 0);
        }
      }
    }
  }

  void Display() {
    if (Tick()) {
      Iterate();
      text("Generation number " + GenerationCount++, fontX, fontY);
    }
  }

  boolean Tick() {
    // short circuit evaluation
    if (isRunning && millis()-timeElapsed > interval) { 
      updatePixels();
      timeElapsed = millis();
      return true;
    } else return false;
  }

  void SetInterval(int interval) {
    this.interval = interval;
  }

  void Toggle() {
    isRunning = !isRunning;
  }

  void Iterate() {
    for (int i = 0; i < pixels.length; i++) {
      if (pixels[i] == color(0)) pixelsBuffer[i] = 0;
      else pixelsBuffer[i] = 1;
    }

    for (int xx=x; xx<x+w; xx++) {
      for (int yy=y; yy<y+h; yy++) {
        int index = xx + (yy * width);

        // check for neighbours
        int neighbours = 0;
        for (int xxx=xx-1; xxx<=xx+1; xxx++) {
          for (int yyy=yy-1; yyy<=yy+1; yyy++) {
            if (((xxx>=0)&&(xxx<x+w))&&((yyy>=0)&&(yyy<y+h))&&!((xxx==xx)&&(yyy==yy))) {
              if (pixelsBuffer[xxx + (yyy * width)] == 1) {
                neighbours ++;
              }
            }
          }
        }

        // cell is alive
        if (pixelsBuffer[index] == 1 && (neighbours < 2 || neighbours >= 4)) 
          pixels[index] = color(0);          // kill

        // cell is dead, and has three neighbours
        else if (neighbours == 3) 
          pixels[index] = color(0, 200, 0);  // spawn
      }
    }
    updatePixels();
  }
}