import SimpleOpenNI.*;
import java.awt.Frame;
import controlP5.*;

private ControlP5 cp5;

SimpleOpenNI  context;

// Booleano para invertir 
boolean inv = false;

// Bars alpha
int alpha = 180;

color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };

PVector com = new PVector();
PVector com2d = new PVector();

// aca estan los colores de las barras
// definidos en el colorMode RGB -> https://processing.org/reference/colorMode_.html
// color( R, G, B)
color[] color_bars={
  color(192,192,192),
  color(192,192,0),
  color(0,192,192),
  color(0,192,0),
  color(192,0,192),
  color(192,0,0),
  color(0,0,192)
};

ControlFrame cf;

//*****PELOTAS*********//
int maxBalls   = 15;
int numBalls   = 1;
float spring   = 0.05;
float gravity  = 0.03;
float friction = -0.9;
Ball[] balls   = new Ball[maxBalls];
boolean animateBalls;
int num;
int backCol;
int extraAdd;
float angle      = TWO_PI;
boolean toSwitch = true;
//*****PELOTAS*********//

//*****PELOTAS*********//
CheckBox checkboxPelotitas;
Slider sliderPelotitas;
Toggle invToggle;
Slider alphaSlider;
//*****PELOTAS*********//

// aca se guarda el nro total de los colores definidos
int colorsNr = color_bars.length;

// esta funcion se ejecuta una vez sola, al principio
void setup(){
  // size define el tamano de nuestro sketch
  //size(1024,768);
  size(1280,960);
  // por defecto esta cargada la opcion de dibujar bun contorno de color negro en las figuras
  // la queremos deshabilitar
  noStroke();

  // cosas kinect
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!");
     exit();
     return;
  }

 // context.setMirror(false);

  // enable depthMap generation
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();

 // context.enableRGB();

  //*****PELOTAS*********//
  cp5          = new ControlP5(this);
  cf           = addControlFrame("Controladores", 250, 200);
  backCol      = 0;
  num          = 6;
  extraAdd     = 0;
  animateBalls = false;

  for (int i = 0; i < maxBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, balls);
  }
 //******PELOTAS********//

};

// esta funcion se ejecuta todo el tiempo en un loop constante
void draw(){

  //******PELOTAS********//
  //Pregunto si hay que dibujar pelotitas
  animateBalls = checkboxPelotitas.getState("Pelotitas");

  numBalls = (int)sliderPelotitas.getValue();
  //******PELOTAS********//


  // la funcion que creamos para dibujar el fondo ruidoso
  createNoisyBackground();
  // la funcion que dibuja las barras de colores
  // le pasamos la cantidad de barras que queremos dibujar
  if (invToggle.getState()){
    drawTvInvertido(colorsNr);
  }else{
    drawTv(colorsNr);
  }

  //cosas kinect
  // update the cam
  context.update();

  // draw depthImageMap
  //image(context.depthImage(),0,0);
 // image(context.userImage(),0,0);

  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    }

    // draw the center of mass
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);
      stroke(100,255,0);
      strokeWeight(1);
      beginShape(LINES);
        vertex(com2d.x,com2d.y - 5);
        vertex(com2d.x,com2d.y + 5);

        vertex(com2d.x - 5,com2d.y);
        vertex(com2d.x + 5,com2d.y);
      endShape();

      fill(0,255,100);
      text(Integer.toString(userList[i]),com2d.x,com2d.y);

      //println("X: " + com2d.x);
      println("Z: " + com.z);
    //  println("mouse: " + mouseX/ bar_width);
    }
  }

};

void createNoisyBackground(){
  // una función ya dada que carga los datos de los píxeles de la pantalla de visualización en el pixels [] array
  // siempre debe ser llamada antes de leer o escribir en pixels [].
  loadPixels();

  // recorremos todos los pixeles
  for (int i = 0; i < pixels.length; i++) {
    // y si el numero que fue "sorteado" en la funcion random(x) es mayor de 50 el pixel va a ser blanco
    if(random(100)>50) pixels[i] = color(255);
    // en el caso contrario, sera negro
    else pixels[i] = color(40);
  }
  // una función ya dada que actualiza la ventana de la pantalla con los datos de los pixels [] array
  updatePixels();
}


void drawTv( int bars_nr) {
  // definimos el ancho de las barras 
  // por el tema del redondeo hacemos +1 para cubrir toda la pantalla
  int bar_width = width / bars_nr +1;
  // en funcion de la posicion x del mouse definimos cual de las barras de colores no se dibujara
  int whichBar = -1;
  if (com.z >= 2500){
    whichBar = (int)((1280-(com2d.x*2)) / bar_width);
  }
  else if(com.z <= 2500){
    whichBar = (int)((1280-(com2d.x*1.8)) / bar_width);
  }

  // dibujamos las barras
  for (int i = 0; i < bars_nr; i ++) {
    // dibujamos solo si el mouse no esta parado en esta barra
    if(whichBar != i) {
      // el color de la barra se corresponde a un color definido en el array color_bars[]
      fill(color_bars[i%colorsNr],(int)alphaSlider.getValue());
      // dibujamos el rectangulo
      rect(i * bar_width, 0, bar_width, height); 
      
      //*****PELOTAS*********//
      if (animateBalls && numBalls >= 1){
         drawBalls();
      }
      //*****PELOTAS*********//
    }
  }
}

void drawTvInvertido( int bars_nr) {
  // definimos el ancho de las barras 
  // por el tema del redondeo hacemos +1 para cubrir toda la pantalla
  int bar_width = width / bars_nr +1;
  // en funcion de la posicion x del mouse definimos cual de las barras de colores no se dibujara
  int whichBar = -1;
  if (com.z >= 2500){
    whichBar = (int)((1280-(com2d.x*2)) / bar_width);
  }
  else if(com.z <= 2500){
    whichBar = (int)((1280-(com2d.x*1.8)) / bar_width);
  }

  // dibujamos las barras
  for (int i = 0; i < bars_nr; i ++) {
    // dibujamos solo si el mouse no esta parado en esta barra
    if(whichBar == i) {
      // el color de la barra se corresponde a un color definido en el array color_bars[]
      fill(color_bars[i%colorsNr],(int)alphaSlider.getValue());
      // dibujamos el rectangulo
      rect(i * bar_width, 0, bar_width, height); 
      
      //*****PELOTAS*********//
      if (animateBalls && numBalls >= 1){
         drawBalls();
      }
      //*****PELOTAS*********//
    }
  }
}

//******* PELOTAS *******//
void drawBalls(){
  int iter = 1;
  for (Ball ball : balls) {
    if (iter <= numBalls) {
      ball.collide();
      ball.move();
      ball.display();
      iter++;
    }
  }
}
//******PELOTAS********//

//mas kinect

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */

  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
