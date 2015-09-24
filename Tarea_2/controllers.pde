public class ControlFrame extends PApplet {

    int w, h;
    ControlP5 cp5;
    Object parent;

    public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

    /////////////// Escena 1 Cama /////////////////////////////////

    cp5.addBang("bang1")
        .setPosition(180, 10)
        .setSize(40, 20)
        .setLabel("Grabar")
        ;

    /////////////// Transicion 1 Cama-Espacio /////////////////////////////////

    cp5.addBang("bang2")
        .setPosition(270, 10)
        .setSize(40, 20)
        .setLabel("Detener")
        ;

    }

    void controlEvent(ControlEvent theEvent) {
        String n = theEvent.getName();

        // Grabar
        if (n == "bang1") {
            do_record = true;
        }
        // Detener grabación
        if (n == "bang2") {
            do_record = false;
        }
    }

    public void draw() {
        background(0);
        fill(255);
        text("Grabación de movimiento",10,20);
        stroke(255,0,0);
        line(5,50,445,50);
    }

    private ControlFrame() {}

    public ControlFrame(Object theParent, int theWidth, int theHeight) {
        parent = theParent;
        w      = theWidth;
        h      = theHeight;
    }

    public ControlP5 control() {
        return cp5;
    }
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
    Frame f = new Frame(theName);
    ControlFrame p = new ControlFrame(this, theWidth, theHeight);
    f.add(p);
    p.init();
    f.setTitle(theName);
    f.setSize(p.w, p.h);
    f.setLocation(100, 100);
    f.setResizable(false);
    f.setVisible(true);
    return p;
}
