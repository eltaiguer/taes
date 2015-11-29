class SceneManager{

  Scene[] scenes;
  Scene actualScene;
  int actualSceneNr;
  boolean activate_moon;

  SceneManager(){

    Scene [] allScenes = {
      new Bed(),
      new BedSpaceTransition(),
      new Space(),
      new SpaceSkyTransition(),
      new Sky(),
      new SkyWaterTransition(),
      new Water(),
      new WaterBedTransition()
    };

    scenes = allScenes;
    actualSceneNr = 0;
    scenes[0].initialScene();
    actualScene = scenes[0];
    activate_moon = false;
  }

  void activateNextScene(){
    int sceneNr = (actualSceneNr+1)%(scenes.length);
    activate(sceneNr);
  }

  void activatePrevScene(){
    int sceneNr;
    if(actualSceneNr-1 < 0) sceneNr = scenes.length -1;
    else sceneNr = (actualSceneNr-1)%(scenes.length);
    activate(sceneNr);
  }

  void activate(int sceneNr){
    stopDraw = true;
    actualSceneNr = sceneNr;
    actualScene.closeScene();
    actualScene = scenes[sceneNr];
    actualScene.initialScene();
    println(sceneNr,actualScene.getSceneName());
    stopDraw = false;
  }

  void activateMoon() {
      activate_moon = !activate_moon;
      println("activate_moon: " + activate_moon);
  }
}

// Escena
interface Scene
{
    void initialScene();
    void drawScene();
    void closeScene();
    String getSceneName();
}

class Example implements Scene
{
  public Example(){};
  void closeScene(){};
  void initialScene(){};
  void drawScene(){};
  String getSceneName(){return "Example";};
}
