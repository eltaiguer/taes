import controlP5.*;
import java.awt.Frame;

ControlP5 cp5;

ControlFrame cf;

// para cambiar fluidamente entre las escenas
SceneManager manager;

boolean stopDraw = false;

void setup(){
  size(640,480);
  manager = new SceneManager();  
}

void draw(){
  if(!stopDraw) manager.actualScene.drawScene(); 
}
