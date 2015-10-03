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
boolean recording = false;
boolean do_record = false;
//calibracion distancia
int calib_dist;

//variables escena
PImage bg;
PImage bgSinClock;
PImage mano;
MeltingClock clock;
boolean grab_clock = false;

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
String EN_CENTRO_DE_MASA = "EN_CENTRO_DE_MASA"; // El reloj esta en el centro de masa proyectado
String FINAL             = "FINAL"; // Devolviendo el reloj
String OVER              = "OVER"; // Devolvi el reloj

void setup() {
    //si ya existe un archivo lo elimino
    File file = new File(sketchPath("data/"+recordPath));
    if (file.delete())
        println("Archivo borrado.");
    else
        println("No existe archivo.");

    size(kWidth, kHeight);
    frameRate(30);

    cf = addControlFrame("Controladores", 320, 190);

    //*******dali
    bg = loadImage("stage1.png");
    bg.resize(kWidth, kHeight);

    bgSinClock = loadImage("stage2.png");
    bgSinClock.resize(kWidth, kHeight);

    mano = loadImage("mano.png");

    clock        = new MeltingClock();
    clock.imagen = loadImage("meltingClock.png");
    //*******dali

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

    // setup the recording
    context.enableRecorder(recordPath);
    // select the recording channels
    context.addNodeToRecording(SimpleOpenNI.NODE_DEPTH,true);
    //reproduccion
}

void draw() {
    if (clock.visible ){
        image(bgSinClock, 0, 0);
    } else {
        image(bg, 0, 0);
    }

    //durante escena
    if (grab_clock) {
        updateJointsPosition();

        boolean aunNoDevolviElReloj = clock.estado != OVER;
        if (aunNoDevolviElReloj){
            robarRelojDeEscena();
        }

        actualizarPosicionReloj(); //Muevo el reloj hasta encontrar la posicion inicial
        clock.mostrar();

        //DEBUG
        image(mano, leftHand2d.x,leftHand2d.y, 50, 50);
        //DEBUG

        println("estado: " + clock.estado);
        // println("clock.x: " + clock.x);
        // println("clock.y: " + clock.y);
        println("habilitadoPorControlUI : " + clock.habilitadoPorControlUI);
    }

    //grabo
    if (do_record) {
        if (!recording) {
            println("Comienza grabación");
            recording = true;
        }

        context.update();

        background(0, 0, 0);

        if ((context.nodes() & SimpleOpenNI.NODE_DEPTH) != 0) {
            image(context.depthImage(), 0, 0);
        }

        // draw timeline
       // if(recordFlag == false){
          int[] dmap = context.depthMap();
          int size = context.depthMapSize();
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

                  if (count < 4){
                    realImage.pixels[index] = color(255, 0, 0);
                  }else{
                    realImage.pixels[index] = color(0, 100, 0);
                  }

                }else{
                  realImage.pixels[index] = color(0, 0, 0);
                }
                count = 0;
              }
          }

          realImage.updatePixels();
          image.loadPixels();
          // escalamos las imagenes
          image.copy(realImage, 0, 0, 640, 480, 0, 0, width, height);
          image(image,0,0);
          drawTimeline();
          text("curFramePlayer: " + context.curFramePlayer(),10,10);
         // }

    }

    //paro grabacion
    if (recording && !do_record) {
        println("Grabación detenida");
        recording = false; do_record = true;

        context = new SimpleOpenNI(this,recordPath);
        context.enableDepth();
    }
}

void drawTimeline() {
    pushStyle();

    stroke(255,255,0);
    line(10, height - 20, width -10 , height - 20);

    stroke(0);
    rectMode(CENTER);
    fill(255,255,0);

    int pos = (int)((width - 2 * 10) * (float)context.curFramePlayer() / (float)context.framesPlayer());
    rect(pos, height - 20, 7, 17);

    popStyle();
}

