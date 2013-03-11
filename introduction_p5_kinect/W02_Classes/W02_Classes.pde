//-- W02_Classes / @kikko_fr
//-- ECV Kinect Workshop 2013 

Circle redCircle;
Circle greenCircle;

void setup() {
  
  // setup the size of the viewport and the renderer type
  size(640, 480, OPENGL);
  
  color red = color(255, 0, 0);
  redCircle = new Circle( red );
  
  color green = color(0, 255, 0);
  greenCircle = new Circle( green );
  
  // setup some drawing settings
  ellipseMode(CENTER);
  noStroke();
}

void draw() {
  
  // start drawing on a fresh new black background
  background(0, 0, 0);
  
  // update our circles first
  update();
  
  // then draw our circles
  redCircle.draw();
  greenCircle.draw();
}

// a custom function we've created
void update() {
  
  // update our circles
  redCircle.update();
  greenCircle.update();
}
