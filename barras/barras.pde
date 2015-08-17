import SimpleOpenNI.*;

SimpleOpenNI  context;

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


};

// esta funcion se ejecuta todo el tiempo en un loop constante
void draw(){
  // la funcion que creamos para dibujar el fondo ruidoso
  createNoisyBackground();
  // la funcion que dibuja las barras de colores
  // le pasamos la cantidad de barras que queremos dibujar
  drawTv(colorsNr, com);
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
      
      println("X: " + com2d.x);
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


void drawTv( int bars_nr, PVector pebete) {
  // definimos el ancho de las barras
  // por el tema del redondeo hacemos +1 para cubrir toda la pantalla
  int bar_width = width / bars_nr +1;
  // en funcion de la posicion x del mouse definimos cual de las barras de colores no se dibujara
  //int whichBar = (int)(mouseX / bar_width);
  int whichBar = (int)(abs(width-robledo(pebete.x)) / bar_width);

  // dibujamos las barras
  for (int i = 0; i < bars_nr; i ++) {
    // dibujamos solo si el mouse no esta parado en esta barra
    if(whichBar != i) {
      // el color de la barra se corresponde a un color definido en el array color_bars[]
      fill(color_bars[i%colorsNr]);
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

float robledo(float x){
  return (90(x-224)(x-275) / (177-224)(177-27) + 278(x-177)(x-275) / (275-177)(224-275) + 457(x-177)(x-224) / (275-177)(275-224));
}
