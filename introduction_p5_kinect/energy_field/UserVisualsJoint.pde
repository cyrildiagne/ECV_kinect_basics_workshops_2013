//-- UserVisualsJoint / @kikko_fr
//-- ECV Kinect Workshop 2013 

class UserVisualsJoint
{
  ArrayList imgs;
  int id;
  PVector position;
  PVector velocity;
  
  UserVisualsJoint(int jointId_)
  {
    id = jointId_;
    position = new PVector();
    velocity = new PVector();
    imgs = new ArrayList();
  }
  
  void setPosition(PVector pos, PVector orientation)
  {
    /*
    velocity.x = pos.x - position.x;
    velocity.y = pos.y - position.y;
    velocity.z = pos.z - position.z;
    */
    velocity = orientation.get();
    
    velocity.y = -velocity.y;
    position = pos;
  }
  
  void addImage(PImage img_)
  {
    PVector v = PVector.mult(velocity, random(80)+20);
    Img img = new Img( img_, v );
    img.x = position.x;
    img.y = position.y;
    img.z = position.z;
    imgs.add(img);
  }
  
  void draw(PApplet ctx)
  {
    Img img;
    for(int i=0; i< imgs.size(); i++) {
      img = (Img)imgs.get(i); 
      if( !img.update() ) {
        imgs.remove(i);
        i--;
      }
      else {
        img.draw(ctx);
      }
    }
  } 
}
