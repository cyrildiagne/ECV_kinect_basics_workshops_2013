//-- W00_Base / @kikko_fr
//-- ECV Kinect Workshop 2013 

void setup() {
  
  // setup the size of the viewport
  size(640, 480);
  
  // setup some drawing settings
  ellipseMode(CENTER);
  noStroke();
}

void draw() {
  
  // start drawing on a fresh new black background
  background(0, 0, 0);
  
  // draw our circle in red
  fill(255, 0, 0);
  ellipse(mouseX, mouseY, 50, 50);
}
