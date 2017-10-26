CellularAutomaton ca;

void setup() {
  size(900, 600);
  //fullScreen();
  background(0);
  loadPixels();
  ca = new CellularAutomaton();
  ca.SetBirthProbability(20);
  ca.SetFontPosition(width/2, 50);
  ca.SetInterval(100);
  ca.Init();
}

void draw() {
  ca.Display();
}

void keyPressed() {
  if (key == 's' || key == 'S' || key == ' ') {
    ca.Toggle();  // start or stop iterating
  }
}