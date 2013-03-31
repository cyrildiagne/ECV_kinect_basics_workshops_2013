int numRoundsX = 32;
int numRoundsY = 24;
int roundSize = 20;

void setup() {
  size(640, 480, OPENGL);
  smooth();
}

void draw() {
  
  background(128);
  boolean isMouseInCircle;
  
  for( int i = 0; i< numRoundsX; i++) {
    for( int j = 0; j < numRoundsY; j++) {
      
      isMouseInCircle = mouseX > i*roundSize
                        && mouseX < (i+1)*roundSize
                        && mouseY > j*roundSize
                        && mouseY < (j+1)*roundSize;
      
      if(isMouseInCircle) {
        fill(0);
        ellipse(i*roundSize + roundSize*0.5, j*roundSize + roundSize*0.5, roundSize, roundSize);
      }
      else {
        fill(255);
        ellipse(i*roundSize + roundSize*0.5, j*roundSize + roundSize*0.5, roundSize, roundSize);
      }
    }    
  }
}
