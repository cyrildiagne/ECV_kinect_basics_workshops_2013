//-- W06_Demo / @kikko_fr
//-- ECV Kinect Workshop 2013 

boolean bUseKinect = false;

Library   library;

Kinect    kinect;
ArrayList userVisuals;

float frequence = 1;
float fadeOutSpeed = 0.97;

int frameNum;

PVector mousePos;
ArrayList debugImgs;

void setup()
{
  size(640, 480, OPENGL);
  
  frameNum = 0;
  
  if(bUseKinect) {
    kinect = new Kinect(this);
    userVisuals = new ArrayList();
  } else {
    mousePos = new PVector();
    debugImgs = new ArrayList();
  }
  
  library = new Library();
  
  smooth();
}

void update()
{
  frameNum = frameNum + 1;
  
  if( frameNum >= frequence ) {
    frameNum = 0;
    addImages();
    addImages();
  }
  
  mousePos.x = mouseX;
  mousePos.y = mouseY;
}

void draw()
{
  update();
  
  background(128);
  tint(255, 255);
  
  if(bUseKinect) {
    kinect.update();
    kinect.drawColorImage();
    //kinect.drawSkeletons();
    drawUsers();
  }
  else {
    drawDebugImgs();
  }
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
  if(bUseKinect) {
      
      for(int i=0; i<userVisuals.size(); i++) {
          UserVisuals user = (UserVisuals) userVisuals.get(i);
          user.addImage(library);
      }
    }
    else {
      
      PVector diff = new PVector(mouseX-mousePos.x, mouseY-mousePos.y);
    
      if( diff.x*diff.x + diff.y*diff.y < 10) return;
      
      Img img = new Img( library.getRandomImage(), diff );
      img.x = mouseX;
      img.y = mouseY;
      debugImgs.add( img );
    }
}

void addUser(int userId)
{
  UserVisuals newUser = new UserVisuals(userId);
  newUser.addJoint(SimpleOpenNI.SKEL_LEFT_HAND);
  newUser.addJoint(SimpleOpenNI.SKEL_RIGHT_HAND);
  userVisuals.add(newUser);
}

void drawUsers()
{
  UserVisuals user;
  for(int i=0; i<userVisuals.size(); i++) {
    user = (UserVisuals) userVisuals.get(i);
    user.updatePositions(kinect);
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
