public class ControlFrame extends PApplet {

    int w, h;
    ControlP5 cp5;
    Object parent;

    public void setup() {
        size(w, h);
        frameRate(25);

        cp5 = new ControlP5(this);

        cp5.addSlider("kinectCalibrationControl")
          .plugTo(parent,"calib_dist")
          .setRange(1, 5000)
          .setPosition(10, 40)
          .setSize(300, 10)
          .setValue(3000)
          .setLabel("");

        cp5.addBang("grabControl")
            .setPosition(10, 120)
            .setSize(40, 20)
            .setLabel("Tomar");

        cp5.addBang("clockControl")
            .setPosition(110, 120)
            .setSize(40, 20)
            .setLabel("Visible");

        cp5.addBang("releaseControl")
            .setPosition(210, 120)
            .setSize(40, 20)
            .setLabel("Soltar");

        cp5.addToggle("recordControl")
            .plugTo(parent,"do_record")
            .setPosition(10, 220)
            .setSize(40, 20)
            .setValue(false)
            .setLabel("Grabar");

        cp5.addToggle("playControl")
            .plugTo(parent,"do_play")
            .setPosition(110, 220)
            .setSize(40, 20)
            .setValue(false)
            .setLabel("Reproducir");

        cp5.addToggle("shadowControl")
            .plugTo(parent,"draw_shadow")
            .setPosition(210, 220)
            .setSize(40, 20)
            .setValue(true)
            .setLabel("Ver sombra");

        cp5.addBang("firstSceneControl")
            .setPosition(10, 320)
            .setSize(40, 20)
            .setLabel("Escena 1");

        cp5.addBang("secondSceneControl")
            .setPosition(110, 320)
            .setSize(40, 20)
            .setLabel("Escena 2");

        cp5.addBang("thirdSceneControl")
            .setPosition(210, 320)
            .setSize(40, 20)
            .setLabel("Escena 3");

        cp5.addBang("backgroundControl")
            .setPosition(10, 420)
            .setSize(40, 20)
            .setLabel("Siguiente");
    }


    void controlEvent(ControlEvent theEvent) {
        String n = theEvent.getName();

        if (n == "grabControl") {
            grab_clock = !grab_clock;
        } else if (n == "clockControl") {
            clock.visible = !clock.visible;
        } else if (n == "releaseControl") {
            clock.habilitadoPorControlUI = !clock.habilitadoPorControlUI;
        } else if (n == "firstSceneControl") {
            scene = "firstScene";
        } else if (n == "secondSceneControl") {
            scene = "secondScene";
        } else if (n == "thirdSceneControl") {
            scene = "thirdScene";
        } else if (n == "backgroundControl") {
            background_image++;
        }
    }

    public void draw() {
        background(0);
        fill(255);
        text("Calibración Kinect",10,20);
        stroke(255,0,0);
        line(5,70,445,70);
        text("Controles reloj",10,100);
        line(5,170,445,170);
        text("Toggles grabación",10,200);
        line(5,270,445,270);
        text("Controles escenas",10,300);
        line(5,370,445,370);
        text("Control imágenes",10,400);
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
