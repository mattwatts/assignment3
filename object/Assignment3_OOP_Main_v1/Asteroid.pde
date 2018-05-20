class Asteroid{
  PShape polygon;
  
  PVector location,
          velocity;
  
  float   bearing,
          speed;
  
  boolean isDead;
  
  int     size,
          score;
                   
  Asteroid(float iXLoc, float iYLoc, float iBearing, float iSpeed, boolean iDead, int iSize, int iScore){
    this.location = new PVector(iXLoc, iYLoc);
    this.velocity = new PVector(0.0,0.0);
    this.bearing = iBearing;
    this.speed = iSpeed;
    this.isDead = iDead;
    this.size = iSize;
    this.score = iScore;
    this.polygon = this.initPolygon((this.getSize()/2),int(random(12,24)));
  }
  
  // Setters and Getters
  void setLocation(float iXLoc, float iYLoc){
    this.location.x = iXLoc;
    this.location.y = iYLoc;
  }
  
  PVector getLocationV(){
    PVector aLoc = this.location;
    return aLoc;
  }
  
  float getLocationX(){
    float aLocX = this.location.x;
    return aLocX;
  }
  
  float getLocationY(){
    float aLocY = this.location.y;
    return aLocY;
  }
  
  void setVelocity(float iXVel, float iYVel){
    this.velocity.x = iXVel;
    this.velocity.y = iYVel;
  }
  
  PVector getVelocityV(){
    PVector aVel = this.velocity;
    return aVel;
  }
  
  float getVelocityX(){
    float aVelX = this.velocity.x;
    return aVelX;
  }
  
  float getVelocityY(){
    float aVelY = this.velocity.y;
    return aVelY;
  }
  
  void setBearing(float iBearing){
    this.bearing = iBearing;
  }
  
  float getBearing(){
    float aBearing = this.bearing;
    return aBearing;
  }
  
  void setSpeed(float iSpeed){
    this.speed = iSpeed;
  }
  
  float getSpeed(){
    float aSpeed = this.speed;
    return aSpeed;
  }
  
  void setIsDead(boolean iDead){
    this.isDead = iDead;
  }
  
  boolean getIsDead(){
    boolean aDead = this.isDead;
    return aDead;
  }
  
  void setSize(int iSize){
    this.size = iSize;
  }
  
  int getSize(){
    int aSize = this.size;
    return aSize;
  }
  
  void setScore(int iScore){
    this.score = iScore;
  }
  
  int getScore(){
    int aScore = this.score;
    return aScore;
  }
  
  // Methods
  void move(){
    if(this.getIsDead() == false){
      this.setVelocity(cos(this.getBearing()) * this.getSpeed(), sin(this.getBearing()) * this.getSpeed());
      this.getLocationV().add(this.getVelocityV());
      //WRAPS AROUND SCREEN
      if (this.getLocationX() > width + (this.getSize() / 2)) {
        this.location.x = 0 - (this.getSize() / 2);
      }
      if (this.getLocationX() < 0 - (this.getSize() / 2)) {
        this.location.x = width + (this.getSize() / 2);
      }
      if (this.getLocationY() > height + (this.getSize() / 2)) {
        this.location.y = 0 - (this.getSize() / 2);
      }
      if (this.getLocationY() < 0 - (this.getSize() / 2)) {
        this.location.y = height + (this.getSize() / 2);
      }
    }
  }
  
  void display(){
    if(this.getIsDead() == false){
        shape(this.polygon, this.getLocationX(),this.getLocationY());
    }
  }
  
  void destroy(ArrayList astArr, Game runThru){
    runThru.setScore(runThru.getScore() + this.getScore());
    if(this.getSize() >= 50){
      float spawnPointX = this.getLocationX();
      float spawnPointY = this.getLocationY();
      float spawnSpeed = this.getSpeed() * 1.3;
      int spawnSize = this.getSize() / 2;
      int spawnScore = this.getScore() * 2;
      astArr.add(new Asteroid(spawnPointX, spawnPointY, random(0, TWO_PI), spawnSpeed, false,  spawnSize, spawnScore));
      astArr.add(new Asteroid(spawnPointX, spawnPointY, random(0, TWO_PI), spawnSpeed, false,  spawnSize, spawnScore));
    }
    astArr.remove(this);
  }
  
  PShape initPolygon(float radius, int npoints){
    PShape temp;
    temp = createShape();
    temp.beginShape();
    temp.noFill();
    temp.strokeWeight(1);
    temp.stroke(255);
    float angle = TWO_PI / npoints;
    for (float a = 0; a < TWO_PI; a += angle) {
      int offset = int(random(6,12));
      float sx = cos(a) * radius - offset;
      float sy = sin(a) * radius + offset;
      temp.vertex(sx, sy);
    }
    temp.endShape(CLOSE);
    return temp;
  }
}
