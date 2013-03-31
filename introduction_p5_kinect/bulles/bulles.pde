//-- ECV Kinect Workshop 2013 

import SimpleOpenNI.*;
import ddf.minim.*;

SimpleOpenNI  openNI;

Minim minim;
AudioSample bubbleSfx;

int numRoundsX = 32;
int numRoundsY = 24;
int roundSize = 20;

PImage imgA;
PImage imgB;
boolean[] imgStatus;

boolean bUseKinect = false;

void setup() {
  
  // setup the size of the viewport and the renderer type
  size(640, 480, OPENGL);
  
  if(bUseKinect) {
    
    // init the SimpleOpenNI library
    openNI = new SimpleOpenNI(this);
    if(openNI.enableDepth() == false) {
       println("Can't open the depthMap, maybe the camera is not connected!"); 
       exit(); return;
    }
    openNI.setMirror(true);
    openNI.enableRGB();
    // enable skeleton generation for all joints
    openNI.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  }
  
  setupBulles();
  
  setupSound();
  
  // setup some global settings
  stroke(0,0,255);
  strokeWeight(3);
  smooth();
}

void setupSound()
{
  minim = new Minim(this);
  bubbleSfx = minim.loadSample("bubbleSfx.wav", 512);
  if(bubbleSfx == null) println("could not find sound file!");
}

void setupBulles()
{
  imgStatus = new boolean[numRoundsX*numRoundsY];
  int id=0;
  for( int i=0; i< numRoundsX; i++) {
    for( int j=0; j < numRoundsY; j++) {
      imgStatus[id] = false;
      id++;
    }
  }
  imgA = loadImage("a.png");
  imgB = loadImage("b.png");
}

void keyPressed() 
{
  if ( key == 's' ) bubbleSfx.trigger();
}


void draw() {
  
  background(0);
  
  if(bUseKinect) { 
    
    openNI.update();
  
    // draw depthImageMap
    image(openNI.rgbImage(), 0, 0);
  
    // draw the skeleton if it's available
    int[] userList = openNI.getUsers();
    for(int i=0;i<userList.length;i++)
    {
      if(openNI.isTrackingSkeleton(userList[i]))
        drawSkeleton(userList[i]);
    } 
  }
  
  drawBulles();
}

void drawBulles()
{
  boolean isInCircle = false;
  
  PVector handPos = new PVector();
  
  if(bUseKinect) {
    int[] userList = openNI.getUsers();
    for(int i=0;i<userList.length;i++)
    {
      if(openNI.isTrackingSkeleton(userList[i])) {
        handPos = getJointPosition(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND);
      }
    }
  }
  
  int id = 0;
  for( int i=0; i< numRoundsX; i++) {
    for( int j=0; j < numRoundsY; j++) {
      
      if(bUseKinect) {
        isInCircle = handPos.x > i*roundSize
                     && handPos.x < (i+1)*roundSize
                     && handPos.y > j*roundSize
                     && handPos.y < (j+1)*roundSize;
      } else {
        isInCircle = mouseX > i*roundSize
                     && mouseX < (i+1)*roundSize
                     && mouseY > j*roundSize
                     && mouseY < (j+1)*roundSize;
      }
      
      float x;
      float y;
      if(isInCircle || imgStatus[id] == true) {
        fill(0);
        x = i*roundSize;
        y = j*roundSize;
        if(imgStatus[id] == false) { bubbleSfx.trigger(); }
        imgStatus[id] = true;
        image(imgA, x,  y);
      }
      else {
        fill(255);
        //ellipse(i*roundSize, j*roundSize, roundSize, roundSize);
        x = i*roundSize;
        y = j*roundSize;
        image(imgB, x,  y);
      }
      
      id++;
    }    
  }
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  openNI.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  openNI.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  openNI.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  openNI.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  openNI.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  openNI.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

// 
PVector getJointPosition(int userId, int joint) {
  PVector jointPos = new PVector();
  PVector pJointPos = new PVector();
  openNI.getJointPositionSkeleton(userId, joint, jointPos);
  openNI.convertRealWorldToProjective(jointPos, pJointPos); 
  return pJointPos;
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  
  openNI.requestCalibrationSkeleton(userId,true);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
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
    openNI.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    openNI.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose,int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");
  
  openNI.stopPoseDetection(userId); 
  openNI.requestCalibrationSkeleton(userId, true);
 
}

void onEndPose(String pose,int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}
