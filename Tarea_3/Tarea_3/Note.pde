class Note {
  int basePitch;
  int octave;
  int state;
  float noteColor;

  public Note(){}

  public Note(int basePitch, float noteColor){
    this.basePitch = basePitch;
    this.noteColor = noteColor;
    this.state = -1;
  }
}
