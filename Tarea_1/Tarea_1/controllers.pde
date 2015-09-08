
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

/////////////// Escena 1 Cama /////////////////////////////////
    
    cp5.addBang("bang1")
      .setPosition(180, 10)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

/////////////// Transicion 1 Cama-Espacio /////////////////////////////////
    
    cp5.addBang("bang2")
      .setPosition(180, 60)
      .setSize(40, 20)
      .setLabel("Activar")
      ;    
    
  /////////////// Escena 2 Espacio /////////////////////////////////
    
    cp5.addBang("bang3")
      .setPosition(180, 110)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
      
  /////////////// Transicion 2 Espacio-agua /////////////////////////////////
    
    cp5.addBang("bang4")
      .setPosition(180, 160)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
  
  /////////////// Transicion 2 Espacio-agua /////////////////////////////////
    
    cp5.addBang("bang5")
      .setPosition(180, 210)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
  
  /////////////// Escena 3 Cielo /////////////////////////////////
    
    cp5.addBang("bang6")
      .setPosition(180, 260)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
  
  /////////////// Transicion 3 Cielo-Agua /////////////////////////////////
    
    cp5.addBang("bang7")
      .setPosition(180, 310)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
  
  /////////////// Escena 4 Agua /////////////////////////////////
    
    cp5.addBang("bang8")
      .setPosition(180, 360)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
  }

  void controlEvent(ControlEvent theEvent) {
    String n = theEvent.getName();

    // Escena 1 Cama
    if( n == "bang1") {
      manager.activate(0);
    }
    // Trancision 1 Cama-Espacio  
    if( n == "bang2") {
      manager.activate(1);
    }
    // Escena 2 Espacio
    if( n == "bang3") {
      manager.activate(2);
    }
    // Transicion 2 Espacio-Agua
    if( n == "bang4") {
      manager.activate(3);
    }
    // Escena 3 Agua
    if( n == "bang5") {
      manager.activate(4);
    }
    // Transición Agua-Cama
    if( n == "bang6") {
      manager.activate(5);
    }
    // Escena Cama final
    if( n == "bang7") {
      manager.activate(6);
    }
    
  }

  public void draw() {
    background(0);
    fill(255);
    text("Escena 1 - Cama",10,20);
    stroke(255,0,0);

    line(5,50,445,50);
    text("Transición Cama-Espacio",10,70);

    line(5,100,445,100);
    text("Escena 2 - Espacio",10,120);  

    line(5,150,445,150);
    text("Transición Espacio-Cielo",10,170);
  
    line(5,200,445,200);
    text("Escena 3 - Cielo",10,220);
     
    line(5,250,445,250);
    text("Transicion Cielo-Agua",10,270);
    
    line(5,300,445,300);
    text("Escena 4 - Agua",10,320);
    
    line(5,350,445,350);
    text("Transicion Agua-Cama",10,370);
  }

  private ControlFrame() {
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }
  public ControlP5 control() {
    return cp5;
  }
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
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

