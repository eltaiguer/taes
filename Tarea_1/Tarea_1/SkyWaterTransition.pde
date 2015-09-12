class SkyWaterTransition implements Scene{
  PImage sky;
  PImage cloud1,cloud2;

  int x1,y1;
  int x2,y2;

  int velocity;
  
  public SkyWaterTransition(){
    
    sky = createImage(width, height, RGB);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        sky.pixels[i + j * width] = lerpColor(#157ABC, #66B9F0, (float)j/height);
      }
    }

    velocity = 2;
    
    // -----------------------------------
    // Cloud1
    // -----------------------------------
    cloud1 = loadImage("cloud0.png");
    cloud1.resize(366,200);
    x1=0;
    y1=650;

    // -----------------------------------
    // Cloud2
    // -----------------------------------
    cloud2 = loadImage("cloud1.png");
    cloud2.resize(432,200);
    x2=400;
    y2=750;
  }
  
  void closeScene(){}

  void initialScene(){}
  
  void drawScene(){
    background(sky);
    drawClouds(false);
  }
  
  String getSceneName(){return "Sky";};

  void drawClouds(boolean dirH){
  
    y1 = y1 - velocity;
    image(cloud1, x1, y1);
    
    y2 = y2 - velocity;
    image(cloud2, x2, y2);
  }
}
