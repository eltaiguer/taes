class TaesColor {
  color col;
  PGraphics cg;
  float x,y;
  float step;
  
  TaesColor(float h, float s, float v, float x, float y, float step){
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
      this.cg.rect(0,0,width,height);
    this.cg.endDraw(); 
  }
}

