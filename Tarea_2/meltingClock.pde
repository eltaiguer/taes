class MeltingClock {
    boolean visible;  // indica si se muestra o no se muestra el reloj
    String estado;  // intial, en mano izquierda, en centro de masa, pre_final, final
    float x; // posicion x del reloj
    float y; // posicion y del reloj
    PImage imagen; // imagen a mostrar
    boolean allow_release; //Variable que hace que el reloj siga a la mano izquierda, a controlar por UI

    MeltingClock() {
        this.visible       = false;
        this.allow_release = false;
        this.x             = RELOJ_INITIAL_X;
        this.y             = RELOJ_INITIAL_Y;
        this.estado        = INITIAL;
    }

    void mostrar() {
        if (this.visible) {
            this.latir();
        }
    }

    void latir() {
        //Late una vez por segundo
        float x          = millis()/250.0;
        float c01        = cos(2*x);
        float c02        = cos(1+5*x);
        float c03        = 1+((c01+c02)/6);
        float heartPulse = pow(c03,5.0);
        float heartH     = map(heartPulse, 0, 3,  320,345);

        image(this.imagen, this.x, this.y, 139, heartH/2);
    }
};
