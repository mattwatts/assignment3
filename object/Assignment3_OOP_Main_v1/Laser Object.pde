class Laser{
  PVector location;
  
  float   bearing,
          speed;
          
  int     size;
          
  Laser(){
    //this.setLocation();
    //this.setBearing();
    //this.setSpeed();
    //this.setSize();
  }
  
  // Setters and Getters
  void setLocation(PVector loc){
    this.location = loc;
  }
  
  PVector getLocationV(){
    PVector loc = this.location;
    return loc;
  }
  
  float getLocationX(){
    float locX = this.location.x;
    return locX;
  }
  
  float getLocationY(){
    float locY = this.location.y;
    return locY;
  }
  
  void setBearing(float bearingInput){
    this.bearing = bearingInput;
  }
  
  float getBearing(){
    float b = this.bearing;
    return b;
  }
  
  void setSpeed(float speedInput){
    this.speed = speedInput;
  }
  
  float getSpeed(){
    float sp = this.speed;
    return sp;
  }
  
  void setSize(int sizeInput){
    this.size = sizeInput;
  }
  
  int getSize(){
    int s = this.size;
    return s;
  }
  
  // Functions
    //move
    //draw
    //collision w. asteroid
}
