public class ControlFrame extends PApplet {

    int w, h;
    ControlP5 cp5;
    Object parent;

    public void setup() {
        size(w, h);
        frameRate(25);

        cp5 = new ControlP5(this);

        //controles kinect
        cp5.addSlider("kinectCalibrationControl")
          .plugTo(parent,"calib_dist")
          .setRange(1, 5000)
          .setPosition(10, 40)
          .setSize(300, 10)
          .setValue(3000)
          .setLabel("");

        //controles reloj
        cp5.addBang("grabControl")
            .setPosition(10, 120)
            .setSize(40, 20)
            .setLabel("Tomar");

        cp5.addBang("clockControl")
            .setPosition(110, 120)
            .setSize(40, 20)
            .setLabel("Visible");

    /*    cp5.addBang("releaseControl")
            .setPosition(210, 120)
            .setSize(40, 20)
            .setLabel("Soltar");*/

        //controles escenas
        cp5.addBang("firstSceneControl")
            .setPosition(10, 220)
            .setSize(40, 20)
            .setLabel("Escena 1");

        cp5.addBang("secondSceneControl")
            .setPosition(110, 220)
            .setSize(40, 20)
            .setLabel("Escena 2");

        cp5.addBang("thirdSceneControl")
            .setPosition(210, 220)
            .setSize(40, 20)
            .setLabel("Escenas 3");

        //controles grabacion
        cp5.addBang("recordControl")
            .setPosition(10, 320)
            .setSize(40, 20)
            .setLabel("Grabar");

        cp5.addBang("playControl")
            .setPosition(110, 320)
            .setSize(40, 20)
            .setLabel("Reproducir");

    /*    cp5.addBang("cameraControl")
            .setPosition(210, 320)
            .setSize(40, 20)
            .setLabel("Camara");*/

        //toggles sombra
        cp5.addToggle("viewShadowControl")
            .plugTo(parent,"draw_shadow")
            .setPosition(10, 420)
            .setSize(40, 20)
            .setValue(true)
            .setLabel("Visible");

        cp5.addToggle("invertShadowControl")
            .plugTo(parent,"invert_shadow")
            .setPosition(110, 420)
            .setSize(40, 20)
            .setValue(false)
            .setLabel("Invertir");
    }


    void controlEvent(ControlEvent theEvent) {
        String n = theEvent.getName();

        if (n == "grabControl") {
            grab_clock = !grab_clock;
        } else if (n == "clockControl") {
            clock.visible = !clock.visible;
        } else if (n == "releaseControl") {
            println("allow_release : " + clock.allow_release);
            clock.allow_release = !clock.allow_release;
            context.enableUser();
        } else if (n == "firstSceneControl") {
            scene = "firstScene";
        } else if (n == "secondSceneControl") {
            invert_shadow = true;
            scene         = "secondScene";
            imagenes.incrementImageIndex();
        } else if (n == "thirdSceneControl") {
            invert_shadow = false;
            scene         = "thirdScene";
        } else if (n == "recordControl") {
            println("Comienza grabación");
            do_play        = false;
            end_scene      = false;
            do_record      = true;
            record_context = true;
        } else if (n == "playControl") {
            println("Comienza reproducción");
            do_record    = false;
            end_scene    = false;
            do_play      = true;
            play_context = true;
        } else if (n == "cameraControl") {
            println("Comienza cámara");
            do_record      = false;
            do_play        = false;
            end_scene      = true;
            camera_context = true;
        }
    }

    public void draw() {
        background(0);
        fill(255);
        stroke(255,0,0);
        text("Calibración Kinect",10,20);
        line(5,70,445,70);
        text("Controles reloj",10,100);
        line(5,170,445,170);
        text("Controles escenas",10,200);
        line(5,270,445,270);
        text("Controles grabación",10,300);
        line(5,370,445,370);
        text("Toggles sombra",10,400);
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
