import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.awt.Frame; 
import SimpleOpenNI.*; 
import fisica.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Tarea_1 extends PApplet {






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

public void setup() {
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

public void drawJoint(PVector joint) {
  float x_coord = map(joint.x, 0, kWidth, 0, width);
  float y_coord = map(joint.y, 0, kHeight, 0, height);
  ellipse(x_coord, y_coord, 50, 50);
}

public void updateJointsPosition() {
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

public void draw() {
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

public void onNewUser(SimpleOpenNI curContext, int userId){
  println("onNewUser - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
}
class Bed implements Scene{
  PImage bedImg;

  public Bed(){}

  public void closeScene(){}

  public void initialScene(){
    background(255,255,255);
    bedImg = loadImage("bed1.png");
    bedImg.resize(3*width/4,0);
    image(bedImg,width/4+100,0);
  }

  public void drawScene(){}

  public String getSceneName(){return "Bed";};
}
class BedSpaceTransition implements Scene{

  ArrayList<PVector> stars = new ArrayList<PVector>();
  float h2;
  float w2;
  float d2;
  Timer timer;
  int width2 = kWidth;
  int height2 = height/2;

  public BedSpaceTransition(){}

  public void closeScene(){}

  public void initialScene(){
    w2=width2/2;
    h2= height2/2;
    d2 = dist(0, 0, w2, h2);
    noStroke();
    timer = new Timer();
    timer.startTimer();
  }

  public void drawScene(){
    println("(" + mouseX + "," + mouseY +")");
    fill(0, map(dist(0, 0, w2, h2), 0, d2, 255, 5));
    rect(0, 0, width, height);
    fill(255);

    for (int i = 0; i<20; i++) {   // star init
      stars.add(new PVector(random(width), random(height), random(1, 3)));}

    for (int i = 0; i<stars.size(); i++) {
      float x =stars.get(i).x;
      float y =stars.get(i).y;
      float d =stars.get(i).z;

      stars.set(i, new PVector(x-map(0, 0, width2, -0.05f, 0.05f)*(w2-x), y-map(0, 0, height2, -0.05f, 0.05f)*(h2-y), d+0.2f-0.6f*noise(x, y, frameCount)));

      if (d>3||d<-3) stars.set(i, new PVector(x, y, 3));
      if (x<0||x>width||y<0||y>height) stars.remove(i);
      if (stars.size()>1000) stars.remove(1);
      ellipse(x, y, d, d);
    }
  }

  public String getSceneName(){return "BedSpaceTransition";};

}
class SceneManager{

  Scene[] scenes;
  Scene actualScene;
  int actualSceneNr;

  SceneManager(){

    Scene [] allScenes = {
      new Bed(),
      new BedSpaceTransition(),
      new Space(),
      new SpaceSkyTransition(),
      new Sky(),
      new SkyWaterTransition(),
      new Water(),
      new WaterBedTransition()
    };

    scenes = allScenes;
    actualSceneNr = 0;
    scenes[0].initialScene();
    actualScene = scenes[0];
  }

  public void activateNextScene(){
    int sceneNr = (actualSceneNr+1)%(scenes.length);
    activate(sceneNr);
  }

  public void activatePrevScene(){
    int sceneNr;
    if(actualSceneNr-1 < 0) sceneNr = scenes.length -1;
    else sceneNr = (actualSceneNr-1)%(scenes.length);
    activate(sceneNr);
  }

  public void activate(int sceneNr){
    stopDraw = true;
    actualSceneNr = sceneNr;
    actualScene.closeScene();
    actualScene = scenes[sceneNr];
    actualScene.initialScene();
    println(sceneNr,actualScene.getSceneName());
    stopDraw = false;
  }
}

// Escena
interface Scene
{
    public void initialScene();
    public void drawScene();
    public void closeScene();
    public String getSceneName();
}

class Example implements Scene
{
  public Example(){};
  public void closeScene(){};
  public void initialScene(){};
  public void drawScene(){};
  public String getSceneName(){return "Example";};
}
PImage candy0,candy1,candy2,candy3,candy4;

class Sky implements Scene{

  PImage sky;
  PImage cloud1,cloud2;
  FBox cloudBox;
  FBox rightHandToRightShoulder,rightShoulderToLeftShoulder, leftShoulderToleftHand;

  public Sky(){
    println("width " + width);
    println("height " + height);
    // Create background image
    sky = createImage(width, height, RGB);
      for(int i = 0; i < width; i++){
        for(int j = 0; j < height; j++){
          sky.pixels[i + j * width] = lerpColor(0xff157ABC, 0xff66B9F0, (float)j/height);
        }
      }

    // Cloud images
    cloud1 = loadImage("cloud0.png");
    cloud1.resize(400,300);

    // Candy images
    candy0 = loadImage("candy0.png");
    candy0.resize(60,60);

    candy1 = loadImage("candy1.png");
    candy1.resize(60,60);

    candy2 = loadImage("candy2.png");
    candy2.resize(60,60);

    candy3 = loadImage("candy3.png");
    candy3.resize(60,60);

    candy4 = loadImage("candy4.png");
    candy4.resize(60,60);

    // fisica cloud's box
    cloudBox = new FBox(200, 10);
    cloudBox.setPosition(400, 800);
    cloudBox.attachImage(cloud1);
    cloudBox.setStatic(true);
    world.add(cloudBox);

    //
    rightShoulderToLeftShoulder = new FBox(150, 10);
    rightShoulderToLeftShoulder.setStatic(true);
    rightShoulderToLeftShoulder.setDrawable(false);
    world.add(rightShoulderToLeftShoulder);

    rightHandToRightShoulder = new FBox(50, 10);
    rightHandToRightShoulder.setStatic(true);
    rightHandToRightShoulder.setDrawable(false);
    world.add(rightHandToRightShoulder);

    leftShoulderToleftHand = new FBox(50, 10);
    leftShoulderToleftHand.setStatic(true);
    leftShoulderToleftHand.setDrawable(false);
    world.add(leftShoulderToleftHand);
  }

  public void closeScene(){}

  public void initialScene(){}

  public String getSceneName(){return "Sky";};

  public void drawScene(){
    background(sky);

    updateCloudPosition();
    updateArmsPosition();

    world.step();
    world.draw();
  }

  public void updateArmsPosition(){
    if (!Float.isNaN(rightShoulder2d.y) && !Float.isNaN(com2d.x)){
      rightShoulderToLeftShoulder.setPosition(map(com2d.x, 0, kWidth, 0, width), map(rightShoulder2d.y, 0, kHeight, 0, height));
    }

    if (!Float.isNaN(rightHand2d.y) && !Float.isNaN(rightHand2d.x)){
      rightHandToRightShoulder.setPosition(map(rightHand2d.x, 0, kWidth, 0, width), map(rightHand2d.y, 0, kHeight, 0, height));
      rightHandToRightShoulder.adjustRotation(PVector.angleBetween(rightHand2d, rightShoulder2d));
    }

    if (!Float.isNaN(leftHand2d.y) && !Float.isNaN(leftHand2d.x)){
      leftShoulderToleftHand.setPosition(map(leftHand2d.x, 0, kWidth, 0, width), map(leftHand2d.y, 0, kHeight, 0, height));
    }
  }

  public void updateCloudPosition(){
    if (!Float.isNaN(com2d.x)){
      cloudBox.setPosition(map(com2d.x, 0, kWidth, 0, width), 800);
    }
  }
}

public void mousePressed() {
  // Creates a new circle to wrap the candy image
  FCircle myCircle = new FCircle(60);
  myCircle.setPosition(mouseX, mouseY);

  // Creates and add a new candy
  int candySelector = (int)random(5);

  switch(candySelector){
    case 0:
      myCircle.attachImage(candy0);
      break;
    case 1:
      myCircle.attachImage(candy1);
      break;
    case 2:
      myCircle.attachImage(candy2);
      break;
    case 3:
      myCircle.attachImage(candy3);
      break;
    case 4:
      myCircle.attachImage(candy4);
      break;
  }

  // Add candy to the world
  world.add(myCircle);
}
class SkyWaterTransition implements Scene{
  PImage sky, transition, water;
  PImage cloud0, cloud1, cloud2, cloud3, cloud4;

  int x0,y0;
  int x1,y1;
  int x2,y2;
  int x3,y3;
  int x4,y4;

  int velocity;

  int transparency1;
  int transparency2;
  int transparency3;

  public SkyWaterTransition(){

    transparency1 = 254;
    transparency2 = 0;
    transparency3 = 0;

    sky = createImage(width, height, RGB);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        sky.pixels[i + j * width] = lerpColor(0xff157ABC, 0xff66B9F0, (float)j/height);
      }
    }

    transition = createImage(width, height, RGB);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        sky.pixels[i + j * width] = lerpColor(0xff157ABC, 0xffE0F1FC, (float)j/height);
      }
    }

    velocity = 2;

    cloud0 = loadImage("cloud0.png");
    cloud0.resize(432,200);
    x0=(int)random(0,800); y0=height+200;

    cloud1 = loadImage("cloud1.png");
    cloud1.resize(366,200);
    x1=(int)random(0,800); y1=height+200;

    cloud2 = loadImage("cloud2.png");
    cloud2.resize(432,200);
    x2=(int)random(0,800); y2=height+200;

    cloud3 = loadImage("cloud3.png");
    cloud3.resize(432,200);
    x3=(int)random(0,800); y3=height+200;

    cloud4 = loadImage("cloud4.png");
    cloud4.resize(432,200);
    x4=(int)random(0,800); y4=height+200;

    water = loadImage("data/ocean1.jpg");
    water.resize(width,height);
  }

  public void closeScene(){}

  public void initialScene(){}

  public void drawScene(){
    background(sky);
    drawClouds();
  }

  public String getSceneName(){return "Sky";};

  public void drawClouds(){
    tint(255,255,255,transparency1);
    image(sky, 0, 0);

    y0 = y0 - 10;
    image(cloud0, x0,y0 );

    if(y0 > 300){
      y1 = y1 - 10;
      image(cloud1, x1, y1 );
    }

    if(y0 > 300){
      y2 = y2 - 10;
      image(cloud2, x2,y2 );
    }

    if(y1 > 300){
      y3 = y3 - 10;
      image(cloud3, x3, y3 );
    }

    if (y3 > 300){
      y4 = y4 - 10;
      image(cloud0, x4,y4 );
    }

    if(transparency1 > 0){
      transparency1 = transparency1 -2;
    }

    tint(255,255,255,254-transparency1);
    image(transition, 0, 0);

    tint(255,255,255,transparency2);
    image(water, 0, 0);
    if((transparency1 == 0) && (transparency2 < 254)){
      transparency2 = transparency2 + 2;
    }
  }
}
class Space implements Scene{
  //fondo estrellas
  int cant_stars = 2000;
  ArrayList<PVector> stars = new ArrayList();
  PVector direction;
  float speed;
  float forceStrength;

  //cometa
  Comet comet;
  boolean show_comet = true;

  //luna
  PImage img;
  boolean moon_is_moving = false;
  int moon_width         = 225;
  int moon_height        = 225;
  int moon_x             = 1025;
  int moon_y             = 150;
  FWorld fworld;
  FCircle fmoon;
  FCircle f_rigth_hand;
  FCircle f_left_hand;

  public Space() {}

  public void closeScene() {}

  public void initialScene(){

    //fondo
    for (int i = 0; i < cant_stars; i++) {
      PVector P = new PVector(random(2 * width), random(2 * height));
      stars.add(P);
    }
    smooth();

    //cometa
    comet         = new Comet(random(width), random(height));
    speed         = 7;
    float angle   = random(TWO_PI);
    direction     = new PVector(cos(angle), sin(angle));
    forceStrength = 0.2f;

    //luna
    img = loadImage("moon.png");
    img.resize(moon_width, moon_height);

    fworld  = new FWorld();
    fworld.setGravity(0,75);
    fmoon = new FCircle(225);
    fmoon.attachImage(img);
    fmoon.setPosition(moon_x, moon_y);
    fmoon.setStatic(true);
    fworld.add(fmoon);

    //manos
    f_rigth_hand = new FCircle(75);
    f_left_hand  = new FCircle(75);

    f_rigth_hand.setDrawable(false);
    f_left_hand.setDrawable(false);

    fworld.add(f_rigth_hand);
    fworld.add(f_left_hand);
  }

  public void drawScene() {
    //fondo
    background(0xff040e2a);
    noStroke();
    fill(-1);
    for (int i = 0; i < stars.size(); i++) {
      PVector P = stars.get(i);
      PVector M;
      if (!Float.isNaN(com2d.x) && !Float.isNaN(com2d.y)) {
        M = new PVector(com2dP.x - com2d.x, com2dP.y - com2d.y);
      } else {
        M = new PVector(0, 0);
      }
      P.add(M);
      float d = dist(P.x, P.y, width/2, height/2);
      d       = map(d, 0, width/2, 0, 3);
      ellipse(P.x, P.y, d, d);
    }

    //manos
    if (!Float.isNaN(rightHand2d.x) && !Float.isNaN(rightHand2d.y)) {
      f_rigth_hand.setPosition(map(rightHand2d.x, 0, kWidth, 0, width), map(rightHand2d.y, 0, kWidth, 0, height));
      f_left_hand.setPosition(map(leftHand2d.x, 0, kWidth, 0, width), map(leftHand2d.y, 0, kWidth, 0, height));
    } else {
      f_rigth_hand.setPosition(width/2, height/2);
      f_left_hand.setPosition(width/2, height/2);
    }

    //contacto luna-manos
    if (f_rigth_hand.isTouchingBody(fmoon) || f_left_hand.isTouchingBody(fmoon)) {
      show_comet = false;
      if (moon_is_moving) {
        fmoon.setStatic(true);
      } else {
        fmoon.setStatic(false);
      }
    }

    //cometa
    move();
    if (show_comet) {
      if (!Float.isNaN(com2d.x) && !Float.isNaN(com2d.y)) {
        steer(com2d.x, com2d.y);
      } else {
        steer(width/2, height/2);
      }
    } else {
        steer(-500, -500);
    }

    comet.display();

    //luna
    fworld.step();
    fworld.draw();
  }

  class Comet
  {
    PVector[] location;
    float ellipseSize;

    int c1;
    int c2;

    Comet(float x, float y)
    {
      location    = new PVector[round(random(15, 25))];
      location[0] = new PVector(x, y);

      for (int i = 1; i < location.length; i++)
      {
        location[i] = location[0].get();
      }
      ellipseSize = 40;
      c1 = 0xffffedbc;
      c2 = 0xffA75265;
    }

    public PVector getHead()
    {
      return location[location.length-1].get();
    }

    public void setHead(PVector pos)
    {
      location[location.length-1] = pos.get();

      updateBody();
    }

    public void updateBody()
    {
      for (int i=0; i < location.length-1; i++)
      {
        location[i] = location[i+1];
      }
    }

    public void display ()
    {
      noStroke();
      for (int i = 0; i < location.length; i++)
      {
        int c = lerpColor(c1, c2, map(i, 0, location.length, 1, 0));
        float s = map(i, 0, location.length, 1, ellipseSize);

        fill(c);
        ellipse(location[i].x, location[i].y, s, s);
      }
    }
  }

  public void steer(float x, float y)
  {
    PVector location = comet.getHead();

    float angle = atan2(y - location.y, x - location.x);

    PVector force = new PVector(cos(angle), sin(angle));
    force.mult(forceStrength);

    direction.add(force);
    direction.normalize();
  }

  public void move()
  {
    PVector location = comet.getHead();
    PVector velocity = direction.get();
    velocity.mult (speed);
    location.add (velocity);
    comet.setHead (location);
  }

  public String getSceneName(){return "Space";};
}
class SpaceSkyTransition implements Scene{

  int c;
  int count;
  int size;

  public SpaceSkyTransition(){}

  public void closeScene(){}
  public void initialScene(){
    noStroke();
    size = height;
    c=0;
    count=0;
  }

  public void drawScene(){
    count++;
    fill(42,138,201,c);
    rect(0,size,width,height);

    if (count==5){
       c++;
       count=0;
    }
    size=size-5;
  }

  public String getSceneName(){return "SpaceSkyTransition";};
}
class Timer {
  int initTime;
  int endTime;
  
  Timer(){
    initTime = 0;
    endTime = 0;
  }
  
  public void startTimer(){
    initTime = millis()/1000;
  }
  
//  void StopTimer(){
//    endTime = millis()/1000;
//  }
  
  public int getTime(){
    return (millis()/1000 - initTime);
  }
}
class Water implements Scene{

  //************* RIPPLE EFFECT ****************************//
  PImage img,bubble,coral;
  Ripple ripple;
  //************************** BUBBLES ************///
  ArrayList<Particle> pts;
  ArrayList<floatingObj> fts;
  boolean onPressed, showInstruction;
  PFont f1, f2;
  //******************************* VARIABLES MOVIMIENTO ***************************//
  float preivousJointPossition;
  //******************************* VARIABLES MOVIMIENTO ***************************//

  //****************************************** TIMER **************************************//
  int interval = 1500;//timer's interval
  int lastRecordedTime = 0;
  //****************************************** TIMER **************************************//

  boolean automaticWaves =false;

  public Water(){}

  public void closeScene(){}
  public void initialScene(){
    img = loadImage("data/ocean1.jpg");
    bubble =   loadImage("data/bubble.png");
    bubble.resize(50,50);
    coral = loadImage("data/coral.png");
    coral.resize(100,100);
    img.resize(width,height);

    ripple = new Ripple();

    //**************** BUBBLES ******************************//
    pts = new ArrayList<Particle>();
    showInstruction = true;
    //***************************** VARIABLES MOVIMIENTO **************************//
      preivousJointPossition = 0;
    //******************************* VARIABLES MOVIMIENTO ***************************//

    //************************ floatando
    fts = new ArrayList<floatingObj>() ;
    for (int i=0;i<3;i++) {
        floatingObj newP = new floatingObj(10 + i*100, height - 100, coral);
        fts.add(newP);
    }
  }

  public void drawScene(){
    loadPixels();
    img.loadPixels();
    for (int loc = 0; loc < width * height; loc++) {
      pixels[loc] = ripple.col[loc];
    }
    updatePixels();

   //******************* BUBBLES***************************//
   if (onPressed) {
      for (int i=0;i<10;i++) {
        float x_coord  = map(head2d.x, 0, kWidth, 0, width);
        float y_coord = map(head2d.y, 0, kHeight, 0, height);
        Particle newP = new Particle(x_coord , y_coord, i+pts.size(), i+pts.size(),this.bubble);
        pts.add(newP);
      }
    }

    for (int i=0; i<pts.size(); i++) {
      Particle p = pts.get(i);
      p.update();
      p.display();
    }

    for (int i=pts.size()-1; i>-1; i--) {
      Particle p = pts.get(i);
      if (p.dead) {
        pts.remove(i);
      }
    }

    ripple.newframe();

    if(millis()-lastRecordedTime>interval){
     mouseMovedLZ(); // Para mostrar ripple effect
     mousePressedLZ(); // Para mostrar bubbles
     //and record time for next tick
     lastRecordedTime = millis();
    } else {
      mouseReleasedLZ();
    }
    mouseMovedLZ();
    mouseMovedAutomaticLZ();

    //*******************floating
    for (int i=0; i<fts.size(); i++) {
      floatingObj ft = fts.get(i);
      ft.update();
      if (!ft.dead || (ft.dead && ft.lifeTime >= 0)){
        ft.display();
      }
    }
  }

  public String getSceneName(){return "Water";};

  class floatingObj {
    float y,x,g,acceleration,lifeTime;
    boolean active, dead;
    int factor;
    PImage img;
    floatingObj(float x,float y, PImage img) {
      this.x = x;
      this.y =y;
      this.active = false;
      this.g = .8f;
      this.factor = -1;
      this.img = img;
      this.lifeTime = 150;
      this.dead = false;
    }

    public void display(){
      image(this.img,this.x ,this.y);
    }

    public void update(){
      if (!this.active) {
        this.y += this.factor;
        this.factor *= -1;
      }

      float x_coord_right  = map(rightHand2d.x, 0, kWidth, 0, width);
      float y_coord_right = map(rightHand2d.y, 0, kHeight, 0, height);
      
      float x_coord_left  = map(leftHand2d.x, 0, kWidth, 0, width);
      float y_coord_left = map(leftHand2d.y, 0, kHeight, 0, height);

      if ((Math.abs(y_coord_right - this.y) <=  100 && Math.abs(x_coord_right - this.x) <= 100) || (Math.abs(y_coord_left - this.y) <=  100 && Math.abs(x_coord_left - this.x) <= 100)){
        this.active = true;
      }

      if (this.active && (this.y - this.g > 200)){
        this.y -= this.g;
      } else if (this.active) {
        this.active = false;
        this.dead = true;
      }
      if (this.dead){
        this.lifeTime--;
      }
    }
  }

  class Ripple {
    int i, a, b;
    int oldind, newind, mapind;
    short ripplemap[]; // the height map
    int col[]; // the actual pixels
    int riprad;
    int rwidth, rheight;
    int ttexture[];
    int ssize;

    Ripple() {
      // constructor
      riprad = 3;
      rwidth = width >> 1;
      rheight = height >> 1;
      ssize = width * (height + 2) * 2;
      ripplemap = new short[ssize];
      col = new int[width * height];
      ttexture = new int[width * height];
      oldind = width;
      newind = width * (height + 3);
    }

    public void newframe() {
      // update the height map and the image
      i = oldind;
      oldind = newind;
      newind = i;

      i = 0;
      mapind = oldind;
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          short data = (short)((ripplemap[mapind - width] + ripplemap[mapind + width] +
            ripplemap[mapind - 1] + ripplemap[mapind + 1]) >> 1);
          data -= ripplemap[newind + i];
          data -= data >> 5;
          if (x == 0 || y == 0) // avoid the wraparound effect
            ripplemap[newind + i] = 0;
          else
            ripplemap[newind + i] = data;

          // where data = 0 then still, where data > 0 then wave
          data = (short)(1024 - data);

          // offsets
          a = ((x - rwidth) * data / 1024) + rwidth;
          b = ((y - rheight) * data / 1024) + rheight;

          //bounds check
          if (a >= width)
            a = width - 1;
          if (a < 0)
            a = 0;
          if (b >= height)
            b = height-1;
          if (b < 0)
            b=0;

          col[i] = img.pixels[a + (b * width)];
          mapind++;
          i++;
        }
      }
    }
  }

  //******************************* BUBBLES **************************************************//
  public void mousePressed() {
    onPressed = true;
    if (showInstruction) {
      background(255);
      showInstruction = false;
    }
  }

  public void mouseReleased() {
    onPressed = false;
  }

  public void mousePressedLZ() {
    onPressed = true;
    if (showInstruction) {
      background(255);
      showInstruction = false;
    }
  }

  public void mouseReleasedLZ() {
    onPressed = false;
  }

  public void mouseMovedLZ(){
    float x_coord  = map(rightHand2d.x, 0, kWidth, 0, width);
    float y_coord = map(rightHand2d.y, 0, kHeight, 0, height);
    
    for (float j = y_coord - ripple.riprad; j < y_coord + ripple.riprad; j++) {
      for (float k = x_coord - ripple.riprad; k < x_coord + ripple.riprad; k++) {
        if (j >= 0 && j < height && k>= 0 && k < width) {
          ripple.ripplemap[(int)(ripple.oldind + (j * width) + k)] += 512;
        }
      }
    }
  }

  public void mouseMovedAutomaticLZ(){
    for (int j = 0 - ripple.riprad; j < 10 + ripple.riprad; j++) {
      for (int k = 0 - ripple.riprad; k < width + ripple.riprad; k++) {
        if (j >= 0 && j < 10 && k>= 0 && k < width) {
          ripple.ripplemap[ripple.oldind + (j * width) + k] += 10 *k;
        }
      }
    }
  }
}
class WaterBedTransition implements Scene{

