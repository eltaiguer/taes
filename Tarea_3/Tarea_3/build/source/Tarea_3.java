import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import themidibus.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Tarea_3 extends PApplet {


MidiBus myBus;
int cantKeys = 8;

final int W = 0;
final int A = 1;
final int S = 2;
final int D = 3;
final int F = 4;
final int G = 5;
final int SPACE = 6;
final int ARROW_UP = 7;
final int ARROW_RIGHT = 8;
final int ARROW_DOWN = 9;
final int ARROW_LEFT = 10;

boolean[] keyPress = new boolean [cantKeys];

int[] notes = {60, 62, 64, 65, 67, 69, 71, 72};

int channel = 0;
int velocity = 127;

public void setup() {


  for (int i=0; i<cantKeys; i++){
    keyPress[i] = false;
  }

  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  myBus = new MidiBus(this, 10, 12); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

}

public void draw() {
  println(PApplet.parseInt(map(mouseY, 0, height, -12, 12)));
  for (int i=0; i < cantKeys; i++){
    if (keyPress[i]){
      myBus.sendNoteOn(channel, notes[i], velocity); // Send a Midi noteOn
    }
  }

  delay(100);

  for (int i=0; i < cantKeys; i++){
    myBus.sendNoteOff(channel, notes[i], velocity);
  }


  //int pitch = 10;
  // int velocity = 127;
  // int pitch = int(map(mouseX, 0, width, 0, 127));
  //
  //
  // myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  // myBus.sendNoteOn(2, pitch, velocity);
  // println("on");
  // delay(100);
  // myBus.sendNoteOff(channel, pitch, velocity);
  // myBus.sendNoteOff(2, pitch, velocity); // Send a Midi nodeOff
  // println("off");

  //int number = 0;
  //int value = 90;

  //myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  //delay(2000);
}

public void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

public void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

public void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

public void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

public void keyPressed(){

  switch  (key) {
  case 97:  keyPress[W] = true;
            break;
  case 65:  keyPress[A] = true;
            break;
  case 83:  keyPress[S] = true;
            break;
  case 68:  keyPress[D] = true;
            break;
  case 70:  keyPress[F] = true;
            break;
  case 71:  keyPress[G] = true;
            break;
  case 32:  keyPress[SPACE] = true;
            break;
  case 38:  keyPress[ARROW_UP] = true;
            break;
  default:  println("PERO TE FUISTE DEL ARREI \u00d1ERY!!");
            break;
  }

}

public void keyReleased(){

  switch  (key) {
  case 97:  keyPress[W] = false;
            break;
  case 65:  keyPress[A] = false;
            break;
  case 83:  keyPress[S] = false;
            break;
  case 68:  keyPress[D] = false;
            break;
  case 70:  keyPress[F] = false;
            break;
  case 71:  keyPress[G] = false;
            break;
  case 32:  keyPress[SPACE] = false;
            break;
  case 38:  keyPress[ARROW_UP] = false;
            break;
  default:  println("PERO TE FUISTE DEL ARREI \u00d1ERY!!");
            break;
  }

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Tarea_3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
