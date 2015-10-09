import controlP5.*;
import java.awt.Frame;
import SimpleOpenNI.*;
import java.io.*;
import ddf.minim.*;

ControlP5 cp5;
ControlFrame cf;
SimpleOpenNI context;

int kWidth  = 1024;
int kHeight = 768;

//variables de grabacion de movimiento
String recordPath = "test.oni";
PImage realImage;
PImage image;

//variables escena
PImage bg;
PImage bgSinClock;
PImage mano;
PImage scene_2_img;
MeltingClock clock;

//Imagenes
imagenesSilueta imagenes;

// Joints
PVector com        = new PVector();
PVector com2d      = new PVector();
PVector leftHand   = new PVector();
PVector leftHand2d = new PVector();

//Posicion inicial Reloj
float RELOJ_INITIAL_X = 274;
float RELOJ_INITIAL_Y = 274;

//Estados Reloj
String INITIAL           = "INITIAL"; // Reloj sin agarrar
String EN_MANO_IZQUIERDA = "EN_MANO_IZQUIERDA"; // Agarre el reloj
String OVER              = "OVER"; // Devolvi el reloj

//variables controles interfaz
String scene       = "firstScene";
boolean grab_clock = false;
boolean draw_shadow;
boolean invert_shadow  = false;
boolean end_scene;
boolean do_record      = false;
boolean do_play        = false;
boolean record_context = false;
boolean play_context   = false;
int calib_dist;

void setup() {
    //si ya existe un archivo lo elimino
    File file = new File(sketchPath("data/"+recordPath));
    if (file.delete())
        println("Archivo borrado.");
    else
        println("No existe archivo.");

    size(kWidth, kHeight);
    frameRate(30);

    cf = addControlFrame("Controladores", 320, 500);

    //escena_1
    bg = loadImage("stage1.png");
    bg.resize(kWidth, kHeight);

    bgSinClock = loadImage("stage2.png");
    bgSinClock.resize(kWidth, kHeight);

    mano         = loadImage("mano.png");
    clock        = new MeltingClock();
    clock.imagen = loadImage("meltingClock.png");

    //escena_2
    scene_2_img = loadImage("scene2.jpg");

    //escena_3
    imagenes = new imagenesSilueta();
    for (int i = 0; i < imagenes.cant_imgs; i++) {
        imagenes.addImagen((i + 1) + ".jpg", i);
    }

    // para imagen escalada
    image = new PImage(width,height,ARGB);

    //grabacion
    context = new SimpleOpenNI(this);
    if(context.isInit() == false){
        println("Can't init SimpleOpenNI, maybe the camera is not connected!");
        exit();
        return;
    }

    // enable depthMap generation
    context.enableDepth();
    // enable skeleton generation for all joints
    context.enableUser();

}

void draw() {
    if (scene == "firstScene") {
        if (clock.estado == EN_MANO_IZQUIERDA) {
            image(bgSinClock, 0, 0);
        } else {
            image(bg, 0, 0);
        }
    } else if (scene == "secondScene") {
        image(scene_2_img, 0, 0);
    }

    //interaccion con reloj
    if (grab_clock) {
        updateJointsPosition();

        boolean aunNoDevolviElReloj = clock.estado != OVER;
        if (aunNoDevolviElReloj){
            robarRelojDeEscena();
        }

        actualizarPosicionReloj(); //Muevo el reloj
        clock.mostrar();

        //DEBUG
        image(mano, leftHand2d.x,leftHand2d.y, 50, 50);
        //DEBUG
        // println("clock.x: " + clock.x);
        // println("clock.y: " + clock.y);
    }

    //grabacion / reproduccion / camara
    if (do_play || do_record) {
        if (record_context) {
            record_context = false;
            // setup the recording
            context.enableRecorder(recordPath);
            // select the recording channels
            context.addNodeToRecording(SimpleOpenNI.NODE_DEPTH,true);

        } else if (play_context) {
            play_context = false;
            context      = new SimpleOpenNI(this,recordPath);
            context.enableDepth();
        }

        context.update();
        if ((context.nodes() & SimpleOpenNI.NODE_DEPTH) != 0) {
            if (draw_shadow)
                drawShadow(context.depthMap(), context.depthMapSize());
        }

    } else if (end_scene) {
        end_scene = false;
        context   = new SimpleOpenNI(this);
        if(context.isInit() == false){
            println("Can't init SimpleOpenNI, maybe the camera is not connected!");
            exit();
            return;
        }
        context.enableDepth();
    }
}

