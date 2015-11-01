ColorDisplay colores;
PImage whiteBackground; 
ColorDisplay c2,c3;

void setup() {
  size(1024,768);
  frameRate(30);
  smooth();
  colorMode(HSB, 360, 100, 100);
  blendMode(ADD);
  colores = new ColorDisplay();
  whiteBackground = loadImage("white.png");
  colores.h = 0; 
  colores.s = 100; 
  colores.v = 100;
  
  //colores.display();
  
  c2 = new ColorDisplay();
  c2.h = 240;
  c2.s = 100;
  c2.v = 100;
  /*c2.display();*/
  
  c3 = new ColorDisplay();
  c3.h = 120;
  c3.s = 100;
  c3.v = 100;
  
  
};

void draw() {
  background(255,255,255);
  
  colores.display();
  c2.display();
  
  //c3.display();
}


void mousePressed() {  
   //Selecciona un color
   colores.buildColor();
  //pinta la pantalla 
   colores.display();
  
}

void keyPressed(){
    
     if (keyCode == UP) {
       //Aumenta la intensidad del color
       colores.s = (colores.s + 10) % 100;
     } else if (keyCode == DOWN) {
       //Disminuye la intensidad del color
       colores.s = (colores.s - 10) % 100;
     } else if (keyCode == LEFT) {
       colores.noDibujar();
     } else if (keyCode == RIGHT) {
       colores.siDibujar();
     }
     colores.display();
     
}

class ColorDisplay {
   
   float h;
   float s;
   float v;
   
   boolean dibujar;
   
   ColorDisplay() {
     this.h = 0;
     this.s = 100;
     this.v = 100;
     
     this.dibujar = true;
   } 
   
   void noDibujar() {
     this.dibujar = false;
   }
   
   void siDibujar() {
     this.dibujar = true;
   }
   void display(){
      if (this.dibujar){  
       tint(this.h,this.s,this.v,128);
       image(whiteBackground, 0, 0);
       println("color (h:s:v:) = ("+ this.h+":" + this.s+":"+this.v+")");
      }
   }
   
   void buildColor() {
     this.h =  random(360);
     this.v = random(100);
     println("color (h:s:v:) = ("+ this.h+":" + this.s+":"+this.v+")");
   }
 
};


