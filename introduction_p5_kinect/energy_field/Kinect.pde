//-- Kinect / @kikko_fr
//-- ECV Kinect Workshop 2013 

import SimpleOpenNI.*;

class Kinect
{
  SimpleOpenNI  context;
  Object callbackObject;
  
  Kinect(Object callbackObject_) {
    
    context = new SimpleOpenNI((PApplet)callbackObject_);
    context.enableRGB();
    context.setMirror(true);
    
    callbackObject = callbackObject_;
    
    // enable depthMap generation 
    if(context.enableDepth() == false)
    {
       println("Can't open the depthMap, maybe the camera is not connected!"); 
       exit();
       return;
    }
    
    // enable skeleton generation for all joints
    context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  }
  
  // update the cam
  void update() {
    context.update();
  }
  
  PVector getHeadPositionForUser(int userId) {
    return getJointPosition(userId, SimpleOpenNI.SKEL_HEAD);
  }
  
  PVector getHandPositionForUser(int userId, boolean bLeftHand) {
    int hand = bLeftHand ? SimpleOpenNI.SKEL_LEFT_HAND : SimpleOpenNI.SKEL_RIGHT_HAND;
    return getJointPosition(userId, hand);
  }

  PVector getJointPosition(int userId, int joint) {
    PVector jointPos = new PVector();
    PVector pJointPos = new PVector();
    context.getJointPositionSkeleton(userId, joint, jointPos);
    context.convertRealWorldToProjective(jointPos, pJointPos); 
    return pJointPos;
  }


// -----------------------------------------------------------------
// Debug draw functions

  void drawDebug() {
    drawDepthImage();
    drawSkeletons();
  }

  // draw the skeleton if it's available
  void drawSkeletons() {
    int[] userList = context.getUsers();
    for(int i=0;i<userList.length;i++)
    {
      if(context.isTrackingSkeleton(userList[i]))
        drawSkeleton(userList[i]);
    }  
  }
  
  // draw the skeleton with the selected joints
  void drawSkeleton(int userId)
  {
    stroke(0,0,255);
    strokeWeight(3);
    
    context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
  }
  
  void drawColorImage() {
    drawColorImage(0,0);
  }
  void drawColorImage(int x, int y) {
    image(context.rgbImage(),x,y);
  }
  
  void drawDepthImage() {
    drawDepthImage(0,0);
  }
  void drawDepthImage(int x, int y) {
    image(context.depthImage(),x,y);
  }
}
