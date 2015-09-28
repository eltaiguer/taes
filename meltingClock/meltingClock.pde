

 
PImage bg;
PImage bgSinClock;
MeltingClock clock;
 

//************** particulas
Particle particles[]; // declare the array of Particles
int numParticles = 0; // this is a variable that holds the number of particles
PImage texture; // create the image object

//*************************
void setup() {
  size(1024,768);
   
 
  //*******dali
    bg = loadImage("stage1.png");
    bg.resize(1024,768);
    
    bgSinClock = loadImage("stage2.png");
    bgSinClock.resize(1024,768);
  
    clock = new MeltingClock();
    clock.imagen = loadImage("meltingClock.png");  
  //*******dali
  
  //****************particulas
  // load the smoke texture
  texture = loadImage("smoke.png");
  
  // create the array to hold 300 Particles (it is still just room -- no particles yet)
  particles = new Particle[300];
  
  //***********particulas
  
  smooth();
};

void draw() {
  if (clock.visible){
     image(bgSinClock, 0,0);
  } else {
     image(bg, 0,0);
  }
  clock.mostrar();
  println("mousex: " + mouseX);
  println("mousey: " + mouseY);
  
  
  
  //***************** particles
  if (clock.visible) {
    
           // If there is an empty spot in the array, we add a new particle to the system  
          if (numParticles < particles.length) {
            // create the Particle
            Particle p  = new Particle();
        
            // Give it an initial position 
            p.x = 428;
            p.y = 371; 
        
            // randomize its velocity and life time
            p.vx = random(-.25, .25);
            p.vy = -1 + random(-1, 1);
            p.maxLifeTime += random(-15, 15);
        
            // add it to the array and update our count of the number of particles
            particles[numParticles] = p;
            numParticles += 1;
          }
        
        
        
          // iterate over all of the particles and update and draw them
          // if they have expired, remove them from the list
          for (int i = 0; i < numParticles; i++) {
        
            // update the particle's position
            particles[i].update();
        
            // check if it is still alive
            if (particles[i].lifeTime < particles[i].maxLifeTime) {
              // if it is, paint it
              particles[i].paint();
            }
            else {
              // if it isn't, replace this particle with the last one in the list
              // and reduce the number of particles in the system
              numParticles -= 1;
              particles[i] = particles[numParticles];
            }
          }
  }
  
  //************** particles
};


void actualizarPosicionReloj(){
   if (clock.estado == "jointLeft"){  //El reloj recien lo agarre y lo tengo en la mano izquierda, que siga a la mano izquierda
      int jointLeftX = mouseX;
      int jointLeftY = mouseY;
      clock.x = jointLeftX; 
      clock.y = jointLeftY;
      int xCentroMasa = 0;
      int yCentroMasa = 0;
      boolean posicionEnCentroMasa = Math.abs(clock.x - xCentroMasa) >= 10  && Math.abs(clock.y - yCentroMasa) >= 10;
      if (posicionEnCentroMasa) { //Si lleve el reloj al centro de masa, proyecto el reloj en el centro de masa
         clock.estado = "centroMasa";
      }  
         
   } else if (clock.estado == "centroMasa"){  //Si tengo el reloj en el centro de masa
      int centroMasaX = mouseX;  
      int centroMasaY = mouseY; 
      clock.x = centroMasaX; 
      clock.y = centroMasaY;
      
      int xJointLeft = 0;
      int yJointLeft = 0;
      boolean posicionEnJointLeft = Math.abs(clock.x - xJointLeft) >= 10  && Math.abs(clock.y - yJointLeft) >= 10;
      if (posicionEnJointLeft) { //Si agarro el reloj del centro de masa con la mano izquierda , que siga a la mano izquierda
         clock.estado = "jointLeft";
      }   
   } 
   
}

//---------------------------
// Roba el reloj de la escena 
void robarRelojDeEscena() {
   int RelojY = 388; 
   int RelojX = 468;
   boolean posicionRobarClock = false;
   if (clock.estado == "jointLeft"){
      int jointLeftX = mouseX;
      int jointLeftY = mouseY;
      posicionRobarClock = Math.abs(RelojX - jointLeftX) >= 10  && Math.abs(jointLeftY - RelojY) >= 10;
   } else if (clock.estado == "centroMasa"){
      int centroMasaX = mouseX;
      int centroMasaY = mouseY; 
     posicionRobarClock = Math.abs(RelojX - centroMasaX) >= 10  && Math.abs(centroMasaY - RelojY) >= 10;
   }
   
   if (clock.habilitadoPorControlUI && posicionRobarClock) { 
      //Cambio fondo sin reloj
       //Le doy vida al reloj y lo muestro en las posicion de la mano izquierda hasta llegar al pecho   
       clock.visible = !clock.visible;
       actualizarPosicionReloj();
   }
}

void mousePressed() {  
   robarRelojDeEscena();
}

void mouseMoved(){    
   actualizarPosicionReloj();
}

class MeltingClock {
  boolean visible;
  String estado; // "jointLeft", "centroMasa"
  int x;
  int y;
  PImage imagen;
  boolean habilitadoPorControlUI; //Variable que hace que el reloj siga a la posicion del joint
   MeltingClock() {
     //Constructor
    this.visible = false;
    this.habilitadoPorControlUI = true;
    this.x = 100;
    this.x = 100;
    this.estado = "jointLeft";
  } 
  
  void mostrar() {
    if (this.visible) {
       this.latir();
    }    
  }
  
  void latir() {
      //Late una vez por segund0
      float x = millis()/250.0;
      float c01 = cos(2*x);
      float c02 = cos(1+5*x);
      float c03 = 1+((c01+c02)/6);
      
      float heartPulse = pow(c03,5.0);
      
      float heartH = map(heartPulse, 0, 3,  320,345);
      
      image(this.imagen, this.x, this.y, 279, heartH);
  }
};

class Particle {
  float x, y; // position of the particle
  float vx, vy; // velocity of the particle
  int lifeTime; // the age of the particle
  int maxLifeTime; // the age when the particle should be retired


  /**
   This is the constructor. We are just setting the lifetime here.
   **/
  Particle() {
    lifeTime = 0;
    maxLifeTime = 250;
   
  }

  /**
   Move the particle based on the velocity and increment the age of the particle.
   **/
  void update() {
    x += vx;
    y += vy; 

    lifeTime += 1;
  }

  /**
   Paint the particle. Note that the lifetime is used to determine the alpha 
   for the fill so that this gradually fades away rather than just popping out of
   existence.
   
 This time we are loading in a blurred circle for the particle to create the smoke effect.
   **/
  void paint() {
  
    float alpha = (1 - (float)lifeTime / maxLifeTime)* 150;
    //imageMode(CENTER);
    //tint(255,alpha);
    image(texture,x,y);
  }
}
  

