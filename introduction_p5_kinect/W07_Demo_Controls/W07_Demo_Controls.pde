//-- W06_Demo / @kikko_fr
//-- ECV Kinect Workshop 2013 

import controlP5.*;

boolean bUseKinect = true;

ControlP5 cp5;

Library   library;

Kinect    kinect;
ArrayList userVisuals;

float frequence = 1;
float initScale = 1;
float initAlpha = 1;
float alphaModifier = 0.97;
float speedModifier = 0.95;
float scaleModifier = 0.95;
float to_rotationRandom = 180;
float to_rotation = 180;

int frameNum;

PVector mousePos;
ArrayList debugImgs;

void setup()
{
  size(640, 480, OPENGL);
  
  frameNum = 0;
  
  setupSliders();
  
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

void setupSliders()
{
  cp5 = new ControlP5(this);
  cp5.addSlider("frequence").setPosition(5, 5).setRange(0.3, 2);
  cp5.addSlider("initScale").setPosition(5,20).setRange(0, 1.5);
  cp5.addSlider("initAlpha").setPosition(5,35).setRange(0, 1.0);
  cp5.addSlider("alphaModifier").setPosition(5,50).setRange(0.85, 1.0);
  cp5.addSlider("speedModifier").setPosition(5,65).setRange(0.0, 1.2);
  cp5.addSlider("scaleModifier").setPosition(5,80).setRange(0.9, 1.05);
  cp5.addSlider("to_rotationRandom").setPosition(5,95).setRange(0, 360);
  cp5.addSlider("to_rotation").setPosition(5,110).setRange(0, 360);
}

void update()
{
  frameNum = frameNum + 1;
  
  if( frameNum >= frequence ) {
    frameNum = 0;
    addImages();
  }
  
  if(!bUseKinect) {
    mousePos.x = mouseX;
    mousePos.y = mouseY;
  }
}

void draw()
{
  update();
  
  background(128);
  tint(255, 255);
  
  if(bUseKinect) {
    kinect.update();
    kinect.drawColorImage();
    kinect.drawSkeletons();
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
  int i;
  
  if(bUseKinect) {
      for(i=0; i<userVisuals.size(); i++) {
          UserVisuals user = (UserVisuals) userVisuals.get(i);
          for(i=0; i<=1/frequence; i++) {
            user.addImage(library);
          }
      }
    }
    else {
      
      PVector diff = new PVector(mouseX-mousePos.x, mouseY-mousePos.y);
    
      if( diff.x*diff.x + diff.y*diff.y < 10) return;
      
      for(i=0; i<=1/frequence; i++) {
        Img img = new Img( library.getRandomImage(), diff );
        img.x = mouseX;
        img.y = mouseY;
        debugImgs.add( img );
      }
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
