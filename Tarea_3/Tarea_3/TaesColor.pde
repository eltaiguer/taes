class TaesColor {
  color col;
  PGraphics cg;
  float x,y;
  float step;
  int clave;
  boolean removing = false;
  boolean readyToRemove = false;
  
  TaesColor(float h, float s, float v, float x, float y, float step, int clave){
    this.col = color(h, s, v);
    this.cg = createGraphics(width, height);
    this.x = x;
    this.y = y;
    this.step = step;
    this.clave = clave;
    this.removing = false;
    this.readyToRemove = false;
  }
  
  PGraphics getGraphics(){
    return this.cg;
  }
  
  void preparingToRemove(){
    this.removing = true;
  }
  
  void blend(PGraphics t){
    this.cg.blend(t, 0, 0, width, height, 0, 0, width, height, EXCLUSION); 
  }
  
  void display(){
    
    float bright = brightness(this.col);
    
    if (removing){
      this.col = color(hue(this.col), saturation(this.col), bright > 0 ? bright-1 : bright);
      if (bright <= 0){
        this.readyToRemove = true;
      }
    }else{
      this.col = color(hue(this.col), saturation(this.col), bright < 100 ? bright+1 : bright);
    }
    
    this.cg.beginDraw(); 
      this.cg.background(0, 0);
      this.cg.noStroke();
      this.cg.smooth(); 
      this.cg.fill(this.col);
      this.cg.rect(0,0,width,height);
    this.cg.endDraw(); 
  }
}

