import controlP5.*;
import java.awt.Frame;

ControlP5 cp5;

ControlFrame cf;

SceneManager manager;

boolean stopDraw = false;

void setup(){
  size(640,480);
  cf = addControlFrame("Controladores", 450,700);
  manager = new SceneManager(); 
}

void draw(){
  if(!stopDraw) manager.actualScene.drawScene();   
}
