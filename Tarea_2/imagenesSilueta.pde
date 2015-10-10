class imagenesSilueta {
    PImage[] imagenes;
    int index     = 0;
    int cant_imgs = 12;

    imagenesSilueta() {
        this.imagenes = new PImage[cant_imgs];
    }

    void addImagen(String path, int index) {
        this.imagenes[index] = loadImage(path);
    }
    void incrementImageIndex() {
        //Incremento y actualizo el index
        this.index = (this.index + 1) % cant_imgs;
    }
    void showCurrentImage() {
        //Dibujo la imagen del index
        PImage img = this.imagenes[this.index];
        image(img, 0, 0);
        this.incrementImageIndex();
    }
}
