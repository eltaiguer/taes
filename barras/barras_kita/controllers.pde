
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

     checkboxPelotitas = cp5.addCheckBox("checkBox")
                .setPosition(10, 110)
                .setColorForeground(color(120))
                .setColorActive(color(255))
                .setColorLabel(color(255))
                .setSize(20, 20)
                .setItemsPerRow(3)
                .setSpacingColumn(30)
                .setSpacingRow(20)
                .addItem("Pelotitas", 50);

     sliderPelotitas =  cp5.addSlider("Numero de Pelotitas")
      .plugTo(parent,"num")
      .setRange(1, 20)
      .setPosition(10,140);
      
     alphaSlider = cp5.addSlider("Transparencia")
      .plugTo(parent,"alpha")
      .setRange(0, 255)
      .setPosition(10,90);
      
     invToggle = cp5.addToggle("Invertir fondo")
     .setPosition(10,50)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
  }
  public void draw() {
    background(0);
  }
  private ControlFrame() {
  }
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
