
import controlP5.*;

import java.awt.Frame;
import java.awt.BorderLayout;

private ControlP5 cp5;

ControlFrame cf;

int maxBalls = 15;
int numBalls = 1;
float spring = 0.05;
float gravity = 0.03;
float friction = -0.9;
Ball[] balls = new Ball[maxBalls];
boolean animateBalls;
// color del fondo (0-255)
int backCol;
//numero de los brazos (y la profundidad) del fractal
int num; 
// para modelar el tamano de los circulos
int extraAdd;

//define que tanto se acerca al centro la "apertura" de cada parte del fractal
float power = 4; 
//angulo de la apertura
float angle = TWO_PI; 
// define 
boolean toSwitch = true;

float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
                                   // the data from openni comes upside down
float        rotY = radians(0);
float        zoomF =1.0f;

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

CheckBox checkboxPelotitas;
Slider sliderPelotitas;



// esta funcion se ejecuta una vez sola, al principio
void setup(){
  // size define el tamano de nuestro sketch
  size(1024,768);
  // por defecto esta cargada la opcion de dibujar un contorno de color negro en las figuras
  // la queremos deshabilitar
  noStroke();
  cp5 = new ControlP5(this);
  cf = addControlFrame("Controladores", 250,200);
  backCol = 0;
  num = 6;
  extraAdd =0;
  animateBalls = false;
  
  
  for (int i = 0; i < maxBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, balls);
  }
    
  
};

// esta funcion se ejecuta todo el tiempo en un loop constante 
void draw(){
 
    // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  
 
  translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera
  
  
  //Pregunto si hay que dibujar pelotitas
  animateBalls = checkboxPelotitas.getState("Pelotitas");

  numBalls = (int)sliderPelotitas.getValue();
  
    
  
  // la funcion que creamos para dibujar el fondo ruidoso
  createNoisyBackground();  
  // la funcion que dibuja las barras de colores
  // le pasamos la cantidad de barras que queremos dibujar
  
  drawTv(colorsNr);
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
  int whichBar = (int)(mouseX / bar_width)  ;

  // dibujamos las barras
  for (int i = 0; i < bars_nr; i ++) {
    // dibujamos solo si el mouse no esta parado en esta barra
    if(whichBar != (i + 2) ) {
      // el color de la barra se corresponde a un color definido en el array color_bars[]
      fill(color_bars[i%colorsNr]);
      // dibujamos el rectangulo
      rect(i * bar_width, 0, bar_width, height);
      if (animateBalls && numBalls >= 1){
         drawBalls(); 
      }
    }
  }
}

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

