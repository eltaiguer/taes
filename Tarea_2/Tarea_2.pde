import controlP5.*;
import java.awt.Frame;
import SimpleOpenNI.*;
import java.io.*;

ControlP5 cp5;
ControlFrame cf;
SimpleOpenNI context;

boolean recordFlag = true;
String recordPath  = "test.oni";
PImage realImage;
PImage image;

//variables de grabacion de movimiento
boolean recording = false;
boolean do_record = false;

void setup() {
    size(1280, 960);
    frameRate(30);

    cf = addControlFrame("Controladores", 450, 700);

    // para imagen escalada
    image = new PImage(width,height,ARGB);

    if (recordFlag == false) {
       context = new SimpleOpenNI(this,recordPath);
       context.enableDepth();
       context.enableRGB();
       println("curFramePlayer: " + context.curFramePlayer());
    }

    //smooth();
}

void draw() {
    //grabo
    if (do_record) {
        if (!recording) {
            println("Comienza grabación");
            recording = true;

            //si ya existe un archivo lo elimino
            File file = new File(sketchPath("data/"+recordPath));
            if (file.delete())
                println("Archivo borrado.");
            else
                println("No existe archivo.");

            //inicializo grabacion
            context = new SimpleOpenNI(this);
            if(context.isInit() == false){
                println("Can't init SimpleOpenNI, maybe the camera is not connected!");
                exit();
                return;
            }

            // recording
            // enable depthMap generation
            context.enableDepth();

            // setup the recording
            context.enableRecorder(recordPath);

            // select the recording channels
            context.addNodeToRecording(SimpleOpenNI.NODE_DEPTH,true);
            context.addNodeToRecording(SimpleOpenNI.NODE_IMAGE,true);
        }

        context.update();

        background(0, 0, 0);

        if ((context.nodes() & SimpleOpenNI.NODE_DEPTH) != 0) {
            if ((context.nodes() & SimpleOpenNI.NODE_IMAGE) != 0) {
                image(context.depthImage(), 0, 0);
                image(context.rgbImage(), context.depthWidth() + 10, 0);
            } else {
                image(context.depthImage(), 0, 0);
            }
        }

        // draw timeline
       // if(recordFlag == false){
          int[] dmap = context.depthMap();
          int size = context.depthMapSize();
          int count = 0;

          realImage = createImage(context.depthWidth(), context.depthHeight(), RGB);
            for(int i = 0; i < context.depthWidth(); i++){
              for(int j = 0; j < context.depthHeight(); j++){

                int index = i + j * context.depthWidth();
                int d = dmap[index];

                if (d < 2000){

                  if (index + 1 < size && dmap[index + 1] < 2000){
                    count++;
                  }

                  if (index - 1 >= 0 && dmap[index -1] < 2000){
                    count++;
                  }

                  if ((index + context.depthWidth() < size) && (dmap[index + context.depthWidth()] < 2000)){
                     count++;
                  }

                  if ((index - context.depthWidth() >= 0) && (dmap[index - context.depthWidth()] < 2000)){
                    count++;
                  }

                  if (count < 4){
                    realImage.pixels[index] = color(255, 0, 0);
                  }else{
                    realImage.pixels[index] = color(0, 100, 0);
                  }

                }else{
                  realImage.pixels[index] = color(0, 0, 0);
                }
                count = 0;
              }
          }

          realImage.updatePixels();
          image.loadPixels();
          // escalamos las imagenes
          image.copy(realImage, 0, 0, 640, 480, 0, 0, width, height);
          image(image,0,0);
          drawTimeline();
          text("curFramePlayer: " + context.curFramePlayer(),10,10);
         // }

    }

    //paro grabacion
    if (recording && !do_record) {
        println("Grabación detenida");
        recording = false;
    }
}

void drawTimeline() {
    pushStyle();

    stroke(255,255,0);
    line(10, height - 20, width -10 , height - 20);

    stroke(0);
    rectMode(CENTER);
    fill(255,255,0);

    int pos = (int)((width - 2 * 10) * (float)context.curFramePlayer() / (float)context.framesPlayer());
    rect(pos, height - 20, 7, 17);

    popStyle();
}
