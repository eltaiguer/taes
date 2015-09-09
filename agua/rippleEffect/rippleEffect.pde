import SimpleOpenNI.*;

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/7715*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
// A simple ripple effect. Click on the image to produce a ripple
// Author: radio79
// Code adapted from http://www.neilwallis.com/java/water.html


//************* RIPPLE EFFECT ****************************//
PImage img,bubble,coral;
Ripple ripple;

//**************** kinect
PVector com = new PVector();
PVector com2d = new PVector();

//************************** BUBBLES ************///
ArrayList<Particle> pts;
ArrayList<floatingObj> fts;
boolean onPressed, showInstruction;
PFont f1, f2;

//******************************* VARIABLES MOVIMIENTO ***************************//
float preivousJointPossition;
//******************************* VARIABLES MOVIMIENTO ***************************//

//****************************************** TIMER **************************************//
int interval = 1500;//timer's interval
int lastRecordedTime = 0;
//****************************************** TIMER **************************************//

boolean automaticWaves =false;

//***************************** kinect
SimpleOpenNI  context;



void setup() {
  img = loadImage("data/ocean1.jpg");
  bubble =   loadImage("data/bubble.png");
  bubble.resize(50,50);
  coral = loadImage("data/coral.png");
  coral.resize(100,100);
  img.resize(1280,960);
  // size(1024,768);
   size(1280,960);  // size define el tamano de nuestro sketch
  
  ripple = new Ripple();
  frameRate(60);
  
  //**************** BUBBLES ******************************//
  pts = new ArrayList<Particle>();

  showInstruction = true;

//***************************** VARIABLES MOVIMIENTO **************************//
  preivousJointPossition = 0;
//******************************* VARIABLES MOVIMIENTO ***************************//


//************************ floatando
fts = new ArrayList<floatingObj>() ;
 for (int i=0;i<3;i++) {
      floatingObj newP = new floatingObj(10 + i*100, height - 100, coral);
      fts.add(newP);
 }
 
 //******************* cosas kinect
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

  

}// END SETUP

void draw() {
  loadPixels(); 
  img.loadPixels();
  for (int loc = 0; loc < width * height; loc++) {
    pixels[loc] = ripple.col[loc];
  }
  updatePixels();
  
 //******************* BUBBLES***************************//
 if (onPressed) {
    for (int i=0;i<10;i++) {
      float x_coord  = map(com2d.x, 0, 640, 0, 1280);
      float y_coord = map(com2d.y, 0, 480, 0, 960);
      Particle newP = new Particle(/*mouseX */x_coord , /*mouseY*/y_coord, i+pts.size(), i+pts.size(),this.bubble);
      pts.add(newP);
    }
  }

  for (int i=0; i<pts.size(); i++) {
    Particle p = pts.get(i);
    p.update();
    p.display();
  }

  for (int i=pts.size()-1; i>-1; i--) {
    Particle p = pts.get(i);
    if (p.dead) {
      pts.remove(i);
    }
  }
 //********************* BUBBLES ***************************//
  
 
  ripple.newframe();
  //****************************************** TIMER **************************************//
 if(millis()-lastRecordedTime>interval){
     
   mouseMovedLZ(); // Para mostrar ripple effect
   mousePressedLZ(); // Para mostrar bubbles
  
   //and record time for next tick
   lastRecordedTime = millis();
    
  } else {
    mouseReleasedLZ();
  }
//****************************************** TIMER **************************************//
    
    mouseMovedLZ();
    
    mouseMovedAutomaticLZ();
    
    
    //*******************floating 
    for (int i=0; i<fts.size(); i++) {
      floatingObj ft = fts.get(i);
      ft.update();
      if (!ft.dead || (ft.dead && ft.lifeTime >= 0)){
        ft.display();
      }   
    }
    
    ///*******************cosas kinect
    
  //cosas kinect
  // update the cam
  context.update();
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    // draw the center of mass
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);
    }
  }
}



class floatingObj {
  float y,x,g,acceleration,lifeTime;
  boolean active, dead;
  int factor;
  PImage img;
   floatingObj(float x,float y, PImage img) {
       this.x = x;
       this.y =y;
       this.active = false;
       this.g = .8;
       this.factor = -1;
       this.img = img;
       this.lifeTime = 150;
       this.dead = false;
   }
   
