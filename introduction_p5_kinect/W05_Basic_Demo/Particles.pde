//-- KinectDemo - by kikko.fr
//-- ECV Kinect Workshop 2013 

static int MAX_ITEMS = 50;

class Particles
{
  float scale;
  
  int x;
  int y;
  
  int[] xpos = new int[MAX_ITEMS];
  int[] ypos = new int[MAX_ITEMS];

  Particles(float scale_) {
    scale = scale_;
    
    x = 0;
    y = 0;
    for (int i = 0; i < xpos.length; i++) {
      xpos[i] = 0;
      ypos[i] = 0;
    }
  }

  void draw () {
    
    update();
    
    for (int i = 0; i < xpos.length; i++) {
      noStroke();
      fill(125+i*2.5, i*5, 0);
      ellipse(xpos[i],ypos[i],i*scale,i*scale);
    }
  }

  void update () {
    
    for (int i = 0; i < xpos.length-1; i++) {
      xpos[i] = xpos[i+1];
      ypos[i] = ypos[i+1];
    }
    
    xpos[xpos.length-1] = x;
    ypos[ypos.length-1] = y;
  }
}
