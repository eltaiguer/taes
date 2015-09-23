import controlP5.*;
import java.awt.Frame;
import SimpleOpenNI.*;

ControlP5 cp5;
ControlFrame cf;
SimpleOpenNI  context;
SceneManager manager;

boolean stopDraw = false;
ArrayList<Joints> jointsList;

int kWidth  = 640;
int kHeight = 480;

void setup() {
  size(1280, 960);

  cf = addControlFrame("Controladores", 450, 700);
  manager = new SceneManager();

  // cosas kinect
  context = new SimpleOpenNI(this);
  if (context.isInit() == false) {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!");
    exit();
    return;
  }
  
  jointsList = new ArrayList<Joints>();

  frameRate(30);
  smooth();
  context.enableDepth();
  context.enableUser();
}


// Si se esta trackeando un esqueleto
// Se actualiza la posicion de cada Joint
// y su proyeccion en 2d.
// Estos valores son consultados por todos las escenas.
void update() {
  context.update();
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  
  for (int i=0; i<userList.length; i++) {
    
    if (context.isTrackingSkeleton(userList[i])) {
      Joints newFrame = new Joints();
      newFrame.updateJointsPosition(userList[i]);
      jointsList.add(newFrame);
    }
  }
}

// El draw principal
// 1. Actualiza la posicion de los Joints
// 2. Dibuja la escena seleccionada
void draw() {
  update();
  if (!stopDraw) manager.actualScene.drawScene();
}

void onNewUser(SimpleOpenNI curContext, int userId){
  println("onNewUser - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
}