void updateJointsPosition() {
    context.update();

    // draw the skeleton if it's available
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
    if (clock.estado == EN_MANO_IZQUIERDA){  //tengo el reloj en la mano izquierda, que siga la mano izquierda
        float jointLeftX = leftHand2d.x;
        float jointLeftY = leftHand2d.y;
        clock.x          = jointLeftX;
        clock.y          = jointLeftY;
    } else if (clock.estado == EN_CENTRO_DE_MASA){  //Si tengo el reloj en el centro de masa lo proyecto en el centro de masa
        /* float centroMasaX = width/2;// com2d.x;
        float centroMasaY = height/2;//com2d.y;
        clock.x = centroMasaX;
        clock.y = centroMasaY;
        */
    } else { // debe seguir la mano izquierda
        float jointLeftX = leftHand2d.x;
        float jointLeftY = leftHand2d.y;
        clock.x          = jointLeftX;
        clock.y          = jointLeftY;
    }

}

// Roba el reloj de la escena
void robarRelojDeEscena() {
    actualizarPosicionReloj();

    boolean posicionRobarClock = false;
    if (clock.estado == INITIAL) { //Tengo que agarrar el reloj
        float jointLeftX   = leftHand2d.x;
        float jointLeftY   = leftHand2d.y;
        posicionRobarClock = jointLeftX > 0 && Math.abs(clock.x - jointLeftX) <= 20 && Math.abs(clock.y - jointLeftY) <=  20;

        if (clock.habilitadoPorControlUI && posicionRobarClock) { //Si la mano izquierda esta en la posicion del reloj, lo agarro
            clock.estado  = EN_MANO_IZQUIERDA;
            clock.visible = true;
            //do_record     = true; //Comienzo a grabar
        }
    } else if (clock.estado == EN_MANO_IZQUIERDA){ //Debo llevar el reloj hacia el centro de masa
        float centroMasaX  = 500;//com2d.x;   // CAMBIAR!!!!
        float centroMasaY  = 300;//com2d.y;   // CAMBIAR!!!!
        posicionRobarClock = Math.abs(clock.x - centroMasaX) <= 20  && Math.abs(centroMasaY - clock.y) <= 20;
        if (clock.habilitadoPorControlUI && posicionRobarClock) { //Dejo el reloj en el centro de masa
            clock.estado = EN_CENTRO_DE_MASA;
            clock.habilitadoPorControlUI = false;
        }
    } else if (clock.estado == EN_CENTRO_DE_MASA){  //Debo llevar el reloj del centro de masa al cuadro
        float jointLeftX   = leftHand2d.x;
        float jointLeftY   = leftHand2d.y;
        posicionRobarClock = jointLeftX > 0 && Math.abs(clock.x - jointLeftX) <= 20 && Math.abs(clock.y - jointLeftY) <=  20;
        if (clock.habilitadoPorControlUI && posicionRobarClock) { //MARCO INICIO DEL MOVIMIENTO
            clock.estado = FINAL;
        }
    } else if (clock.estado == FINAL){ // SI ESTOY LLEVANDO  EL RELOJ Y ALCANCE LA POSICION ORIGINAL, LO DEJO EN EL CUADRO
        posicionRobarClock = Math.abs(clock.x - RELOJ_INITIAL_X) <= 20 && Math.abs(clock.y - RELOJ_INITIAL_X) <=  20;
        if (clock.habilitadoPorControlUI && posicionRobarClock) { //Si lleve el reloj al centro de masa, proyecto el reloj en el centro de masa
            clock.estado  = OVER;
            clock.visible = false;
            grab_clock    = false;
            //do_record     = false; //Detengo grabacion y comienzo reproduccion
        }
    }
}

//Evento fired cuando hay un new user
void onNewUser(SimpleOpenNI curContext, int userId) {
    println("onNewUser - userId: " + userId);
    curContext.startTrackingSkeleton(userId);
}
