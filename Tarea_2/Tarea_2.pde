import controlP5.*;
import java.awt.Frame;
import SimpleOpenNI.*;
import java.io.*;

ControlP5 cp5;
//ControlFrame cf;
SimpleOpenNI context;
SceneManager manager;

boolean stopDraw = false;
ArrayList<Joints> jointsList;

int kWidth  = 640;
int kHeight = 480;

//timer
int interval         = 20000; //tiempo en milisegundos
boolean saved_file   = false;
int lastRecordedTime = 0;

String filename = "joints.txt";

void setup() {
  size(1280, 960);

  /*cf = addControlFrame("Controladores", 450, 700);
  manager = new SceneManager();*/

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
      Joints newFrame = new Joints(context);
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
  lastRecordedTime = millis();
  if (lastRecordedTime > interval && !saved_file) {
      println("guardo archivo");

      saved_file = true;
      try {
          writeJointsFile(filename, jointsList);
      } catch(FileNotFoundException e) {
          //handle exception
      }
  }
  //if (!stopDraw) manager.actualScene.drawScene();
}

void onNewUser(SimpleOpenNI curContext, int userId){
  println("onNewUser - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
}

public void writeJointsFile(String filename, ArrayList<Joints> joints) throws FileNotFoundException {
    PrintWriter pw = new PrintWriter(new FileOutputStream(sketchPath(filename)));
    pw.print("[");
    for (Joints joint : joints) {
        pw.print("["
                    + "{'head2d.x': " + joint.head2d.x + ", 'head2d.y': " + joint.head2d.y + "},"
                    + "{'neck2d.x': " + joint.neck2d.x + ", 'neck2d.y': " + joint.neck2d.y + "},"
                    + "{'torso2d.x': " + joint.torso2d.x + ", 'torso2d.y': " + joint.torso2d.y + "},"
                    + "{'rightHand2d.x': " + joint.rightHand2d.x + ", 'rightHand2d.y': " + joint.rightHand2d.y + "},"
                    + "{'rightElbow2d.x': " + joint.rightElbow2d.x + ", 'rightElbow2d.y': " + joint.rightElbow2d.y + "},"
                    + "{'rightHip2d.x': " + joint.rightHip2d.x + ", 'rightHip2d.y': " + joint.rightHip2d.y + "},"
                    + "{'leftHand2d.x': " + joint.leftHand2d.x + ", 'leftHand2d.y': " + joint.leftHand2d.y + "},"
                    + "{'leftElbow2d.x': " + joint.leftElbow2d.x + ", 'leftElbow2d.y': " + joint.leftElbow2d.y + "},"
                    + "{'leftHip2d.x': " + joint.leftHip2d.x + ", 'leftHip2d.y': " + joint.leftHip2d.y + "},"
                    + "{'rightFoot2d.x': " + joint.rightFoot2d.x + ", 'rightFoot2d.y': " + joint.rightFoot2d.y + "},"
                    + "{'rightShoulder2d.x': " + joint.rightShoulder2d.x + ", 'rightShoulder2d.y': " + joint.rightShoulder2d.y + "},"
                    + "{'rightKnee2d.x': " + joint.rightKnee2d.x + ", 'rightKnee2d.y': " + joint.rightKnee2d.y + "},"
                    + "{'leftFoot2d.x': " + joint.leftFoot2d.x + ", 'leftFoot2d.y': " + joint.leftFoot2d.y + "},"
                    + "{'leftShoulder2d.x': " + joint.leftShoulder2d.x + ", 'leftShoulder2d.y': " + joint.leftShoulder2d.y + "},"
                    + "{'leftKnee2d.x': " + joint.leftKnee2d.x + ", 'leftKnee2d.y': " + joint.leftKnee2d.y + "}"
                    + "],"
                    );
    }
    pw.print("]");
    pw.close();
}
