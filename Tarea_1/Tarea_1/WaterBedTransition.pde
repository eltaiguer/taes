class WaterBedTransition implements Scene{

  int count;
  int currentHeight;
  boolean open;
  int cycle;
  int maxCycles;
  PImage bedImg;
  int alfa;

  public WaterBedTransition(){}

  void closeScene(){}

  void initialScene(){
    noStroke();
    count = 0;
    alfa = 0;
    currentHeight = height/2;
    open = false;
    cycle = 0;
    maxCycles = 3;
    bedImg = loadImage("bed1.png");
    bedImg.resize(width,0);
  }

  void drawScene(){
    if (alfa < 20){
    fill(0,0,0,alfa);
    rect(0,0,width,height);
    if (count == 5){
       alfa++;
       count = 0;
    }
    count++;
    }else{
      if (cycle < maxCycles){
        if (currentHeight == height/2){
          open = true;
          cycle++;
        }else if (currentHeight == height/4){
          open = false;
        }

        if (!open){
          currentHeight++;
        }else{
          image(bedImg,0,0);
          currentHeight--;
        }
        
        fill(0,0,0);
        rect(0,0,width,currentHeight);
        fill(0,0,0);
        rect(0,height - currentHeight,width,height);
      }
      else{
        if (currentHeight >= 0){
          println(currentHeight);
          image(bedImg,0,0);
          fill(0,0,0);
          rect(0,0,width,currentHeight);
          fill(0,0,0);
          rect(0,height - currentHeight,width,height);
          currentHeight--;
        }
      }
    }
  }

  String getSceneName(){return "WaterBedTransition";};
}
