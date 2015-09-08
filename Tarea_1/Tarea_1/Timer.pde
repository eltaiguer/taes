class Timer {
  int initTime;
  int endTime;
  
  Timer(){
    initTime = 0;
    endTime = 0;
  }
  
  void startTimer(){
    initTime = millis()/1000;
  }
  
//  void StopTimer(){
//    endTime = millis()/1000;
//  }
  
  int getTime(){
    return (millis()/1000 - initTime);
  }
}
