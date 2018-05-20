class Laser{
  PVector location,
          velocity;
  
  float   bearing,
          speed;
          
  int     size;
          
  Laser(float xpos, float ypos, float dir){
    this.location = new PVector(xpos,ypos);
    this.velocity = new PVector(0,0);
    this.bearing = dir;
    this.speed = 10;
    this.size = 10;
  }
  
  // Setters and Getters
  void setLocation(float iXLoc, float iYLoc){
    this.location.x = iXLoc;
    this.location.y = iYLoc;
  }
  
  PVector getLocationV(){
    PVector lLoc = this.location;
    return lLoc;
  }
  
  float getLocationX(){
    float lLocX = this.location.x;
    return lLocX;
  }
  
  float getLocationY(){
    float lLocY = this.location.y;
    return lLocY;
  }
  
  void setVelocity(float iXVel, float iYVel){
    this.velocity.x = iXVel;
    this.velocity.y = iYVel;
  }
  
  PVector getVelocityV(){
    PVector lVel = this.velocity;
    return lVel;
  }
  
  float getVelocityX(){
    float lVelX = this.velocity.x;
    return lVelX;
  }
  
  float getVelocityY(){
    float lVelY = this.velocity.y;
    return lVelY;
  }
  
  void setBearing(float iBearing){
    this.bearing = iBearing;
  }
  
  float getBearing(){
    float lBearing = this.bearing;
    return lBearing;
  }
  
  void setSpeed(float iSpeed){
    this.speed = iSpeed;
  }
  
  float getSpeed(){
    float lSpeed = this.speed;
    return lSpeed;
  }
  
  void setSize(int iSize){
    this.size = iSize;
  }
  
  int getSize(){
    int lSize = this.size;
    return lSize;
  }
  
  void move(){
    this.setVelocity(cos(this.getBearing()) * this.getSpeed(), sin(this.getBearing()) * this.getSpeed());
    this.getLocationV().add(this.getVelocityV());
  }
  
  void display(){
    strokeWeight(5);
    point(this.getLocationX() , this.getLocationY());
  }
  
  void removeShot(ArrayList lasArr){
    lasArr.remove(this);
  }
}
