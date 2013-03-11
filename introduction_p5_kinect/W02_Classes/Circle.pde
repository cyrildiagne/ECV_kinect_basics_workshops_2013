class Circle
{
  
  // properties for animation
  float x;
  float y;
  float speedX;
  float speedY;
  
  color myColor;
  
  Circle(color initColor) {
    
    myColor = initColor;
    
    // init the default values of our properties
    x = 320;
    y = 240;
    speedX = random(3) + 2;
    speedY = random(3) + 2;
  }
  
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
  
  void draw() {
    
    // draw our circle in red
    fill(myColor);
    ellipse(x, y, 50, 50);
  }
}
