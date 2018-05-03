class Ship{
  PVector location,
          velocity,
          acceleration;
          
  float   rotateValue,
          bearing,
          thrust;
          
  boolean exhaustOn,
          laserOn;
          
  Ship(){
    this.setLocation(width/2,height/2);
    //this.setVelocity();
    //this.setAcceleration;
    //this.setBearing();
    //this.setThrust();
    //this.setExhaust();
    //this.setLaser();
  }
  
  //Setters and Getters
  void setLocation(float xpos, float ypos){
    this.location.x = xpos;
    this.location.y = ypos;
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
  
  void setVelocity(float xVel, float yVel){
    this.location.x = xVel;
    this.location.y = yVel;
  }
  
  PVector getVelocityV(){
    PVector vel = this.velocity;
    return vel;
  }
  
  float getVelocityX(){
    float velX = this.velocity.x;
    return velX;
  }
  
  float getVelocityY(){
    float velY = this.velocity.y;
    return velY;
  }
  
  void setAcceleration(float xAcc, float yAcc){
    this.acceleration.x = xAcc;
    this.acceleration.y = yAcc;
  }
  
  PVector getAccelerationV(){
    PVector acc = this.acceleration;
    return acc;
  }
  
  float getAccelerationX(){
    float accX = this.acceleration.x;
    return accX;
  }
  
  float getAccelerationY(){
    float accY = this.acceleration.y;
    return accY;
  }
  
  void setRotateValue(float rotateValueInput){
    this.rotateValue = rotateValueInput;
  }
  
  float getRotateValue(){
    float rV = this.rotateValue;
    return rV;
  }
  void setBearing(float bearingInput){
    this.bearing = bearingInput;
  }
  
  float getBearing(){
    float b = this.bearing;
    return b;
  }
  
  void setThrust(float thrustInput){
    this.thrust = thrustInput;
  }
  
  float getThrust(){
    float t = this.thrust;
    return t;
  }
  
  void setExhaust(boolean exhaustInput){
    this.exhaustOn = exhaustInput;
  }
  
  boolean getExhaust(){
    boolean e = this.exhaustOn;
    return e;
  }
  
  void setLaser(boolean laserInput){
    this.laserOn = laserInput;
  }
  
  boolean getLaser(){
    boolean l = this.laserOn;
    return l;
  }
    
  // Functions
    // move
    // rotate
    // draw
    // fire laser
    // teleport
    // colllision w. asteroid (reset)
}
