class Asteroid{
  PShape polygon;
  
  //PImage newSchool;
  
  PVector location,
          velocity;
  
  float   bearing,
          speed;
  
  boolean isDead;
  
  int     size,
          score;
                   
  Asteroid(float xpos, float ypos, float bearingInput, float speedInput, boolean deadInput, int sizeInput, int scoreValueInput){
    this.location = new PVector(xpos, ypos);
    this.velocity = new PVector(0.0,0.0);
    this.bearing = bearingInput;
    this.speed = speedInput;
    this.isDead = deadInput;
    this.size = sizeInput;
    this.score = scoreValueInput;
    this.polygon = this.initPolygon((this.getSize()/2),int(random(12,24)));
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
  
  void setScore(int scoreValueInput){
    this.score = scoreValueInput;
  }
  
  int getScore(){
    int sv = this.score;
    return sv;
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
      /*
      if(gObj.getGFX() == true){
        image
      }else{
      */
        shape(this.polygon, this.getLocationX(),this.getLocationY());
      //}
    }
  }
  
  void destroy(ArrayList astArr, Game runThru){
    runThru.setScore(runThru.getScore() + this.getScore());
    if(this.getSize() >= 50){
      float spawnPointX = this.getLocationX();
      float spawnPointY = this.getLocationY();
      float spawnSpeed = this.getSpeed() * 1.2;
      int spawnSize = this.getSize() / 2;
      int spawnScore = this.getScore() + 25;
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
