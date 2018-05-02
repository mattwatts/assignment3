class Asteroid{
  
  PVector location,
          velocity;
  
  float   bearing,
          speed;
  
  boolean isDead;
  
  int     size,
          scoreValue;
          
  Asteroid(){
    
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
  
  void setIsDead(boolean deadInput){
    this.isDead = deadInput;
  }
  
  boolean getIsDead(){
    boolean d = this.isDead;
    return d;
  }
  
  void setSize(int sizeInput){
    this.size = sizeInput;
  }
  
  int getSize(){
    int s = this.size;
    return s;
  }
  
  void setScoreValue(int scoreValueInput){
    this.scoreValue = scoreValueInput;
  }
  
  int getScoreValue(){
    int sv = this.scoreValue;
    return sv;
  }
  // Functions
  void startAsteroidPosition(){
    int startSide = int(random(3));
    if(startSide == 0){          // 0 = Right side of screen
      this.setLocation(random(width, width - 50), random(height));
      this.setVelocity();
    } else if(startSide == 1){   // 1 = Bottom side of screen
      this.setLocation();
    } else if(startSide == 2){   // 2 = Left side of screen
      this.setLocation()
    } else {                     // 3 = Top side of screen
      
    }
  }
    //move
    //draw
    //explode
    //split
}
