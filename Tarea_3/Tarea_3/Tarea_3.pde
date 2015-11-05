import themidibus.*;
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

Note[] keyPress = new Note [cantKeys];

int[] notes = {60, 62, 64, 65, 67, 69, 71, 72};
float[] colors = {0, 30, 60, 90, 120, 150, 240, 300};

int channel = 0;
int velocity = 127;

int bgColor = 360;

ArrayList<TaesColor> colorArray = new ArrayList<TaesColor>();

void setup() {
  size(400, 400);
  smooth();  
  colorMode(HSB, 360, 100, 100);
 
  colorArray.add(new TaesColor(0.0, 0.0, 0.0, 0,0, 5, 0));

  for (int i=0; i<cantKeys; i++){
    keyPress[i] = new Note(notes[i], colors[i]);    
  }

 
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  myBus = new MidiBus(this, 0, 0); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

}

void draw() {

   for (int i=0; i < cantKeys; i++){
     
     Note note = keyPress[i];
     //println("note "+ i +" state: "+ note.state);
      if (note.state == 1){

        int octave = int(map(mouseY, 0, height, 5, -5));          
        note.state = 2;
        note.octave = octave*12;
        myBus.sendNoteOn(channel, note.basePitch + note.octave, velocity); // Send a Midi noteOn
        
        println("NoteON para " + note.basePitch + note.octave);
        colorArray.add(new TaesColor(note.noteColor ,100 , 50, 0, 0, 5, note.basePitch + note.octave));
        

        println("Tamano colorArray " + colorArray.size());
      }
      else if (note.state==0){
        
        myBus.sendNoteOff(channel, note.basePitch + note.octave, velocity);
        println("NoteOFF para " + note.basePitch + note.octave);
        
        if(colorArray.size()>1){
          for (int j=1; j<colorArray.size(); j++){
            
            // Una vez que se va a eliminar el color
            // Se setea en modo preparingToRemove
            // Así la función display de TaesColor remueve el brillo
            // del color hasta llegar a 0
            // en ese momento el color se remueve de la lista de colores para blendear
            if (colorArray.get(j).clave == note.basePitch + note.octave){
              colorArray.get(j).preparingToRemove();
              if (colorArray.get(j).readyToRemove){
                colorArray.remove(j);
              }
            }
          }
        }
        
        //        if (colorArray.size()>i+1){
        //           println("coloroff: " + colors[i]);
        //           for(int christian = 0; christian < colorArray.size(); christian++){
        //             println("hue " + (hue(colorArray.get(christian).col)));
        //             println("notecolor " + note.noteColor);
        //             if (hue(colorArray.get(christian).col) == note.noteColor){
        //               colorArray.remove(christian);
        //               break;
        //             }    
        //           }           
        //        }
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
  if ((keyCode == 87) && (keyPress[W].state == 0)){
    keyPress[W].state = 1;
  }
  
  if ((keyCode == 65) && (keyPress[A].state == 0)){
    keyPress[A].state = 1;
  }
  
  if ((keyCode == 83) && (keyPress[S].state == 0)){
    keyPress[S].state = 1;
  }
  
  if ((keyCode == 68) && (keyPress[D].state == 0)){
    keyPress[D].state = 1;
  }
  
  if ((keyCode == 70) && (keyPress[F].state == 0)){
    keyPress[F].state = 1;
  }
  
  if ((keyCode == 71) && (keyPress[G].state == 0)){
    keyPress[G].state = 1;
  }
  
  if ((keyCode == 32) && (keyPress[SPACE].state == 0)){
    keyPress[SPACE].state = 1;
  }
  
  if ((keyCode == 38) && (keyPress[ARROW_UP].state == 0)){
    keyPress[ARROW_UP].state = 1;
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
  default:  println("PERO TE FUISTE DEL ARREI ÑERY!!");
            break;
  }

}
