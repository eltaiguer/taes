ColorDisplay colores;
PImage whiteBackground; 
ColorDisplay c2,c3;

void setup() {
  size(1024,768);
  frameRate(30);
 // smooth();
  //colorMode(HSB, 360, 100, 100);
  colorMode(RGB,255,255,255);
  blendMode(ADD);
 
  whiteBackground = loadImage("white.png");
  
  colores = new ColorDisplay("rojo", 255, 0, 0 ,128);
  c2 = new ColorDisplay("azul",0,0,255,128);
  c3 = new ColorDisplay("verde",0,255,0,128);
 
  
};

void draw() {
  //noTint();
  //image(whiteBackground, 0, 0);
 // background(255);
  colores.display();
  c2.display();  
 // c3.display();
 
}


void mousePressed() {  
   //Selecciona un color
   //colores.buildColor();
  //pinta la pantalla 
  // colores.display();
  
}

void keyPressed(){
    if (keyCode == LEFT) {
       colores.noDibujar();
     //  c2.noDibujar();
      // c3.noDibujar();
     } else if (keyCode == RIGHT) {
       colores.siDibujar();
       //c2.siDibujar();
       //c3.siDibujar();
     }
     
     
}

class ColorDisplay {
   
   float r;
   float g;
   float b;
   float alpha;
   boolean dibujar;
   String nombre;
   boolean aumentarAlpha;
   boolean disminuirAlpha;
   ColorDisplay(String nombre,float r,float g,float b, float alpha) {
     this.r = r;
     this.g = g;
     this.b = b;
     this.alpha = alpha;
     this.nombre = nombre;    
     this.dibujar = true;
     this.aumentarAlpha = false;
     this.disminuirAlpha = false;
   } 
   
   void noDibujar() {
     this.dibujar = false;
     this.aumentarAlpha = false;
     this.disminuirAlpha = true;
   }
   
   void siDibujar() {
     this.dibujar = true;
     aumentarAlpha = true;
     disminuirAlpha = false;
   }
   
   void display(){
       if (this.aumentarAlpha){
         this.alpha = (this.alpha + 1) % 128;
       } else if (this.disminuirAlpha && this.alpha > 0){
           this.alpha--;
       }
       
      if (!this.dibujar && this.alpha > 0) {  
         this.alpha=  this.alpha-1; // Disminuyo el brightness hasta desaparecer         
         tint(this.r,this.g,this.b,this.alpha);
         image(whiteBackground, 0, 0);
         println("color (h:s:v:) = ("+ this.r+":" + this.g+":"+this.b +") " + this.nombre);
      } else if (this.alpha > 0) {       
         tint(this.r,this.g,this.b,this.alpha);
         image(whiteBackground, 0, 0);
         println("color (h:s:v:) = ("+ this.r+":" + this.g+":"+this.b +") " + this.nombre);
      }
      
   }
   
   /*void buildColor() {
     this.h =  random(360);
     this.v = random(100);
     println("color (h:s:v:) = ("+ this.h+":" + this.s+":"+this.v+")");
   }*/
 
};


