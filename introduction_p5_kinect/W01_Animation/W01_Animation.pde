//-- W01_Animation / @kikko_fr
//-- ECV Kinect Workshop 2013 

// properties for animation
float x;
float y;
float speedX;
float speedY;

void setup() {
  
  // setup the size of the viewport and the renderer type
  size(640, 480, OPENGL);
  
  // init the default values of our properties
  x = 320;
  y = 240;
  speedX = random(13) + 2;
  speedY = random(13) + 2;
  
  // setup some drawing settings
  ellipseMode(CENTER);
  noStroke();
}

void draw() {
  
  // start drawing on a fresh new black background
  background(0, 0, 0);
  
  // update our properties first
  update();
  
  // draw our circle in red
  fill(255, 0, 0);
  ellipse(x, y, 50, 50);
}

// a custom function we've created
void update() {
  
  // move our circles
  x = addSpeed(x, speedX);
  y = addSpeed(y, speedY);
  
  // make the circle bounce if it reaches the side of the window
  if ((x > width) || (x < 0)) {
    speedX = speedX * -1;
  }
  if ((y > height) || (y < 0)) {
    speedY = speedY * -1;
  }
}

// function that add a speed to a value
float addSpeed(float value, float speed) {
  return value + speed;
}
