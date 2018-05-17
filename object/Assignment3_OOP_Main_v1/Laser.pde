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
  void setLocation(float xPos, float yPos){
    this.location.x = xPos;
    this.location.y = yPos;
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
    this.velocity.x = xVel;
    this.velocity.y = yVel;
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
  
  void move(){
    this.setVelocity(cos(this.getBearing()) * this.getSpeed(), sin(this.getBearing()) * this.getSpeed());
    this.getLocationV().add(this.getVelocityV());
  }
  
  void display(){
    stroke(255);
    strokeWeight(5);
    point(this.getLocationX() , this.getLocationY());
  }
  
  void removeShot(ArrayList lasArr){
    lasArr.remove(this);
  }
}
