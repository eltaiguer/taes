import controlP5.*;
import java.awt.Frame;
import SimpleOpenNI.*;
import fisica.*;

FWorld world;

ControlP5 cp5;

ControlFrame cf;

SimpleOpenNI  context;

// ----------------------------
// Joints
PVector com    = new PVector();
PVector com2d  = new PVector();
PVector com2dP = new PVector();

PVector head   = new PVector();
PVector head2d = new PVector();

PVector rightHand   = new PVector();
PVector rightHand2d = new PVector();

PVector leftHand   = new PVector();
PVector leftHand2d = new PVector();

PVector rightFoot   = new PVector();
PVector rightFoot2d = new PVector();

PVector leftFoot   = new PVector();
PVector leftFoot2d = new PVector();

PVector rightShoulder   = new PVector();
PVector rightShoulder2d = new PVector();

PVector leftShoulder   = new PVector();
PVector leftShoulder2d = new PVector();

SceneManager manager;

boolean stopDraw = false;

int kWidth  = 640;
int kHeight = 480;

void setup() {
  size(1280, 960);

  Fisica.init(this);
  world = new FWorld();

  cf = addControlFrame("Controladores", 450, 700);
  manager = new SceneManager();

  // cosas kinect
  context = new SimpleOpenNI(this);
  if (context.isInit() == false) {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!");
    exit();
    return;
  }

  frameRate(30);
  smooth();
  context.enableDepth();
  context.enableUser();
}

void drawJoint(PVector joint) {
  float x_coord = map(joint.x, 0, kWidth, 0, width);
  float y_coord = map(joint.y, 0, kHeight, 0, height);
  ellipse(x_coord, y_coord, 50, 50);
}

void updateJointsPosition() {
  context.update();

  // draw the skeleton if it's available
  int[] userList = context.getUsers();

  for (int i=0; i<userList.length; i++) {

    if (context.isTrackingSkeleton(userList[i])) {

      if (!Float.isNaN(com2d.x) && !Float.isNaN(com2d.y)) {
        com2dP.x = com2d.x;
        com2dP.y = com2d.y;
      }

      // Get Center of Mass
      if (context.getCoM(userList[i], com)) {
        context.convertRealWorldToProjective(com, com2d);
      }
      // Get Head
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_HEAD, head);
      context.convertRealWorldToProjective(head, head2d);

      // Get right hand
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      context.convertRealWorldToProjective(rightHand, rightHand2d);

      // Get left hand
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
      context.convertRealWorldToProjective(leftHand, leftHand2d);

      // Get right foot
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_FOOT, rightFoot);
      context.convertRealWorldToProjective(rightFoot, rightFoot2d);

      // Get left foot
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_FOOT, leftFoot);
      context.convertRealWorldToProjective(leftFoot, leftFoot2d);

      // Get right shoulder
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
      context.convertRealWorldToProjective(rightShoulder, rightShoulder2d);

      // Get left shoulder
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);
      context.convertRealWorldToProjective(leftShoulder, leftShoulder2d);
    }
  }
}

void draw() {
  updateJointsPosition();

  if (!stopDraw) manager.actualScene.drawScene();

  // fill(0, 255, 0);
  // drawJoint(com2d);
  // fill(255, 0, 0);
  // drawJoint(head2d);
  // fill(255, 255, 0);
  // drawJoint(rightHand2d);
  // fill(255, 255, 0);
  // drawJoint(leftHand2d);
  // fill(0, 255, 255);
  // drawJoint(rightFoot2d);
  // fill(0, 255, 255);
  // drawJoint(leftFoot2d);
  // drawJoint(leftShoulder2d);
  // drawJoint(rightShoulder2d);
}

void onNewUser(SimpleOpenNI curContext, int userId){
  println("onNewUser - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
}
