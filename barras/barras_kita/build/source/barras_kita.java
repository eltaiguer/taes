import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 
import java.awt.Frame; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class barras_kita extends PApplet {





SimpleOpenNI  context;

int[]       userClr = new int[]{ color(255,0,0),
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
int[] color_bars={
  color(192,192,192),
  color(192,192,0),
  color(0,192,192),
  color(0,192,0),
  color(192,0,192),
  color(192,0,0),
  color(0,0,192)
};

//*****PELOTAS*********//
int maxBalls = 15;
int numBalls = 1;
float spring = 0.05f;
float gravity = 0.03f;
float friction = -0.9f;
Ball[] balls = new Ball[maxBalls];
boolean animateBalls;
//*****PELOTAS*********//

//*****PELOTAS*********//
CheckBox checkboxPelotitas;
Slider sliderPelotitas;
//*****PELOTAS*********//

// aca se guarda el nro total de los colores definidos
int colorsNr = color_bars.length;

// esta funcion se ejecuta una vez sola, al principio
public void setup(){
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
  cp5          = new controlP5(this);
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
public void draw(){

  //******PELOTAS********//
  //Pregunto si hay que dibujar pelotitas
  animateBalls = checkboxPelotitas.getState("Pelotitas");

  numBalls = (int)sliderPelotitas.getValue();
  //******PELOTAS********//


  // la funcion que creamos para dibujar el fondo ruidoso
  createNoisyBackground();
  // la funcion que dibuja las barras de colores
  // le pasamos la cantidad de barras que queremos dibujar
  drawTv(colorsNr);
//image(context.rgbImage(), 0, 0);

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

public void createNoisyBackground(){
  // una funci\u00f3n ya dada que carga los datos de los p\u00edxeles de la pantalla de visualizaci\u00f3n en el pixels [] array
  // siempre debe ser llamada antes de leer o escribir en pixels [].
  loadPixels();

  // recorremos todos los pixeles
  for (int i = 0; i < pixels.length; i++) {
    // y si el numero que fue "sorteado" en la funcion random(x) es mayor de 50 el pixel va a ser blanco
    if(random(100)>50) pixels[i] = color(255);
    // en el caso contrario, sera negro
    else pixels[i] = color(40);
  }
  // una funci\u00f3n ya dada que actualiza la ventana de la pantalla con los datos de los pixels [] array
  updatePixels();
}


public void drawTv( int bars_nr) {
  // definimos el ancho de las barras
  // por el tema del redondeo hacemos +1 para cubrir toda la pantalla
  int bar_width = width / bars_nr +1;
  // en funcion de la posicion x del mouse definimos cual de las barras de colores no se dibujara
  //int whichBar = (int)(mouseX / bar_width);

    int whichBar = -1;
    if (com.z >= 2500){
      whichBar = (int)((1280-(com2d.x*2)) / bar_width);
    }
    else if(com.z <= 2500){
      whichBar = (int)((1280-(com2d.x*1.8f)) / bar_width);
    }

  // dibujamos las barras
  for (int i = 0; i < bars_nr; i ++) {
    // dibujamos solo si el mouse no esta parado en esta barra
    if(whichBar != i) {
      // el color de la barra se corresponde a un color definido en el array color_bars[]
      fill(color_bars[i%colorsNr]);
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
public void drawBalls(){
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
public void drawSkeleton(int userId)
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

public void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

public void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

public void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
public class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  public void collide() {
    for (int j = id + 1; j < numBalls; j++) {
      float dx = mouseX/*others[j].x*/ - x;
      float dy = mouseY/*others[j].y*/ - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = /*others[j].diameter/2 +*/ diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - mouseX/*others[j].x*/) * spring;
        float ay = (targetY - mouseY/*others[j].y*/) * spring;
        vx -= ax;
        vy -= ay;
        if (j < others.length){
          others[j].vx += ax;
          others[j].vy += ay;
        }
      }
    }   
  }
  
  public void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  public void display() {
    fill(0xff4395CB,100);
    ellipse(x, y, diameter, diameter);
   
  }
}

public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

     checkboxPelotitas = cp5.addCheckBox("checkBox")
                .setPosition(10, 110)
                .setColorForeground(color(120))
                .setColorActive(color(255))
                .setColorLabel(color(255))
                .setSize(20, 20)
                .setItemsPerRow(3)
                .setSpacingColumn(30)
                .setSpacingRow(20)
                .addItem("Pelotitas", 50);

     sliderPelotitas =  cp5.addSlider("Numero de Pelotitas")
      .plugTo(parent,"num")
      .setRange(1, 20)
      .setPosition(10,140);
  }
  public void draw() {
    background(0);
  }
  private ControlFrame() {
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w      = theWidth;
    h      = theHeight;
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "barras_kita" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