  int count;
  int currentHeight;
  boolean open;
  int cycle;
  int maxCycles;
  PImage bedImg;
  int alfa;

  public WaterBedTransition(){}

  public void closeScene(){}

  public void initialScene(){
    noStroke();
    count = 0;
    alfa = 0;
    currentHeight = height/2;
    open = false;
    cycle = 0;
    maxCycles = 3;
    bedImg = loadImage("bed1.png");
    bedImg.resize(width,0);
  }

  public void drawScene(){
    if (alfa < 20){
    fill(0,0,0,alfa);
    rect(0,0,width,height);
    if (count == 5){
       alfa++;
       count = 0;
    }
    count++;
    }else{
      if (cycle < maxCycles){
        if (currentHeight == height/2){
          open = true;
          cycle++;
        }else if (currentHeight == height/4){
          open = false;
        }

        if (!open){
          currentHeight= currentHeight + 10;
        }else{
          image(bedImg,0,0);
          currentHeight= currentHeight - 5;
        }

        fill(0,0,0);
        rect(0,0,width,currentHeight);
        fill(0,0,0);
        rect(0,height - currentHeight,width,height);
      }
      else{
        if (currentHeight >= 0){
          println(currentHeight);
          image(bedImg,0,0);
          fill(0,0,0);
          rect(0,0,width,currentHeight);
          fill(0,0,0);
          rect(0,height - currentHeight,width,height);
          currentHeight= currentHeight - 10;
        }
      }
    }
  }

