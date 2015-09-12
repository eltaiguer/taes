class Bed implements Scene{
  PImage bedImg;

  public Bed(){}

  void closeScene(){}

  void initialScene(){
    bedImg = loadImage("bed1.png");
    bedImg.resize(width,0);
    image(bedImg,0,0);
  }

  void drawScene(){}

  String getSceneName(){return "Bed";};
}
