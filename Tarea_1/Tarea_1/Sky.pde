PImage candy0,candy1,candy2,candy3,candy4;

class Sky implements Scene{

  PImage sky;
  PImage cloud1,cloud2;
  FBox cloudBox;
  FBox rightHandToRightShoulder,rightShoulderToLeftShoulder, leftShoulderToleftHand;

  public Sky(){
    // Create background image
    sky = createImage(width, height, RGB);
      for(int i = 0; i < width; i++){
        for(int j = 0; j < height; j++){
          sky.pixels[i + j * width] = lerpColor(#157ABC, #66B9F0, (float)j/height);
        }
      }

    // Cloud images
    cloud1 = loadImage("cloud0.png");
    cloud1.resize(400,300);

    // Candy images
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

    // fisica cloud's box
    cloudBox = new FBox(200, 10);
    cloudBox.setPosition(400, 600);
    cloudBox.attachImage(cloud1);
    cloudBox.setStatic(true);
    world.add(cloudBox);
  }

  void closeScene(){}

  void initialScene(){}

  String getSceneName(){return "Sky";};

  void drawScene(){
    background(sky);
    updateCloudPosition();
    world.step();
    world.draw();
  }

  void updateArmsPosition(){
    /*rightHandToRightShoulder.adjustPosition(rightHand2d.x,rightHand2d.y);
    rightHandToRightShoulder.setWidth(dist(rightHand2d.x,rightHand2d.y, rightShoulder2d.x, rightShoulder2d.y));
    rightHandToRightShoulder.adjustRotation(PVector.angleBetween(rightHand2d, rightShoulder2d));

    rightShoulderToLeftShoulder.adjustPosition(rightShoulder2d.x, rightShoulder2d.y);
    rightShoulderToLeftShoulder.setWidth(dist(rightShoulder2d.x,rightShoulder2d.y,leftShoulder2d.x,leftShoulder2d.y));
    rightShoulderToLeftShoulder.adjustRotation(PVector.angleBetween(rightShoulder2d, leftShoulder2d));

    leftShoulderToleftHand.adjustPosition(leftShoulder2d.x,leftShoulder2d.y);
    leftShoulderToleftHand.setWidth(dist(leftShoulder2d.x,leftShoulder2d.y,leftHand2d.x,leftHand2d.y));
    leftShoulderToleftHand.adjustRotation(PVector.angleBetween(leftShoulder2d, leftHand2d));*/
  }

  void updateCloudPosition(){
    cloudBox.adjustPosition(mouseX,800);
  }
}

void mousePressed() {
  // Creates a new circle to wrap the candy image
  FCircle myCircle = new FCircle(60);
  myCircle.setPosition(mouseX, mouseY);

  // Creates and add a new candy
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

  // Add candy to the world
  world.add(myCircle);
}
