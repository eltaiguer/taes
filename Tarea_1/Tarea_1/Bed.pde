class Bed implements Scene{
  PImage bedImg;

  public Bed(){}

  void closeScene(){}

  void initialScene(){
    bedImg = loadImage("bed1.png");
    bedImg.resize(1280,0);
  }

  void drawScene(){
    image(bedImg,0,0);
  }

  String getSceneName(){return "Bed";};
}
