//-- UserVisuals / @kikko_fr
//-- ECV Kinect Workshop 2013 

class UserVisuals
{
  int id;
  ArrayList joints;
  
  UserVisuals(int userId)
  {
    id = userId;
    joints = new ArrayList();
  }
  
  void updatePositions(Kinect kinect, PVector orientation)
  {
    UserVisualsJoint joint;
    PVector position;
    for(int i=0; i<joints.size(); i++) {
      joint = (UserVisualsJoint)joints.get(i);
      position = kinect.getJointPosition(id, joint.id); 
      joint.setPosition(position, orientation);
    }
  }
  
  void addJoint(int jointId)
  {
    UserVisualsJoint joint = new UserVisualsJoint(jointId);
    joints.add(joint);
  }
  
  void addImage(Library library)
  {
    UserVisualsJoint joint;
    PImage img;
    for(int i=0; i<joints.size(); i++) {
       
      joint = (UserVisualsJoint)joints.get(i);
       
       img = library.getImageAt(0);
       
       /*
       if(joint.id == SimpleOpenNI.SKEL_LEFT_HAND ) {
         img = library.getRandomImage();
       }
       else if(joint.id == SimpleOpenNI.SKEL_HEAD) {
         img = library.getImageAt(0);
       }
       else {
         img = library.getImageAt(1);
       }
       */
       joint.addImage(img);
    }
  }
  
  void draw(PApplet ctx)
  {
      UserVisualsJoint joint;
      for(int i=0; i<joints.size(); i++) {
        joint = (UserVisualsJoint)joints.get(i);
        joint.draw(ctx);
      }
  }
}
