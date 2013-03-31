//-- W03_Arrays / @kikko_fr
//-- ECV Kinect Workshop 2013 

int numCircles;
Circle[] circles;

void setup() {
  
  // setup the size of the viewport and the renderer type
  size(640, 480, OPENGL);
  
  numCircles = 10;
  circles = new Circle[numCircles];
  
  for(int i=0; i<numCircles; i++) {
    
    color randomColor = color( random(255), random(255), random(255) );
    circles[i] = new Circle(randomColor);
  }
  
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
  for(int i=0; i<numCircles; i++) {
    circles[i].draw();
  }
}

// a custom function we've created
void update() {
  
  // update our circles
  for(int i=0; i<numCircles; i++) {
    circles[i].update();
  }
}
