//-- laser / @kikko_fr
//-- ECV Kinect Workshop 2013 

Library   library;

Kinect    kinect;
ArrayList userVisuals;

float frequence = 1;
float initScale = 1;
float initAlpha = 1;
float alphaModifier = 1;
float speedModifier = 0.95;
float scaleModifier = 0.95;
float to_rotationRandom = 180;
float to_rotation = 180;
float scaleMax = 2;

int frameNum;

PVector mousePos;
ArrayList debugImgs;

void setup()
{
  size(640, 480, OPENGL);
  
  frameNum = 0;
    
  kinect = new Kinect(this);
  userVisuals = new ArrayList();
  
  library = new Library();
  
  smooth();
}

void draw()
{
  background(128);
  tint(255, 255);
  
  kinect.update();
  kinect.drawColorImage();
  kinect.drawSkeletons();
  
  updateUsers();
  drawUsers();
}

void drawDebugImgs()
{
  Img img;
  for(int i=0; i< debugImgs.size(); i++) {
    img = (Img)debugImgs.get(i); 
    if( !img.update() ) {
      debugImgs.remove(i);
      i--;
    }
    else {
      img.draw(this);
    }
  }
}

void addImages()
{
  int i;
  
  for(i=0; i<userVisuals.size(); i++) {
      UserVisuals user = (UserVisuals) userVisuals.get(i);
      for(i=0; i<=15; i++) {
        user.addImage(library);
      }
  }
}

void addUser(int userId)
{
  // code qui permet d'ajouter un utilisateur
  UserVisuals newUser = new UserVisuals(userId);
  newUser.addJoint(SimpleOpenNI.SKEL_RIGHT_HAND);
  userVisuals.add(newUser);
}

void updateUsers()
{
  UserVisuals user;
  PVector rightHand = new PVector();
  PVector rightShoulder = new PVector();
  PVector orientation;
  
  for(int i=0; i<userVisuals.size(); i++) {
    user = (UserVisuals) userVisuals.get(i);
    
    kinect.context.getJointPositionSkeleton(user.id, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    kinect.context.getJointPositionSkeleton(user.id, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
    
    orientation = PVector.sub(rightHand, rightShoulder);
    orientation.normalize();
    
    user.updatePositions(kinect, orientation);
    
    float distance = rightHand.dist(rightShoulder);
    
    if(distance > 500) {
      addImages();
    }
  }
}

void drawUsers()
{
  UserVisuals user;
  for(int i=0; i<userVisuals.size(); i++) {
    user = (UserVisuals) userVisuals.get(i);
    user.draw(this);
  }
}







// -----------------------------------------------------------------
// Kinect events


void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  
  kinect.context.requestCalibrationSkeleton(userId,true);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
  
  int index = -1;
  UserVisuals user;
  for(int i=0; i<userVisuals.size(); i++) {
    
    user = (UserVisuals) userVisuals.get(i);
    if( user.id == userId) {
      index = i;
      break;
    }
  }
  if(index != -1) {
    userVisuals.remove(index);
  } 
}

void onExitUser(int userId)
{
  println("onExitUser - userId: " + userId);
}

void onReEnterUser(int userId)
{
  println("onReEnterUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  
  if (successfull) 
  { 
    println("  User calibrated !!!");
    kinect.context.startTrackingSkeleton(userId);
    addUser(userId);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    kinect.context.requestCalibrationSkeleton(userId,true);
  }
}
