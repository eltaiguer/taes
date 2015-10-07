class imagenesSilueta{
 PImage[] imagenes;
  int index = 0;
  imagenesSilueta(){
    this.imagenes = new PImage[4];
  } 
  
  void addImagen(String path,int index){
    this.imagenes[index] = loadImage(path);
  }  
  void incrementImageIndex(){
    //Incremento y actualizo el index
    this.index = (this.index + 1) % 4;
  }
  
  void showNextImage(){
    //Dibujo la imagen del index
    PImage img = this.imagenes[this.index];
    image(img, 0, 0);        
  }
}
