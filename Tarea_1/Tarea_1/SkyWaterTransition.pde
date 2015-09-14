/*
 * Clase que implementa la transicion entre el cielo y el mar
 * Un conjunto de nubes aleatoriamente posicionadas se mueven hacia arriba
 * mientras un efecto tipo fadeOut.
 */

class SkyWaterTransition implements Scene{
  PImage sky, transition, water;
  PImage cloud0, cloud1, cloud2, cloud3, cloud4;

  int x0,y0;
  int x1,y1;
  int x2,y2;
  int x3,y3;
  int x4,y4;

  int transparency1;
  int transparency2;

  public SkyWaterTransition(){

    transparency1 = 254;
    transparency2 = 0;

    sky = createImage(width, height, RGB);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        sky.pixels[i + j * width] = lerpColor(#157ABC, #66B9F0, (float)j/height);
      }
    }

    transition = createImage(width, height, RGB);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        sky.pixels[i + j * width] = lerpColor(#157ABC, #E0F1FC, (float)j/height);
      }
    }

    // Carga y configuracion de nubes
    cloud0 = loadImage("cloud0.png");
    cloud0.resize(432,200);
    x0=(int)random(0,800); y0=height+200;

    cloud1 = loadImage("cloud1.png");
    cloud1.resize(366,200);
    x1=(int)random(0,800); y1=height+200;

    cloud2 = loadImage("cloud2.png");
    cloud2.resize(432,200);
    x2=(int)random(0,800); y2=height+200;

    cloud3 = loadImage("cloud3.png");
    cloud3.resize(432,200);
    x3=(int)random(0,800); y3=height+200;

    cloud4 = loadImage("cloud4.png");
    cloud4.resize(432,200);
    x4=(int)random(0,800); y4=height+200;

    // Carga y adpatacion de imagen de fondo de la escena Water
    water = loadImage("data/ocean1.jpg");
    water.resize(width,height);
  }

  void closeScene(){}

  void initialScene(){}

  void drawScene(){
    background(sky);
    drawClouds();
  }

  String getSceneName(){return "Sky";};

  // Implementacion del efecto fadeOut mientras una serie
  // de nubes se mueven hacia arriba.
  // Para el fadeOut se utilizo tint.
  void drawClouds(){  
    tint(255,255,255,transparency1);
    image(sky, 0, 0);

    y0 = y0 - 10;
    image(cloud0, x0,y0 );

    if(y0 > 300){
      y1 = y1 - 10;
      image(cloud1, x1, y1 );
    }

    if(y0 > 300){
      y2 = y2 - 10;
      image(cloud2, x2,y2 );
    }

    if(y1 > 300){
      y3 = y3 - 10;
      image(cloud3, x3, y3 );
    }

    if (y3 > 300){
      y4 = y4 - 10;
      image(cloud0, x4,y4 );
    }

    if(transparency1 > 0){
      transparency1 = transparency1 -2;
    }

    tint(255,255,255,254-transparency1);
    image(transition, 0, 0);

    tint(255,255,255,transparency2);
    image(water, 0, 0);
    if((transparency1 == 0) && (transparency2 < 254)){
      transparency2 = transparency2 + 2;
    }
  }
}
