//Raven Kwok aka Guo, Ruiwen
//ravenkwok.com
//vimeo.com/ravenkwok
//flickr.com/photos/ravenkwok

class Particle{
  PVector loc, vel, acc;
  int lifeSpan, passedLife;
  boolean dead;
  float alpha, weight, weightRange, decay, xOffset, yOffset;
  color c;
  PImage img;

  Particle(float x, float y, float xOffset, float yOffset, PImage img){
    loc = new PVector(x,y);

    float randDegrees = random(360);
    vel = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    vel.mult(random(5));

    acc = new PVector(0,0);
    lifeSpan = int(random(30, 90));
    decay = random(0.75, 0.9);

    c = color(243,243,249,189);
    weightRange = random(3,50);

    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.img = img;
  }

  void update(){
    if(passedLife>=lifeSpan){
      dead = true;
    }else{
      passedLife++;
    }

    alpha = float(lifeSpan-passedLife)/lifeSpan * 70+50;
    weight = float(lifeSpan-passedLife)/lifeSpan * weightRange;

    acc.set(0,0);

    float rn = (noise((loc.x+frameCount+xOffset)*0.01, (loc.y+frameCount+yOffset)*0.01)-0.5)*4*PI;
    float mag = noise((loc.y+frameCount)*0.01, (loc.x+frameCount)*0.01);
    PVector dir = new PVector(cos(rn),sin(rn));
    acc.add(dir);
    acc.mult(mag);

    float randDegrees = random(360);
    PVector randV = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    randV.mult(0.5);
    acc.add(randV);

    vel.add(acc);
    vel.mult(decay);
    vel.limit(3);
    loc.add(vel);
  }

  void display(){
     image(this.img,loc.x,loc.y);
  }
}
