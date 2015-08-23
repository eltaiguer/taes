import SimpleOpenNI.*;
import java.awt.Frame;
import controlP5.*;

private ControlP5 cp5;
SimpleOpenNI  context;

//--------------------------------
//Tabla para dibujar colores noisy
int[] table = new int[256];

color[] userClr = new color[]{ color(255,0,0),
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

//-----------------------------------------
//Escala de grises para el noisy background
color[] color_bars_bnw = {  
   color(80,80,80),
   color(112,112,112),
   color(144,144,144),
   color(176,176,176),
   color(192,192,192),
   color(208,208,208),
   color(232,232,232),
   color(255,255,255)
 };

//-------------
//Controller UI
ControlFrame cf;
CheckBox checkboxInv;
CheckBox checkboxNoisyColor;
Slider alphaSlider;

// aca se guarda el nro total de los colores definidos
int colorsNr = color_bars.length;

// esta funcion se ejecuta una vez sola, al principio
void setup(){
  
  size(1280,960);  // size define el tamano de nuestro sketch
  // por defecto esta cargada la opcion de dibujar bun contorno de color negro en las figuras
  // la queremos deshabilitar
  noStroke();
  frameRate(30);
  
  cp5 = new ControlP5(this);
  cf = addControlFrame("Controladores",250,200);
  
  //---------------------------------------
  //Iniciamos el slider en el valor maximo
  alphaSlider.setValue(255);
  
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
  
  //----------------------------------------------------
  //Configuramos los animacion del noisy color backround
  for (int i = 0; i < 256; i++) {
    table[i] = (int)(128 + 127.0 * sin(i * TWO_PI / 256.0));
  }
};

 
void draw(){
  if (checkboxNoisyColor.getState("NoisyColor")){
    createColorNoisyBackground();
  } else {
    createNoisyBackground();
  }
  // la funcion que dibuja las barras de colores
  // le pasamos la cantidad de barras que queremos dibujar
  if (checkboxInv.getState("Invertir")){
    drawTvInvertido(colorsNr);
  }else{
    drawTv(colorsNr);
  }

  //cosas kinect
  // update the cam
  context.update();

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

//---------------------------------------
//Crea el noisy background usando colores 
void createColorNoisyBackground() {
  // grab some samples, hmm could have used lookup table...
  int t = (int)(128 + 127.0 * sin(0.0013 * (float)millis()));
  int t2 = (int)(128 + 127.0 * sin(0.0023 * (float)millis()));
  int t3 = (int)(128 + 127.0 * sin(0.0007 * (float)millis()));
   
  loadPixels();
   
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      // Define a function for each color component that depends on the
      // x,y coordinate and time. Use the lookup table for nice swirly movement.
      // There is no deeper logic here, I just experimented with the functions
      // untill I found something that looked pleasing.
      int r = table[(x / 5 + t / 4 + table[(t2 / 3 + y / 8) & 0xff]) & 0xff];
      int g = table[(y / 3 + t + table[(t3 + x / 5) & 0xff]) & 0xff];
      int b = table[(y / 4 + t2 + table[(t + g / 4 + x / 3) & 0xff]) & 0xff];
      pixels[x + y * width] = color(r, g, b);
    }
  }
   
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
      if (checkboxNoisyColor.getState("NoisyColor")){
        fill(color_bars_bnw[i%colorsNr],(int)alphaSlider.getValue());
      }else{
        fill(color_bars[i%colorsNr],(int)alphaSlider.getValue());
      }
      // dibujamos el rectangulo
      rect(i * bar_width, 0, bar_width, height); 
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
      if (checkboxNoisyColor.getState("NoisyColor")){
        fill(color_bars_bnw[i%colorsNr],(int)alphaSlider.getValue());
      }else{
        fill(color_bars[i%colorsNr],(int)alphaSlider.getValue());
      }
      // dibujamos el rectangulo
      rect(i * bar_width, 0, bar_width, height); 
    }
  }
}

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

// -------------------- 
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
