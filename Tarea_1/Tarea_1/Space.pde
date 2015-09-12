class Space implements Scene{
  //fondo estrellas
  int cant_stars = 2000;
  ArrayList<PVector> stars = new ArrayList();
  PVector direction;
  float speed;
  float forceStrength;
  Comet comet;

  //luna
  PImage img;
  boolean moon_is_moving = false;
  int moon_width         = 225;
  int moon_height        = 225;
  int moon_x             = 700;
  int moon_y             = 150;
  FWorld fworld;
  FCircle fmoon;
  FCircle f_rigth_hand;
  FCircle f_left_hand;

  public Space() {}

  void closeScene() {}

  void initialScene(){

    //fondo
    for (int i = 0; i < 2000; i++) {
      PVector P = new PVector(random(2 * width), random(2 * height));
      stars.add(P);
    }
    smooth();

    //cometa
    comet         = new Comet(random(width), random(height));
    speed         = 7;
    float angle   = random(TWO_PI);
    direction     = new PVector(cos(angle), sin(angle));
    forceStrength = 0.2;

    //luna
    img = loadImage("moon.png");
    img.resize(moon_width, moon_height);

    fworld  = new FWorld();
    fworld.setGravity(0,75);
    fmoon = new FCircle(225);
    fmoon.attachImage(img);
    fmoon.setPosition(moon_x, moon_y);
    fmoon.setStatic(true);
    fworld.add(fmoon);

    //manos
    f_rigth_hand = new FCircle(75);
    f_left_hand  = new FCircle(95);

    f_rigth_hand.setDrawable(true);
    f_left_hand.setDrawable(true);

    fworld.add(f_rigth_hand);
    fworld.add(f_left_hand);
  }

  void drawScene() {
    //fondo
    background(#040e2a);
    noStroke();
    fill(-1);
    for (int i = 0; i < stars.size(); i++) {
      PVector P = stars.get(i);
      PVector M;
      if (!Float.isNaN(com2d.x) && !Float.isNaN(com2d.y)) {
        M = new PVector(com2dP.x - com2d.x, com2dP.y - com2d.y);
      } else {
        M = new PVector(0, 0);
      }
      P.add(M);
      float d = dist(P.x, P.y, width/2, height/2);
      d       = map(d, 0, width/2, 0, 3);
      ellipse(P.x, P.y, d, d);
    }

    //manos
    if (!Float.isNaN(rightHand2d.x) && !Float.isNaN(rightHand2d.y)) {
      f_rigth_hand.setPosition(rightHand2d.x, rightHand2d.y);
      f_left_hand.setPosition(leftHand2d.x, leftHand2d.y);
    } else {
      f_rigth_hand.setPosition(width/2, height/2);
      f_left_hand.setPosition(width/2, height/2);
    }

    //contacto luna-manos
    if (f_rigth_hand.isTouchingBody(fmoon) || f_left_hand.isTouchingBody(fmoon)) {
      if (moon_is_moving) {
        fmoon.setStatic(true);
      } else {
        fmoon.setStatic(false);
      }
    }

    //cometa
    move();
    if (!Float.isNaN(com2d.x) && !Float.isNaN(com2d.y)) {
      steer(com2d.x, com2d.y);
    } else {
      steer(width/2, height/2);
    }
    comet.display();

    //luna
    fworld.step();
    fworld.draw();
  }

  class Comet
  {
    PVector[] location;
    float ellipseSize;

    color c1;
    color c2;

    Comet(float x, float y)
    {
      location    = new PVector[round(random(15, 25))];
      location[0] = new PVector(x, y);

      for (int i = 1; i < location.length; i++)
      {
        location[i] = location[0].get();
      }
      ellipseSize = random(6, 40);
      c1 = #ffedbc;
      c2 = #A75265;
    }

    PVector getHead()
    {
      return location[location.length-1].get();
    }

    void setHead(PVector pos)
    {
      location[location.length-1] = pos.get();

      updateBody();
    }

    void updateBody()
    {
      for (int i=0; i < location.length-1; i++)
      {
        location[i] = location[i+1];
      }
    }

    void display ()
    {
      noStroke();
      for (int i = 0; i < location.length; i++)
      {
        color c = lerpColor(c1, c2, map(i, 0, location.length, 1, 0));
        float s = map(i, 0, location.length, 1, ellipseSize);

        fill(c);
        ellipse(location[i].x, location[i].y, s, s);
      }
    }
  }

  void steer(float x, float y)
  {
    PVector location = comet.getHead();

    float angle = atan2(y - location.y, x - location.x);

    PVector force = new PVector(cos(angle), sin(angle));
    force.mult(forceStrength);

    direction.add(force);
    direction.normalize();
  }

  void move()
  {
    PVector location = comet.getHead();
    PVector velocity = direction.get();
    velocity.mult (speed);
    location.add (velocity);
    comet.setHead (location);
  }

  String getSceneName(){return "Space";};
}
