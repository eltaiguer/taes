public class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  void collide() {
    for (int j = id + 1; j < numBalls; j++) {
      float dx = mouseX/*others[j].x*/ - x;
      float dy = mouseY/*others[j].y*/ - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = /*others[j].diameter/2 +*/ diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - mouseX/*others[j].x*/) * spring;
        float ay = (targetY - mouseY/*others[j].y*/) * spring;
        vx -= ax;
        vy -= ay;
        if (j < others.length){
          others[j].vx += ax;
          others[j].vy += ay;
        }
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    fill(#4395CB,100);
    ellipse(x, y, diameter, diameter);
   
  }
}
