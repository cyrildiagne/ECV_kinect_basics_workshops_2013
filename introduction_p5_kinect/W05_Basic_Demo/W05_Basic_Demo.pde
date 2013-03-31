//-- W05_Basic_Demo / @kikko_fr
//-- ECV Kinect Workshop 2013 


Kinect    kinect;
ArrayList users;

void setup() {
  
  size(640, 480, OPENGL);
  
  kinect = new Kinect(this);
  users = new ArrayList();
    
  smooth();
}

void draw() {
  
  background(0);
  
  kinect.update();
   
  kinect.drawColorImage();
  //kinect.drawSkeletons();
  
  
  drawUsers();
}


void drawUsers() {
  
  User user;
  PVector position;
  
  for(int i=0; i<users.size(); i++) {
    
    user = (User) users.get(i);
    
    position = kinect.getHeadPositionForUser(user.id);
    user.setHeadPosition(position);
    
    position = kinect.getHandPositionForUser(user.id, true);
    user.setLeftHandPosition(position);
    
    position = kinect.getHandPositionForUser(user.id, false);
    user.setRightHandPosition(position);
    
    user.draw();
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
  User user;
  for(int i=0; i<users.size(); i++) {
    
    user = (User) users.get(i);
    if( user.id == userId) {
      index = i;
      break;
    }
  }
  if(index != -1) {
    users.remove(index);
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
    User newUser = new User(userId);
    users.add(newUser);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    kinect.context.requestCalibrationSkeleton(userId,true);
  }
}
