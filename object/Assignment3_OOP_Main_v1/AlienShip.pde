class AlienShip{
  PVector location,
          velocity;
          
  float   laserDir;
  
  int     speed,
          size;
          
  boolean spawned,
          laserOn;
          
  AlienShip(){
    this.location = new PVector(-1000,-1000);
    this.velocity = new PVector(0,0);
    this.laserDir = 0;
    this.speed = 3;
    this.size = 30;
    this.spawned = false;
    this.laserOn = true;
  }
  
  //Getters and Setters
  void setLocation(float iXLoc, float iYLoc){
    this.location.x = iXLoc;
    this.location.y = iYLoc;
  }
  
  void setLocationX(float iXLoc){
    this.location.x = iXLoc;
  }
  
  void setLocationY(float iYLoc){
    this.location.y = iYLoc;
  }
  
  PVector getLocationV(){
    PVector aSLoc = this.location;
    return aSLoc;
  }
  
  float getLocationX(){
    float aSLocX = this.location.x;
    return aSLocX;
  }
  
  float getLocationY(){
    float aSLocY = this.location.y;
    return aSLocY;
  }
  
  void setVelocity(float iXVel, float iYVel){
    this.velocity.x = iXVel;
    this.velocity.y = iYVel;
  }
  
  void setVelocityX(float iXVel){
    this.velocity.x = iXVel;
  }
  
  void setVelocityY(float iYVel){
    this.velocity.y = iYVel;
  }
  
  PVector getVelocityV(){
    PVector aSVel = this.velocity;
    return aSVel;
  }
  
  float getVelocityX(){
    float aSVelX = this.velocity.x;
    return aSVelX;
  }
  
  float getVelocityY(){
    float aSVelX = this.velocity.y;
    return aSVelX;
  }
  
  void setLaserDir(float iLaserDir){
    this.laserDir = iLaserDir;
  }
  
  float getLaserDir(){
    float aSLaserDir = this.laserDir;
    return aSLaserDir;
  }
  
  void setSpeed(int iSpeed){
    this.speed = iSpeed;
  }
  
  int getSpeed(){
    int aSSpeed = this.speed;
    return aSSpeed;
  }
  
  void setSize(int iSize){
    this.size = iSize;
  }
  
  int getSize(){
    int aSSize = this.size;
    return aSSize;
  }
  
  void setSpawned(boolean iSpawn){
    this.spawned = iSpawn;
  }
  
  boolean getSpawned(){
    boolean aSSpawn = this.spawned;
    return aSSpawn;
  }
  
  void setLaser(boolean iLaser){
    this.laserOn = iLaser;
  }
  
  boolean getLaser(){
    boolean aSLaser = this.laserOn;
    return aSLaser;
  }
  
  //Methods
  
  void initAlien(){
    int AlienSpawnLoc = (int(random(1,5)));
    int AlienLocPadding = 10;
    if(AlienSpawnLoc == 1){
    //alien spawns top left, goes right and laserDir set to down
      this.setLocation(0 - (this.getSize() / 2), (this.getSize()+AlienLocPadding));
      this.setVelocity(this.getSpeed(),0);
      this.setLaserDir(HALF_PI);
    }else if(AlienSpawnLoc == 2){
      //alien spawns bottom left, goes right and laserDir set to up
      this.setLocation(0 - (this.getSize() / 2), height - (this.getSize()+AlienLocPadding));
      this.setVelocity(this.getSpeed(),0);
      this.setLaserDir(1.5 * PI);
    }else if(AlienSpawnLoc == 3){
      //alien spawns bottem right, goes left and laserDir set to up
      this.setLocation(width + (this.getSize()/2), height - (this.getSize()+AlienLocPadding));
      this.setVelocity((this.getSpeed() * -1),0);
      this.setLaserDir(1.5 * PI);
    }
    else{
      //alien spawns top right, goes left and laserDir set to down.
      this.setLocation(width + (this.getSize() / 2), this.getSize()+AlienLocPadding);
      this.setVelocity((this.getSpeed() * -1),0);
      this.setLaserDir(HALF_PI);
    }
    this.setSpawned(true);
  }
  
  void move(){
    if(this.getSpawned()){
      this.getLocationV().add(this.getVelocityV());
      //So it bounces along the top/bottom of screen. on bounce it turns its laser back on.
      if(this.getVelocityX() > 0 && this.getLocationX() >= width - (this.getSize() / 2)){
        this.setVelocity(this.getVelocityX() * -1, 0);
        this.setLaser(true);
      }
      if(this.getVelocityX() < 0 && this.getLocationX() <= 0 + (this.getSize() / 2)){
        this.setVelocity(this.getVelocityX() * -1, 0);
        this.setLaser(true);
      }
    }
  }
  
  void display(){
    if(this.getSpawned()){
      pushMatrix();
      translate(this.getLocationX(),this.getLocationY());
      fill(255,255,0);
      stroke(255,255,0);
      strokeWeight(1);
      ellipse(0,0,this.getSize(),this.getSize());
      popMatrix();
    }
  }
  
  void fireLaser(ArrayList alienLasArr){
    if(this.getLaser()){
      int xStart = int(this.getLocationX());
      int yStart = int(this.getLocationY());
      alienLasArr.add(new Laser(xStart, yStart, this.getLaserDir()));
      this.setLaser(false);
    }
  }
}
