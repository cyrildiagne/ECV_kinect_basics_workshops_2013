//-- KinectDemo - by kikko.fr
//-- ECV Kinect Workshop 2013 

class User
{
  int id;
  Particles[] particles;
  
  User(int userId) {
    id = userId;
    
    particles = new Particles[3];
    
    particles[0] = new Particles(1.0);
    particles[1] = new Particles(0.5);
    particles[2] = new Particles(0.5);
  }
  
  void setHeadPosition(PVector pos) {
    particles[0].x = (int)pos.x;
    particles[0].y = (int)pos.y;
  }
  
  void setLeftHandPosition(PVector pos) {
    particles[1].x = (int)pos.x;
    particles[1].y = (int)pos.y;
  }
  
  void setRightHandPosition(PVector pos) {
    particles[2].x = (int)pos.x;
    particles[2].y = (int)pos.y;
  }
  
  void draw() {
    // skip the head
    for(int i=1; i<3; i++)
      particles[i].draw();
  }
}
