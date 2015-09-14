PImage candy0,candy1,candy2,candy3,candy4;

/*
 * Clase que implementa la escena del cielo.
 * Una nube acompaña el movimiento del bailarín mientras 
 * una lluvia de caramelos lo sofoca.
 */

class Sky implements Scene{

  // Imagenes para el cielo y las nubes
  PImage sky;
  PImage cloud1,cloud2;
  
  // Contenedores con fisica para los objetos de la escena
  // Permiten la interaccion entre el bailarin y los caramalos
  // y entre los caramelos y las nubes
  FBox cloudBox;
  FBox rightHandToRightShoulder,rightShoulderToLeftShoulder, leftShoulderToleftHand;

  public Sky(){
    // Se crea el background
    sky = createImage(width, height, RGB);
      for(int i = 0; i < width; i++){
        for(int j = 0; j < height; j++){
          sky.pixels[i + j * width] = lerpColor(#157ABC, #66B9F0, (float)j/height);
        }
      }

    // Se cargan las imagenes de las nubes
    cloud1 = loadImage("cloud0.png");
    cloud1.resize(400,300);

    // Se cargan los caramelos
    candy0 = loadImage("candy0.png");
    candy0.resize(60,60);

    candy1 = loadImage("candy1.png");
    candy1.resize(60,60);

    candy2 = loadImage("candy2.png");
    candy2.resize(60,60);

    candy3 = loadImage("candy3.png");
    candy3.resize(60,60);

    candy4 = loadImage("candy4.png");
    candy4.resize(60,60);

    // Se crea y configura un FBox para contener a la nube
    cloudBox = new FBox(200, 10);
    cloudBox.setPosition(400, 800);
    cloudBox.attachImage(cloud1);
    cloudBox.setStatic(true);
    world.add(cloudBox);

    // Se crean cuerpos con fisica para las manos y los hombres
    rightShoulderToLeftShoulder = new FBox(150, 10);
    rightShoulderToLeftShoulder.setStatic(true);
    rightShoulderToLeftShoulder.setDrawable(false);
    world.add(rightShoulderToLeftShoulder);

    rightHandToRightShoulder = new FBox(50, 10);
    rightHandToRightShoulder.setStatic(true);
    rightHandToRightShoulder.setDrawable(false);
    world.add(rightHandToRightShoulder);

    leftShoulderToleftHand = new FBox(50, 10);
    leftShoulderToleftHand.setStatic(true);
    leftShoulderToleftHand.setDrawable(false);
    world.add(leftShoulderToleftHand);
  }

  void closeScene(){}

  void initialScene(){}

  String getSceneName(){return "Sky";};

  void drawScene(){
    background(sky);

    updateCloudPosition();
    updateArmsPosition();

    world.step();
    world.draw();
  }

  // updateArmsPosition actualiza la posicion de los cuerpos con fisica
  // que modelan a los hombre y manos
  void updateArmsPosition(){
    
    if (!Float.isNaN(rightShoulder2d.y) && !Float.isNaN(com2d.x)){
      rightShoulderToLeftShoulder.setPosition(map(com2d.x, 0, kWidth, 0, width), map(rightShoulder2d.y, 0, kHeight, 0, height));
    }

    if (!Float.isNaN(rightHand2d.y) && !Float.isNaN(rightHand2d.x)){
      rightHandToRightShoulder.setPosition(map(rightHand2d.x, 0, kWidth, 0, width), map(rightHand2d.y, 0, kHeight, 0, height));
      rightHandToRightShoulder.adjustRotation(PVector.angleBetween(rightHand2d, rightShoulder2d));
    }

    if (!Float.isNaN(leftHand2d.y) && !Float.isNaN(leftHand2d.x)){
      leftShoulderToleftHand.setPosition(map(leftHand2d.x, 0, kWidth, 0, width), map(leftHand2d.y, 0, kHeight, 0, height));
    }
  }

  // Actualiza la posicion de la nube para que siga al bailarin
  void updateCloudPosition(){
    if (!Float.isNaN(com2d.x)){
      cloudBox.setPosition(map(com2d.x, 0, kWidth, 0, width), 800);
    }
  }
}

// Cada vez que se presiona la barra espaciadora se genera un caramelo 
// El mismo puede ser uno de 5 posibles y es contenido en un FCircle
void keyPressed() {
  if (key == ' '){
    FCircle myCircle = new FCircle(60);
    myCircle.setPosition(random(width), -30);
  
    int candySelector = (int)random(5);
  
    switch(candySelector){
      case 0:
        myCircle.attachImage(candy0);
        break;
      case 1:
        myCircle.attachImage(candy1);
        break;
      case 2:
        myCircle.attachImage(candy2);
        break;
      case 3:
        myCircle.attachImage(candy3);
        break;
      case 4:
        myCircle.attachImage(candy4);
        break;
    }
    world.add(myCircle);
  }
}
