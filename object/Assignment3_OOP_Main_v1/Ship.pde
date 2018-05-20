class Ship{
  PVector location,
          velocity,
          acceleration;
          
  float   rotateValue,
          bearing,
          speed,
          thrust,
          size;
          
  boolean spawned,
          exhaustOn,
          laserOn,
          isDead;
          
  Ship(boolean hasSpawned){
    this.location = new PVector(width/2, height/2);
    this.velocity = new PVector(0,0);
    this.acceleration = new PVector(0,0);
    this.rotateValue = PI/50;
    this.bearing = 1.5 * PI;
    this.speed = 5;
    this.thrust = 0.1;
    this.size = 10;
    this.spawned = hasSpawned;
    this.exhaustOn = false;
    this.laserOn = true;
    this.isDead = false;
  }
  
  //Setters and Getters
  void setLocation(float iXLoc, float iYLoc){
    this.location.x = iXLoc;
    this.location.y = iYLoc;
  }
  
  PVector getLocationV(){
    PVector sLoc = this.location;
    return sLoc;
  }
  
  float getLocationX(){
    float sLocX = this.location.x;
    return sLocX;
  }
  
  float getLocationY(){
    float sLocY = this.location.y;
    return sLocY;
  }
  
  void setVelocity(float iXVel, float iYVel){
    this.velocity.x = iXVel;
    this.velocity.y = iYVel;
  }
  
  PVector getVelocityV(){
    PVector sVel = this.velocity;
    return sVel;
  }
  
  float getVelocityX(){
    float sVelX = this.velocity.x;
    return sVelX;
  }
  
  float getVelocityY(){
    float sVelY = this.velocity.y;
    return sVelY;
  }
  
  void setAcceleration(float iXAcc, float iYAcc){
    this.acceleration.x = iXAcc;
    this.acceleration.y = iYAcc;
  }
  
  PVector getAccelerationV(){
    PVector sAcc = this.acceleration;
    return sAcc;
  }
  
  float getAccelerationX(){
    float sAccX = this.acceleration.x;
    return sAccX;
  }
  
  float getAccelerationY(){
    float sAccY = this.acceleration.y;
    return sAccY;
  }
  
  void setRotateValue(float iRotateVal){
    this.rotateValue = iRotateVal;
  }
  
  float getRotateValue(){
    float sRotateVal = this.rotateValue;
    return sRotateVal;
  }
  
  void setBearing(float iBearing){
    this.bearing = iBearing;
  }
  
  float getBearing(){
    float sBearing = this.bearing;
    return sBearing;
  }
  
  void setSpeed(float iSpeed){
    this.speed = iSpeed;
  }
  
  float getSpeed(){
    float sSpeed = this.speed;
    return sSpeed;
  }
  
  void setThrust(float iThrust){
    this.thrust = iThrust;
  }
  
  float getThrust(){
    float sThrust = this.thrust;
    return sThrust;
  }
  
  void setSize(float iSize){
    this.size = iSize;
  }
  
  float getSize(){
    float sSize = this.size;
    return sSize;
  }
  
  void setSpawned(boolean iSpawned){
    this.spawned = iSpawned;
  }
  
  boolean getSpawned(){
    boolean sSpawned = this.spawned;
    return sSpawned;
  }
  
  void setExhaust(boolean iExhaust){
    this.exhaustOn = iExhaust;
  }
  
  boolean getExhaust(){
    boolean sExhaust = this.exhaustOn;
    return sExhaust;
  }
  
  void setLaser(boolean ilaser){
    this.laserOn = ilaser;
  }
  
  boolean getLaser(){
    boolean sLaser = this.laserOn;
    return sLaser;
  }
  
  void setIsDead(boolean iDead){
    this.isDead = iDead;
  }
  
  boolean getIsDead(){
    boolean sDead = this.isDead;
    return sDead;
  }
    
  // METHODS:
  void accelerate(String direction){
    if(direction == "FORWARD"){
      if(this.getThrust() <= 0){
        this.setThrust(playerOne.getThrust() * -1);
      }
    }
    if(direction == "BACKWARD"){
      if(this.getThrust() >= 0){
        this.setThrust(playerOne.getThrust() * -1);
      }
    }
    this.setAcceleration(cos(this.getBearing()), sin(this.getBearing()));
    this.getAccelerationV().setMag(this.getThrust());
    this.getVelocityV().add(this.getAccelerationV());
    // LIMITS THE TOP SPEED OF THE SHIP
    this.getVelocityV().limit(this.getSpeed());
    this.setExhaust(true);
  }
  
  void move(){
    this.getLocationV().add(this.getVelocityV());
    // WRAPS AROUND SCREEN
    if(this.getLocationX() > width + 15){
      this.setLocation(-3, this.getLocationY());
    }
    if(this.getLocationX() < - 15){
      this.setLocation(width + 15, this.getLocationY());
    }
    if(this.getLocationY() > height + 15){
      this.setLocation(this.getLocationX(), -15);
    }
    if(this.getLocationY() < -15){
      this.setLocation(this.getLocationX(), height + 15);
    }
  }
  
  void turn(String rotate){
    // LIMITS BEARING VALUES BETWEEN 0 and TWO_PI
    if(rotate == "RIGHT"){
      if(this.getBearing() > TWO_PI){
        this.setBearing(this.getBearing() - TWO_PI);
      }
      this.setBearing(this.getBearing() + this.getRotateValue());
    }
    if(rotate == "LEFT"){
      if(this.getBearing() < 0){
        this.setBearing(this.getBearing() + TWO_PI);
      }
      this.setBearing(this.getBearing() - this. getRotateValue());
    }
  }
  
  /*
  void teleport(){
    this.setVelocity(0.0,0.0);
    float randX = random(this.getSize(), width - this.getSize());
    float randY = random(this.getSize(), height - this.getSize());
    this.setLocation(randX, randY);
  }
  */
  
  void display(){
    pushMatrix();
    translate(this.getLocationX(), this.getLocationY());
    rotate(this.getBearing());
    if(this.getExhaust() == true){
      this.displayExhaust(this.getThrust());
    }
    noFill();
    stroke(255);
    strokeWeight(1);
    fill(0);
    triangle(this.getSize(),0,this.getSize() * -1,this.getSize(), this.getSize() * -1, this.getSize() * -1);
    //this.polygon(0, 0, 15, 3);
    popMatrix();
  }
  
  void displayExhaust(float thrustVal){
    if(thrustVal > 0){
      noFill();
      stroke(255);
      strokeWeight(1);
      triangle(-10,5,-25,0,-10,-5);  
    }
    if(thrustVal < 0){
      noFill();
      stroke(255);
      strokeWeight(1);
      triangle(0,-(this.getSize() / 2),(this.getSize() * 2.5), 0, 0, this.getSize() / 2);
    }
    
  }
  
  void fireLaser(ArrayList projectile){
    if(this.getLaser()){
      float xStart = this.getLocationX() + (cos(this.getBearing()) * this.getSize());
      float yStart = this.getLocationY() + (sin(this.getBearing()) * this.getSize());
      projectile.add(new Laser(xStart, yStart, this.getBearing()));
      this.setLaser(false);
    }
  }
  
  void resetShip(){
    this.setLocation(width/2,height/2);
    this.setBearing(1.5 * PI);
    this.setVelocity(0,0);
    this.setAcceleration(0,0);
  }
}
