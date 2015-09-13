class SkyWaterTransition implements Scene{
  PImage sky, transition, water;
  PImage cloud0, cloud1, cloud2, cloud3, cloud4;

  int x0,y0;
  int x1,y1;
  int x2,y2;
  int x3,y3;
  int x4,y4;

  int velocity;
  
  int transparency1;
  int transparency2;
  int transparency3;
  
  public SkyWaterTransition(){
    
    transparency1 = 255;
    transparency2 = 0;
    transparency3 = 0;
    
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

    velocity = 2;
    
    cloud0 = loadImage("cloud0.png");
    cloud0.resize(432,200);
    x0=(int)random(0,width); y0=height+200;
    
    cloud1 = loadImage("cloud1.png");
    cloud1.resize(366,200);
    x1=(int)random(0,width); y1=height+200;

    cloud2 = loadImage("cloud2.png");
    cloud2.resize(432,200);
    x2=(int)random(0,width); y2=height+200;
    
    cloud3 = loadImage("cloud3.png");
    cloud3.resize(432,200);
    x3=(int)random(0,width); y3=height+200;
    
    cloud4 = loadImage("cloud4.png");
    cloud4.resize(432,200);
    x4=(int)random(0,width); y4=height+200;
    
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

  void drawClouds(){    
    tint(255,255,255,transparency1);
    image(sky, 0, 0);
    if(transparency1 > 0){
      transparency1--;
    }
    
    tint(255,255,255,255-transparency1);
    image(transition, 0, 0);
    
    tint(255,255,255,transparency2);
    image(water, 0, 0);
    if((transparency1 == 0) && (transparency2 < 255)){
      transparency2++;
    }
  }
}
