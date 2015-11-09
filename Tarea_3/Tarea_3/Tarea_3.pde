import SimpleOpenNI.*;

import themidibus.*;
MidiBus myBus;
int cantKeys = 10;

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

Note[] keyPress = new Note [cantKeys];
//             C   D   D#  E   F   F#  G   G#  A   B   C
int[] notes = {60, 62, 63, 64, 65, 66, 67, 68, 69, 71, 72};

//float[] colors = {0, 30, 60, 90, 120, 150, 240, 300, 360};

//                C     D     D#   E     F    F#  G   G#  A   B   C
float[] colors = {120, 180, 210, 240, 270, 300, 330, 0, 30, 90, 121};

int channel = 0;
int velocity = 127;

int bgColor = 360;

ArrayList<TaesColor> colorArray = new ArrayList<TaesColor>();

SimpleOpenNI context;

PVector rightHand   = new PVector();
PVector rightHand2d = new PVector();

PVector leftHand   = new PVector();
PVector leftHand2d = new PVector();

void setup() {
  
//  context = new SimpleOpenNI(this);
//  if(context.isInit() == false)
//  {
//     println("Can't init SimpleOpenNI, maybe the camera is not connected!");
//     exit();
//     return;
//  }
//
//  //---------------------------
//  // enable depthMap generation
//  context.enableDepth();
//
//  //--------------------------------------------
//  // enable skeleton generation for all joints
//  context.enableUser();
  
  size(400, 400);
  smooth();  
  colorMode(HSB, 360, 100, 100);
 
  colorArray.add(new TaesColor(0.0, 0.0, 0.0, 0,0, 5, 0));

  for (int i=0; i<cantKeys; i++){
    keyPress[i] = new Note(notes[i], colors[i]);    
  }

 
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  myBus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

}

int henderzweinOctavator(PVector leftHand, PVector rightHand){

//    float val = rightHand.y + leftHand.y;
//    println(val);
//    return int(map(val,0,960,5,-5));

    float val = abs(rightHand.y - leftHand.y);
    println(val);
    return int(map(val,0,240,5,-5));
}

void draw() {
  // context.update();
   
//    // Get right hand
//      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
//      context.convertRealWorldToProjective(rightHand, rightHand2d);
//
//      // Get left hand
//      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
//      context.convertRealWorldToProjective(leftHand, leftHand2d);
      
      
      //int octave = int(map(mouseY, 0, 800, 5, -5));
      int octave = 0;
   // int octave = henderzweinOctavator(leftHand2d, rightHand2d);
  //  println("octave : " + octave); 
   
   for (int i=0; i < cantKeys; i++){
     
     Note note = keyPress[i];
     //println("note "+ i +" state: "+ note.state);
      if (note.state == 1){

               
        note.state = 2;
        note.octave = octave*12;
        myBus.sendNoteOn(channel, note.basePitch + note.octave, velocity); // Send a Midi noteOn
         if (i==A){
        println("NoteON para " + note.basePitch + note.octave);
         }
        colorArray.add(new TaesColor(note.noteColor, 100, 50, 0, 0, 5, note.basePitch + note.octave));
        

        println("Tamano colorArray " + colorArray.size());
      }
      else if (note.state==0){
        
        note.state = -1;
        
        myBus.sendNoteOff(channel, note.basePitch + note.octave, velocity);
        if (i==A){
        println("NoteOFF para " + note.basePitch + note.octave);
        }
        
        if(colorArray.size()>1){
          for (int j=1; j<colorArray.size(); j++){
            
            // Una vez que se va a eliminar el color
            // Se setea en modo preparingToRemove
            // Así la función display de TaesColor remueve el brillo
            // del color hasta llegar a 0
            // en ese momento el color se remueve de la lista de colores para blendear
            if (colorArray.get(j).clave == note.basePitch + note.octave){
              println("preparing to remove");
              colorArray.get(j).preparingToRemove();
              
             //  if (colorArray.get(j).readyToRemove){
                println("remove");
                colorArray.remove(j);
             // }
              
            }
           
          }
        }    
      }
    }
   
   background(bgColor);
  
  TaesColor tc = colorArray.get(0); 
  for (int i = 0; i < colorArray.size(); i = i+1) {
    TaesColor tc_tmp = colorArray.get(i);
    tc_tmp.display();
    tc.blend(tc_tmp.getGraphics());
  }

  image(tc.getGraphics(),0,0); 
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void keyPressed(){
  
 // println(keyCode + " pressed");
  if ((keyCode == 87) && ((keyPress[W].state == 0) || (keyPress[W].state == -1))){
    keyPress[W].state = 1;
  }
  
  if ((keyCode == 65) && ((keyPress[A].state == 0) || (keyPress[A].state == -1))){
    keyPress[A].state = 1;
  }
  
  if ((keyCode == 83) && ((keyPress[S].state == 0) || (keyPress[S].state == -1))){
    keyPress[S].state = 1;
  }
  
  if ((keyCode == 68) && ((keyPress[D].state == 0) || (keyPress[D].state == -1))){
    keyPress[D].state = 1;
  }
  
  if ((keyCode == 70) && ((keyPress[F].state == 0) || (keyPress[F].state == -1))){
    keyPress[F].state = 1;
  }
  
  if ((keyCode == 71) && ((keyPress[G].state == 0) || (keyPress[G].state == -1))){
    keyPress[G].state = 1;
  }
  
  if ((keyCode == 32) && ((keyPress[SPACE].state == 0) || (keyPress[SPACE].state == -1))){
    keyPress[SPACE].state = 1;
  }
  
  if ((keyCode == 38) && ((keyPress[ARROW_UP].state == 0) || (keyPress[ARROW_UP].state == -1))){
    keyPress[ARROW_UP].state = 1;
  }

  if ((keyCode == 39) && ((keyPress[ARROW_RIGHT].state == 0) || (keyPress[ARROW_RIGHT].state == -1))){
    keyPress[ARROW_RIGHT].state = 1;
  }
  
  if ((keyCode == 40) && ((keyPress[ARROW_DOWN].state == 0) || (keyPress[ARROW_DOWN].state == -1))){
    keyPress[ARROW_DOWN].state = 1;
  }
  
  
  if (keyCode==89){  
    println("PERO TE FUISTE DEL ARREI ÑERY!!");          
  }

}

void keyReleased(){
  //println(keyCode + " released");
  switch  (keyCode) {
  case 87:  keyPress[W].state = 0;
            break;
  case 65:  keyPress[A].state = 0;
            break;
  case 83:  keyPress[S].state = 0;
            break;
  case 68:  keyPress[D].state = 0;
            break;
  case 70:  keyPress[F].state = 0;
            break;
  case 71:  keyPress[G].state = 0;
            break;
  case 32:  keyPress[SPACE].state = 0;
            break;
  case 38:  keyPress[ARROW_UP].state = 0;
            break;
  case 39:  keyPress[ARROW_RIGHT].state = 0;
            break;
  case 40:  keyPress[ARROW_DOWN].state = 0;
            break;
  default:  println("PERO TE FUISTE DEL ARREI ÑERY!!");
            break;
  }

}

void onNewUser(SimpleOpenNI curContext, int userId){
  println("onNewUser - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
}
