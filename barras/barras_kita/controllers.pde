
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
      
     alphaSlider = cp5.addSlider("Transparencia")
      .plugTo(parent,"alpha")
      .setRange(0, 255)
      .setPosition(10,90);
     
     checkboxInv = cp5.addCheckBox("checkboxInv")
      .setPosition(10,50)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setSize(20, 20)
      .setItemsPerRow(3)
      .setSpacingColumn(30)
      .setSpacingRow(20)
      .addItem("Invertir", 50);
      
    checkboxNoisyColor = cp5.addCheckBox("checkboxNoisyColor")
      .setPosition(10,10)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setSize(20, 20)
      .setItemsPerRow(3)
      .setSpacingColumn(30)
      .setSpacingRow(20)
      .addItem("NoisyColor", 50);
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