   void display(){
      image(this.img,this.x ,this.y);
   }
   
   void update(){
         if (!this.active) {
           this.y += this.factor;
           this.factor *= -1;
         }
         float x_coord  = map(com2d.x, 0, 640, 0, 1280);
         float y_coord = map(com2d.y, 0, 480, 0, 960);
         if (  Math.abs(y_coord /*mouseY*/ - this.y) <=  100 &&  Math.abs(/*mouseX*/ x_coord - this.x) <= 100){
            this.active = true;
         }
         //println(mouseY +" == " + this.y);
         if (this.active && (this.y - this.g > 200)){
           this.y -= this.g;
         } else if (this.active) {
          this.active = false;
          this.dead = true;
         }
         if (this.dead){
           this.lifeTime--;
         }
   }
}

class Ripple {
  int i, a, b;
  int oldind, newind, mapind;
  short ripplemap[]; // the height map
  int col[]; // the actual pixels
  int riprad;
  int rwidth, rheight;
  int ttexture[];
  int ssize;

  Ripple() {
    // constructor
    riprad = 3;
    rwidth = width >> 1;
    rheight = height >> 1;
    ssize = width * (height + 2) * 2;
    ripplemap = new short[ssize];
    col = new int[width * height];
    ttexture = new int[width * height];
    oldind = width;
    newind = width * (height + 3);
  }



  void newframe() {
    // update the height map and the image
    i = oldind;
    oldind = newind;
    newind = i;

    i = 0;
    mapind = oldind;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        short data = (short)((ripplemap[mapind - width] + ripplemap[mapind + width] + 
          ripplemap[mapind - 1] + ripplemap[mapind + 1]) >> 1);
        data -= ripplemap[newind + i];
        data -= data >> 5;
        if (x == 0 || y == 0) // avoid the wraparound effect
          ripplemap[newind + i] = 0;
        else
          ripplemap[newind + i] = data;

        // where data = 0 then still, where data > 0 then wave
        data = (short)(1024 - data);

        // offsets
        a = ((x - rwidth) * data / 1024) + rwidth;
        b = ((y - rheight) * data / 1024) + rheight;

        //bounds check
        if (a >= width) 
          a = width - 1;
        if (a < 0) 
          a = 0;
        if (b >= height) 
          b = height-1;
        if (b < 0) 
          b=0;

        col[i] = img.pixels[a + (b * width)];
        mapind++;
        i++;
      }
    }
  }
}


//****** MOUSE EVENTS

//******************************* BUBBLES **************************************************//
void mousePressed() {
  onPressed = true;
  if (showInstruction) {
    background(255);
    showInstruction = false;
  }
}

void mouseReleased() {
  onPressed = false;
}

void mousePressedLZ() {
  onPressed = true;
  if (showInstruction) {
    background(255);
    showInstruction = false;
  }
}

void mouseReleasedLZ() {
  onPressed = false;
}
//******************************* BUBBLES **************************************************//


void mouseMovedLZ(){
      float x_coord  = map(com2d.x, 0, 640, 0, 1280);
      float y_coord = map(com2d.y, 0, 480, 0, 960);
  for (float j =/* mouseY*/ y_coord - ripple.riprad; j < /*mouseY*/ y_coord + ripple.riprad; j++) {
    for (float k = x_coord /*mouseX*/ - ripple.riprad; k < /*mouseX*/ x_coord + ripple.riprad; k++) {
      if (j >= 0 && j < height && k>= 0 && k < width) {
        ripple.ripplemap[(int)(ripple.oldind + (j * width) + k)] += 512;
      }
    }
  }  
}

void mouseMovedAutomaticLZ(){
  for (int j = 0 - ripple.riprad; j < 10 + ripple.riprad; j++) {
    for (int k = 0 - ripple.riprad; k < width + ripple.riprad; k++) {
      if (j >= 0 && j < 10 && k>= 0 && k < width) {
        ripple.ripplemap[ripple.oldind + (j * width) + k] += 10 *k;
      }
    }
  }  
     
  
  
  
}
