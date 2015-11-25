class Bed implements Scene{
  PImage bedImg;

  public Bed(){}

  void closeScene(){}

  void initialScene(){
    background(255,255,255);
    bedImg = loadImage("bed1.png");
    //bedImg.resize(3*width/4,0);
    bedImg.resize(0,height/2);
    image(bedImg,width/4+100,0);
  }

  void drawScene(){}

  String getSceneName(){return "Bed";};
}
