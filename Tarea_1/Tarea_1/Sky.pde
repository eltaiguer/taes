class Sky implements Scene{
  PImage sky;
  PImage cloud1,cloud2;
  PImage candy1,candy2,candy3,candy4,candy5;
  
  boolean clouds;

  int x1,y1;
  int x2,y2;
  
  int xc1,yc1,xc2,yc2,xc3,yc3,xc4,yc4,xc5,yc5;

  int velocity;
  
  public Sky(){
    
    sky = createImage(width, height, RGB);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        sky.pixels[i + j * width] = lerpColor(#157ABC, #66B9F0, (float)j/height);
      }
    }

    clouds = true;

    velocity = 1;
    
    // -----------------------------------
    // Candies
    // -----------------------------------
    candy1 = loadImage("candy1.png");
    xc1 = (int)random(100,300); yc1 = 0;
    candy1.resize(100,100);
    
    candy2 = loadImage("candy2.png");
    xc2 = (int)random(400,600); yc2 = 0;
    candy2.resize(100,100);
    
    candy3 = loadImage("candy3.png");
    xc3 = (int)random(300,500); yc3 = 0;
    candy3.resize(100,100);
    
    candy4 = loadImage("candy4.png");
    xc4 = (int)random(400,600); yc4 = 0;
    candy4.resize(100,100);
    
    candy5 = loadImage("candy5.png");
    xc5 = (int)random(200,300); yc5 = 0;
    candy5.resize(100,100);
    
    // -----------------------------------
    // Cloud1
    // -----------------------------------
    cloud1 = loadImage("cloud_1.png");
    cloud1.resize(366,200);

    x1=0;
    y1=650;

    // -----------------------------------
    // Cloud2
    // -----------------------------------

    cloud2 = loadImage("cloud_2.png");
    cloud2.resize(732,400);
    x2=400;
    y2=960;
  }
  
  void closeScene(){}

  void initialScene(){}
  
  void drawScene(){
    background(sky);
    drawClouds(false);
  }
  
  String getSceneName(){return "Sky";};

  void drawClouds(boolean dirH){
    /*if(clouds && dirH){
      x1 = x1 + velocity;
      image(cloud1, x1, y1);
      
      x2 = x2 - velocity;
      image(cloud2, x2, y2);
    }else if(clouds){
      y1 = y1 - velocity;
      image(cloud1, x1, y1);
      
      y2 = y2 - velocity;
      image(cloud2, x2, y2);
    }*/
    
    image(cloud2, com2d.x*2-250, 730);
    
    // Candies
    yc1 = yc1 + 10;
    image(candy1, xc1, yc1);
    
    if(yc1 > 600){
      yc2 = yc2 + 10;
      image(candy2, xc2, yc2);
    }
    
    if(yc2 > 800){
      yc3 = yc3 + 10;
      image(candy3, xc3, yc3);
    }
    
    if(yc3 > 900){
      yc4 = yc4 + 10;
      image(candy4, xc4, yc4);
    }
    
    if(yc4 > 900){
      yc5 = yc5 + 20;
      image(candy5, xc5, yc5);
    }
  }

  void skyMouseReleased(){
    if ((mouseX > x1) && (mouseX < (x1+cloud1.width)) && (mouseY > y1) && (mouseY < (y1+cloud1.height))){
      println("Click on cloud1");
    }
    if ((mouseX > x2) && (mouseX < (x2+cloud2.width)) && (mouseY > y2) && (mouseY < (y2+cloud2.height))){
      println("Click on cloud2");
    }
  }

  void skyKeyPressed() {
    if (key == 'v') {
      velocity = velocity+1;
    } else if (key == 'b'){
      velocity = velocity-1;
    }
  }
}
