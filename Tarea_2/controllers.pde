public class ControlFrame extends PApplet {

    int w, h;
    ControlP5 cp5;
    Object parent;

    public void setup() {
    size(w, h);
    frameRate(25);

    cp5 = new ControlP5(this);
    cp5.addBang("bang1")
        .setPosition(10, 120)
        .setSize(40, 20)
        .setLabel("Iniciar escena");

    cp5.addBang("bang2")
        .setPosition(100, 120)
        .setSize(40, 20)
        .setLabel("Finalizar escena");

    cp5.addSlider("bang3")
      .plugTo(parent,"calib_dist")
      .setRange(1, 5000)
      .setPosition(10, 40)
      .setSize(300, 10)
      .setValue(3000)
      .setLabel("");

    }

    void controlEvent(ControlEvent theEvent) {
        String n = theEvent.getName();

        // Grabar
        if (n == "bang1") {
            grab_clock = true;
        }
        // Detener grabación
        if (n == "bang2") {
            clock.habilitadoPorControlUI = !clock.habilitadoPorControlUI;
        }
    }

    public void draw() {
        background(0);
        fill(255);
        text("Calibración Kinect",10,20);
        stroke(255,0,0);
        line(5,70,445,70);
        text("Controles de escena",10,100);
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
