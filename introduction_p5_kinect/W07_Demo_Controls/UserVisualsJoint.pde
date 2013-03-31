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
  
  void setPosition(PVector pos)
  {
    velocity.x = pos.x - position.x;
    velocity.y = pos.y - position.y;
    velocity.z = pos.z - position.z;
    position = pos;
  }
  
  void addImage(PImage img_)
  {
    // make sure we've moved
    if(velocity.x*velocity.x + velocity.y*velocity.y + velocity.z*velocity.z < 120) return;
    
    Img img = new Img( img_, velocity.get() );
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
