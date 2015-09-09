import controlP5.*;
import java.awt.Frame;
import SimpleOpenNI.*;

ControlP5 cp5;

ControlFrame cf;

SimpleOpenNI  context;

PVector com = new PVector();
PVector com2d = new PVector();

// para cambiar fluidamente entre las escenas
SceneManager manager;

boolean stopDraw = false;

void setup(){
  size(1280,960);
  cf = addControlFrame("Controladores", 450,700);
  manager = new SceneManager();
  
  // cosas kinect
  context = new SimpleOpenNI(this);
  if(context.isInit() == false){
     println("Can't init SimpleOpenNI, maybe the camera is not connected!");
     exit();
     return;
  }

  //---------------------------
  // enable depthMap generation
  context.enableDepth();

  //--------------------------------------------
  // enable skeleton generation for all joints
  context.enableUser();
}

void draw(){
  if(!stopDraw) manager.actualScene.drawScene(); 
}
