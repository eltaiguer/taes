/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/157678*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
PGraphics pg1, pg2, pg3; 
color c1, c2, c3;
int bgColor = 360;
int counter = 0;

ArrayList<taesColor> colorArray = new ArrayList<taesColor>();

void setup() {
  size(300, 300); 
  noStroke(); 
  smooth(); 
  frameRate(200); 
  colorMode(HSB, 360, 100, 100);
 
  colorArray.add(new taesColor(0,100.0,100.0,0,0, 5));
}

void draw() {
  background(bgColor);
  
  taesColor tc = colorArray.get(0); 
  for (int i = 0; i < colorArray.size(); i = i+1) {
    taesColor tc_tmp = colorArray.get(i);
    tc_tmp.display();
    tc.blend(tc_tmp.getGraphics());
  }

  image(tc.getGraphics(),0,0);
}

void mouseReleased(){
  if (counter == 0){
    colorArray.add(new taesColor(0,100,100, 30, 0, 5));
  }else if (counter == 1){
    colorArray.add(new taesColor(240,100,100, 60, 0, 5));
  }else if (counter == 2){
    colorArray.add(new taesColor(120,100,100, 90, 0, 5));
  }
  counter++;
}

void keyReleased(){
  if(key == 'b' || key == 'B'){
    colorArray.remove(colorArray.size()-1);
    counter--;
  }
  
  if(keyCode == LEFT){
    taesColor c = colorArray.get(0);
    println("HUE", hue(c.col));
    println("SAT", saturation(c.col));
    println("VAL", brightness(c.col));
  }
  
  if(keyCode == UP){
    taesColor c = colorArray.get(3);
    c.col = color(hue(c.col), saturation(c.col), (brightness(c.col) < 100) ? brightness(c.col) + 10 : brightness(c.col));
  }
  
  if(keyCode == DOWN){
    taesColor c = colorArray.get(3);
    c.removeByBrightness();
  }
}

class taesColor {
  color col;
  PGraphics cg;
  float x,y;
  float step;
  
  taesColor(float h, float s, float v, float x, float y, float step){
    this.col = color(h, s, v);
    this.cg = createGraphics(width, height);
    this.x = x;
    this.y = y;
    this.step = step;
  }
  
  PGraphics getGraphics(){
    return this.cg;
  }
  
  void blend(PGraphics t){
    this.cg.blend(t, 0, 0, width, height, 0, 0, width, height, EXCLUSION); 
  }
  
  void removeByBrightness(){
    this.col = color(hue(this.col), saturation(this.col), (brightness(this.col) > this.step) ? brightness(this.col) - this.step : brightness(this.col));
  }
  
  void display(){
    this.cg.beginDraw(); 
      this.cg.background(0, 0);
      this.cg.noStroke();
      this.cg.smooth(); 
      this.cg.fill(this.col);
      this.cg.ellipse(this.x, this.y, 300-this.x, 300-this.y);
    this.cg.endDraw(); 
  }
}