void drawShadow(int[] dmap, int size){
  int count = 0;
  realImage = createImage(context.depthWidth(), context.depthHeight(), RGB);

  for(int i = 0; i < context.depthWidth(); i++){
    for(int j = 0; j < context.depthHeight(); j++){

      int index = i + j * context.depthWidth();
      int d = dmap[index];

      if (d < calib_dist){

        if (index + 1 < size && dmap[index + 1] < calib_dist){
          count++;
        }

        if (index - 1 >= 0 && dmap[index -1] < calib_dist){
          count++;
        }

        if ((index + context.depthWidth() < size) && (dmap[index + context.depthWidth()] < calib_dist)){
         count++;
        }

        if ((index - context.depthWidth() >= 0) && (dmap[index - context.depthWidth()] < calib_dist)){
          count++;
        }

        if (!invert_shadow){
          if (count < 4){
            realImage.pixels[index] = color(0, 0, 0, 128);
          }else{
            realImage.pixels[index] = color(30, 30, 30, 200);
          }
        }else{
          if (count < 4){
            realImage.pixels[index] = color(0, 0, 0, 0);
          }else{
            realImage.pixels[index] = color(0, 0, 0, 0);
          }
        }

      }else{
        if (!invert_shadow){
          realImage.pixels[index] = color(0, 0, 0, 0);
        }else{
          realImage.pixels[index] = color(0, 0, 0, 255);
        }
      }
      count = 0;
    }
  }

  realImage.updatePixels();
  image.loadPixels();
  // escalamos las imagenes
  image.copy(realImage, 0, 0, 640, 480, 0, 0, width, height);
  image(image,0,0);
}

void updateJointsPosition() {
    context.update();

    int[] userList = context.getUsers();
    for (int i = 0; i < userList.length; i++) {
        if (context.isTrackingSkeleton(userList[i])) {
            // Get Center of Mass
            if (context.getCoM(userList[i], com)) {
                context.convertRealWorldToProjective(com, com2d);
            }
            // Get left hand
            context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
            context.convertRealWorldToProjective(leftHand, leftHand2d);
        }
    }
}

void actualizarPosicionReloj() {
    clock.x = leftHand2d.x;
    clock.y = leftHand2d.y;
}

// Roba el reloj de la escena
void robarRelojDeEscena() {
    actualizarPosicionReloj();

    boolean posicionRobarClock = false;
    if (clock.estado == INITIAL) { //Tengo que agarrar el reloj
        float jointLeftX   = leftHand2d.x;
        float jointLeftY   = leftHand2d.y;
        posicionRobarClock = jointLeftX > 0 && Math.abs(clock.x - jointLeftX) <= 100 && Math.abs(clock.y - jointLeftY) <=  100;

        if (posicionRobarClock) { //Si la mano izquierda esta en la posicion del reloj, lo agarro
            clock.estado  = EN_MANO_IZQUIERDA;
            clock.visible = true;
            println("estado: " + clock.estado);
        }
    } else if (clock.estado == EN_MANO_IZQUIERDA){ // SI ESTOY LLEVANDO  EL RELOJ Y ALCANCE LA POSICION ORIGINAL, LO DEJO EN EL CUADRO
        posicionRobarClock = Math.abs(clock.x - RELOJ_INITIAL_X) <= 100 && Math.abs(clock.y - RELOJ_INITIAL_X) <=  100;
        //println("posicion robar clock: " + posicionRobarClock);
        if (clock.allow_release && posicionRobarClock) {
            clock.estado  = OVER;
            clock.visible = false;
            grab_clock    = false;
            println("estado: " + clock.estado);
        }
    }
}

//Evento fired cuando hay un new user
void onNewUser(SimpleOpenNI curContext, int userId) {
    println("onNewUser - userId: " + userId);
    curContext.startTrackingSkeleton(userId);
}
