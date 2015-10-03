import SimpleOpenNI.*;
import java.awt.Frame;
import controlP5.*;
import ddf.minim.*;


 
PImage bg;
PImage bgSinClock;
PImage mano;
MeltingClock clock;
SimpleOpenNI  context;

// ----------------------------
// Joints
PVector com    = new PVector();
PVector com2d  = new PVector();
PVector leftHand   = new PVector();
PVector leftHand2d = new PVector();

int kWidth  = 1024;
int kHeight = 768;

//--------------------------
//Posicion inicial Reloj
float RELOJ_INITIAL_X = 274;
float RELOJ_INITIAL_Y = 274;

//-----------------
//Estados Reloj
String INITIAL = "INITIAL"; // Reloj sin agarrar
String EN_MANO_IZQUIERDA = "EN_MANO_IZQUIERDA"; // Agarre el reloj
String EN_CENTRO_DE_MASA = "EN_CENTRO_DE_MASA"; // El reloj esta en el centro de masa proyectado
String FINAL = "FINAL"; // Devolviendo el reloj
String OVER = "OVER"; // Devolvi el reloj

void setup() {
  size(1024,768);
   
 
  //*******dali
    bg = loadImage("stage1.png");
    bg.resize(1024,768);
    
    bgSinClock = loadImage("stage2.png");
    bgSinClock.resize(1024,768);
  
    mano = loadImage("mano.png");
  
    clock = new MeltingClock();
    clock.imagen = loadImage("meltingClock.png");  
  //*******dali
  
  
 // smooth();
  
  // cosas kinect
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
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

  

};

void drawJoinit(PVector joint) {
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


void draw() {
   if (clock.visible ){
     image(bgSinClock, 0,0);
  } else {
     image(bg, 0,0);
  } 
  updateJointsPosition();
  
  boolean aunNoDevolviElReloj = clock.estado != OVER;
  if (aunNoDevolviElReloj){ 
    robarRelojDeEscena(); 
  }
  
  actualizarPosicionReloj(); //Muevo el reloj hasta encontrar la posicion inicial
  clock.mostrar();
  
  //DEBUG
  image(mano, leftHand2d.x,leftHand2d.y, 50,50);
   //DEBUG
  
  println("estado: " + clock.estado);
  println("clock.x: " + clock.x);
  println("clock.y: " + clock.y);
  println("habilitadoPorControlUI : " + clock.habilitadoPorControlUI);
};

void mouseMoved(){
  println("mouseX: " + mouseX);
  println("mouseY: " + mouseY);
}
void mouseClicked(){
  clock.habilitadoPorControlUI = !clock.habilitadoPorControlUI;
}
void actualizarPosicionReloj(){
   if (clock.estado == EN_MANO_IZQUIERDA){  //tengo el reloj en la mano izquierda, que siga la mano izquierda
      float jointLeftX = leftHand2d.x; 
      float jointLeftY = leftHand2d.y;
      clock.x = jointLeftX;  
      clock.y = jointLeftY;       
   } else if (clock.estado == EN_CENTRO_DE_MASA){  //Si tengo el reloj en el centro de masa lo proyecto en el centro de masa
     /* float centroMasaX = width/2;// com2d.x;  
      float centroMasaY = height/2;//com2d.y; 
      clock.x = centroMasaX; 
      clock.y = centroMasaY;
      */      
   } else { // debe seguir la mano izquierda
      float jointLeftX = leftHand2d.x; 
      float jointLeftY = leftHand2d.y;
      clock.x = jointLeftX;  
      clock.y = jointLeftY;
   } 
   
}

//---------------------------
// Roba el reloj de la escena 
void robarRelojDeEscena() {
   
   actualizarPosicionReloj();
   
   boolean posicionRobarClock = false;
   if (clock.estado == INITIAL) { //Tengo que agarrar el reloj
      float jointLeftX = leftHand2d.x; 
      float jointLeftY = leftHand2d.y; 
      posicionRobarClock = jointLeftX > 0 && Math.abs(clock.x - jointLeftX) <= 20 && Math.abs(clock.y - jointLeftY) <=  20;
      
      if (clock.habilitadoPorControlUI && posicionRobarClock ) { //Si la mano izquierda esta en la posicion del reloj, lo agarro
         clock.estado = EN_MANO_IZQUIERDA;
         clock.visible = true;
      }
   } else if (clock.estado == EN_MANO_IZQUIERDA){ //Debo llevar el reloj hacia el centro de masa
      float centroMasaX =  500;//com2d.x;   // CAMBIAR!!!!
      float centroMasaY =  300;//com2d.y;   // CAMBIAR!!!!
      posicionRobarClock = Math.abs(clock.x - centroMasaX) <= 20  && Math.abs(centroMasaY - clock.y) <= 20;
     if (clock.habilitadoPorControlUI && posicionRobarClock ) { //Dejo el reloj en el centro de masa        
         clock.estado = EN_CENTRO_DE_MASA;
         clock.habilitadoPorControlUI = false; // BORRAR CUANDO SE TENGA EL CONTROL UI !!!!!
     }
   } else if (clock.estado == EN_CENTRO_DE_MASA){  //Debo llevar el reloj del centro de masa al cuadro
      float jointLeftX = leftHand2d.x;
      float jointLeftY =leftHand2d.y;
      posicionRobarClock = jointLeftX > 0 && Math.abs(clock.x - jointLeftX) <= 20 && Math.abs(clock.y - jointLeftY) <=  20;      
      if (clock.habilitadoPorControlUI && posicionRobarClock ) { //MARCO INICIO DEL MOVIMIENTO
            clock.estado = FINAL;        
      }   
   } else if (clock.estado == FINAL){ // SI ESTOY LLEVANDO  EL RELOJ Y ALCANCE LA POSICION ORIGINAL, LO DEJO EN EL CUADRO  
      posicionRobarClock = Math.abs(clock.x - RELOJ_INITIAL_X) <= 20 && Math.abs(clock.y - RELOJ_INITIAL_X) <=  20;      
      if (clock.habilitadoPorControlUI && posicionRobarClock ) { //Si lleve el reloj al centro de masa, proyecto el reloj en el centro de masa
         clock.estado = OVER;
         clock.visible = false;
      }       
   }      
}


class MeltingClock {
  boolean visible;  // indica si se muestra o no se muestra el reloj
  String estado;  // intial, en mano izquierda, en centro de masa, pre_final, final
  float x; // posicion x del reloj
  float y; // posicion y del reloj
  PImage imagen; // imagen a mostrar
  boolean habilitadoPorControlUI; //Variable que hace que el reloj siga a la mano izquierda, a controlar por UI
   
   MeltingClock() {
    this.visible = false;
    this.habilitadoPorControlUI = true;
    this.x = RELOJ_INITIAL_X;
    this.y = RELOJ_INITIAL_Y;
    this.estado = INITIAL;
  } 
  
  void mostrar() {
    if (this.visible) {
       this.latir();
    }    
  }
  
  void latir() {
      //Late una vez por segundo
      float x = millis()/250.0;
      float c01 = cos(2*x);
      float c02 = cos(1+5*x);
      float c03 = 1+((c01+c02)/6);      
      float heartPulse = pow(c03,5.0);      
      float heartH = map(heartPulse, 0, 3,  320,345);
      
      image(this.imagen, this.x, this.y, 279, heartH);
  }
};

//Evento fired cuando hay un new user
void onNewUser(SimpleOpenNI curContext, int userId){
  println("onNewUser - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
}

  

