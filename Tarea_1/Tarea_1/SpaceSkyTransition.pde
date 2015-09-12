class SpaceSkyTransition implements Scene{
 
  int c=0;
  int count = 0;
  int size;
  
  public SpaceSkyTransition(){}
  
  void closeScene(){}
  void initialScene(){
    noStroke(); 
    size = height; 
  }
  
  void drawScene(){
    count++;
    rect(0,size,width,height);
    fill(48,139,206,c);
    if (count==10){
       c++;
       count=0;
    }
    size=size-2;    
  }
  
  String getSceneName(){return "SpaceSkyTransition";};
}
