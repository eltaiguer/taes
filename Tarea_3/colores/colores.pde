ColorDisplay colores;
PImage whiteBackground; 

void setup() {
  size(1024,768);
  frameRate(30);
  smooth();
  colorMode(HSB, 360, 360, 360);
  colores = new ColorDisplay();
  whiteBackground = loadImage("white.png");
  colores.display();
};

void draw() {
  // no se hace nada!
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
       colores.s = (colores.s + 10) % 360;
     } else if (keyCode == DOWN) {
       //Disminuye la intensidad del color
       colores.s = (colores.s - 10) % 360;
     }  
     colores.display();
     
}

class ColorDisplay {
   
   float h;
   float s;
   float v;
      
   ColorDisplay() {
     this.h = 0;
     this.s = 100;
     this.v = 100;
   } 
   
   void display(){
      image(whiteBackground, 0, 0);
      
       tint(this.h,this.s,this.v);
       image(whiteBackground, 0, 0);
        println("color (h:s:v:) = ("+ this.h+":" + this.s+":"+this.v+")");
   }
   
   void buildColor() {
     this.h =  random(360);
     this.v = random(360);
     println("color (h:s:v:) = ("+ this.h+":" + this.s+":"+this.v+")");
   }
 
};


