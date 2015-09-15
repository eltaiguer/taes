class SpaceSkyTransition implements Scene{

  int c;
  int count;
  int size;

  public SpaceSkyTransition(){}

  void closeScene(){}
  void initialScene(){
    noStroke();
    size = height;
    c=0;
    count=0;
  }

  void drawScene(){
    count++;
    fill(42,138,201,c);
    rect(0,size,width,height);

    if (count==5){
       c++;
       count=0;
    }
    size=size-5;
  }

  String getSceneName(){return "SpaceSkyTransition";};
}