  public String getSceneName(){return "WaterBedTransition";};
}

public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

/////////////// Escena 1 Cama /////////////////////////////////

    cp5.addBang("bang1")
      .setPosition(180, 10)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

/////////////// Transicion 1 Cama-Espacio /////////////////////////////////

    cp5.addBang("bang2")
      .setPosition(180, 60)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Escena 2 Espacio /////////////////////////////////

    cp5.addBang("bang3")
      .setPosition(180, 110)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Transicion 2 Espacio-Cielo /////////////////////////////////

    cp5.addBang("bang4")
      .setPosition(180, 160)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Escena 3 Cielo /////////////////////////////////

    cp5.addBang("bang5")
      .setPosition(180, 210)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Transicion 3 Cielo-Agua /////////////////////////////////

    cp5.addBang("bang6")
      .setPosition(180, 260)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Escena 4 Agua /////////////////////////////////

    cp5.addBang("bang7")
      .setPosition(180, 310)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Transici\u00f3n 4 Agua-Cama /////////////////////////////////

    cp5.addBang("bang8")
      .setPosition(180, 360)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
  }

  public void controlEvent(ControlEvent theEvent) {
    String n = theEvent.getName();

    // Escena 1 Cama
    if( n == "bang1") {
      manager.activate(0);
    }
    // Trancision 1 Cama-Espacio
    if( n == "bang2") {
      manager.activate(1);
    }
    // Escena 2 Espacio
    if( n == "bang3") {
      manager.activate(2);
    }
    // Transicion 2 Espacio-Cielo
    if( n == "bang4") {
      manager.activate(3);
    }
    // Escena 3 Cielo
    if( n == "bang5") {
      manager.activate(4);
    }
    // Transici\u00f3n 3 Cielo-Agua
    if( n == "bang6") {
      manager.activate(5);
    }
    // Escena 4 Agua
    if( n == "bang7") {
      manager.activate(6);
    }
    // Transicion 4 Agua-Cama
    if( n == "bang8") {
      manager.activate(7);
    }

    // Escena Cama final
    if( n == "bang7") {
      manager.activate(6);
    }
  }

  public void draw() {
    background(0);
    fill(255);
    text("Escena 1 - Cama",10,20);
    stroke(255,0,0);

    line(5,50,445,50);
    text("Transici\u00f3n Cama-Espacio",10,70);

    line(5,100,445,100);
    text("Escena 2 - Espacio",10,120);

    line(5,150,445,150);
    text("Transici\u00f3n Espacio-Cielo",10,170);

    line(5,200,445,200);
    text("Escena 3 - Cielo",10,220);

    line(5,250,445,250);
    text("Transicion Cielo-Agua",10,270);

    line(5,300,445,300);
    text("Escena 4 - Agua",10,320);

    line(5,350,445,350);
    text("Transicion Agua-Cama",10,370);
  }

  private ControlFrame() {
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }
  public ControlP5 control() {
    return cp5;
  }
}

public ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}
//Raven Kwok aka Guo, Ruiwen
//ravenkwok.com
//vimeo.com/ravenkwok
//flickr.com/photos/ravenkwok

class Particle{
  PVector loc, vel, acc;
  int lifeSpan, passedLife;
  boolean dead;
  float alpha, weight, weightRange, decay, xOffset, yOffset;
  int c;
  PImage img;

  Particle(float x, float y, float xOffset, float yOffset, PImage img){
    loc = new PVector(x,y);

    float randDegrees = random(360);
    vel = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    vel.mult(random(5));

    acc = new PVector(0,0);
    lifeSpan = PApplet.parseInt(random(30, 90));
    decay = random(0.75f, 0.9f);

    c = color(243,243,249,189);
    weightRange = random(3,50);

    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.img = img;
  }

  public void update(){
    if(passedLife>=lifeSpan){
      dead = true;
    }else{
      passedLife++;
    }

    alpha = PApplet.parseFloat(lifeSpan-passedLife)/lifeSpan * 70+50;
    weight = PApplet.parseFloat(lifeSpan-passedLife)/lifeSpan * weightRange;

    acc.set(0,0);

    float rn = (noise((loc.x+frameCount+xOffset)*0.01f, (loc.y+frameCount+yOffset)*0.01f)-0.5f)*4*PI;
    float mag = noise((loc.y+frameCount)*0.01f, (loc.x+frameCount)*0.01f);
    PVector dir = new PVector(cos(rn),sin(rn));
    acc.add(dir);
    acc.mult(mag);

    float randDegrees = random(360);
    PVector randV = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    randV.mult(0.5f);
    acc.add(randV);

    vel.add(acc);
    vel.mult(decay);
    vel.limit(3);
    loc.add(vel);
  }

  public void display(){
     image(this.img,loc.x,loc.y);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Tarea_1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
