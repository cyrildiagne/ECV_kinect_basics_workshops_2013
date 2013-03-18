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
  
  void updatePositions(Kinect kinect)
  {
    UserVisualsJoint joint;
    PVector position;
    for(int i=0; i<joints.size(); i++) {
      joint = (UserVisualsJoint)joints.get(i);
      position = kinect.getJointPosition(id, joint.id); 
      joint.setPosition(position);
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
    for(int i=0; i<joints.size(); i++) {
       joint = (UserVisualsJoint)joints.get(i);
       joint.addImage(library);
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
