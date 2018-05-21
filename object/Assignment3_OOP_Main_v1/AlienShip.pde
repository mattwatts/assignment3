/*******************************************************************************
* Class: AlienShip
* Fields: Location, Velocity, LaserDir, Speed, Size, Spawned & LaserOn
* Methods: initAlien(), move(), display(), fireLaser()
* Desc: An enemy who moves along the top or bottom of the screen and fires when
*       in the sight of the player. Used to focus attention away from asteroids
*       and force the player to move around the play area.
*******************************************************************************/
class AlienShip{
  PVector location,
          velocity;
          
  float   laserDir;
  
  int     speed,
          size;
          
  boolean spawned,
          laserOn;
          
/*******************************************************************************
* Constructor: AlienShip()
* Parameters: NONE
* Returns: NONE
* Desc: Initialises the alien ship in a location outside the play area to be
*       spawned later. Its dosent move until spawned and its size and speed can
*       be modified here. It isnt initially spawned until conditions are met and
*       while its laser is on. It cant fire until it is in play.
*******************************************************************************/
  AlienShip(){
    this.location = new PVector(-1000,-1000);
    this.velocity = new PVector(0,0);
    this.laserDir = 0;
    this.speed = 3;
    this.size = 30;
    this.spawned = false;
    this.laserOn = true;
  }

//SETTERS AND GETTERS - METHOD DESCRIPTIONS ARE GENERALISED FOR ALL OF CLASS
/*******************************************************************************
* Setter(s): set<FieldName><OPTION>()
* Parameters: inputs - denoted with an 'i' prefix.
* Returns: NONE
* Desc: Setters are used in this class to be used throughout the program. It
*       allows the new values to occupy the AlienShips fields. Some fields have
*       multiple setters denoted by the <OPTION> tag, such as the PVector 
*       fields that allow finer control over some of the AlienShips data.
*******************************************************************************/
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
  
/*******************************************************************************
* Getter(s): get<FieldName><OPTION>()
* Parameters: NONE
* Returns: <FieldType>, example PVector or Float appropriate for field
* Desc: Getters are used in this class to be used throughout the program. It
*       allows the values within the objects fields to be retrieved for certain
*       calculations. Some fields have multiple getters denoted by the <OPTION>
*       tag that allow specific data to be retrieved easily.
*******************************************************************************/
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
  
//METHODS - THESE METHODS HAVE MORE DESCRIPTION AS THEY ARE SPECIFIC TO CLASS
/*******************************************************************************
* Method: initAlien()
* Parameters: NONE
* Returns: NONE
* Desc: When executed, a random spawn location is generated and the alien ship
*       is moved to a specified location on the TOP-LEFT, BOTTOM-LEFT,
*       BOTTOM-RIGHT or TOP-RIGHT of the play area. Its velocity is set
*       depending on location as well as the direction the laser will be
*       travelling. Its spawn field is updated to denote it has spawned.
*******************************************************************************/  
  void initAlien(){
    int AlienSpawnLoc = (int(random(1,5)));
    int AlienLocPadding = 10;
    if(AlienSpawnLoc == 1){
    //alien spawns top left, goes right and laserDir set to down
      this.setLocation(0 - (this.getSize() / 2), 
      (this.getSize()+AlienLocPadding));

      this.setVelocity(this.getSpeed(),0);
      this.setLaserDir(HALF_PI);
    }else if(AlienSpawnLoc == 2){
    //alien spawns bottom left, goes right and laserDir set to up
      this.setLocation(0 - (this.getSize() / 2), 
      height - (this.getSize()+AlienLocPadding));

      this.setVelocity(this.getSpeed(),0);
      this.setLaserDir(1.5 * PI);
    }else if(AlienSpawnLoc == 3){
    //alien spawns bottom right, goes left and laserDir set to up
      this.setLocation(width + (this.getSize()/2), 
      height - (this.getSize()+AlienLocPadding));

      this.setVelocity((this.getSpeed() * -1),0);
      this.setLaserDir(1.5 * PI);
    }
    else{
    //alien spawns top right, goes left and laserDir set to down.
      this.setLocation(width + (this.getSize() / 2), 
      this.getSize()+AlienLocPadding);

      this.setVelocity((this.getSpeed() * -1),0);
      this.setLaserDir(HALF_PI);
    }
    this.setSpawned(true);
  }
  
/*******************************************************************************
* Method: move()
* Parameters: NONE
* Returns: NONE
* Desc: Moves the alien ship along its X axis and when it reached the edge of
*       the screen it bounces and moves back along that X axis. On the bounce of
*       the alienShip its laser is turned on in the event it has fired its shot.
*******************************************************************************/
  void move(){
    if(this.getSpawned()){
      this.getLocationV().add(this.getVelocityV());
      //If alien ship is moving right and approaches right edge.
      if(this.getVelocityX() > 0 && this.getLocationX() 
      >= width - (this.getSize() / 2)){

        this.setVelocity(this.getVelocityX() * -1, 0);
        this.setLaser(true);
      }
      //If alien ship is moving left and approaches left edge.
      if(this.getVelocityX() < 0 && this.getLocationX() 
      <= 0 + (this.getSize() / 2)){

        this.setVelocity(this.getVelocityX() * -1, 0);
        this.setLaser(true);
      }
    }
  }
  
/*******************************************************************************
* Method: display()
* Parameters: NONE
* Returns: NONE
* Desc: On a new Matrix, the alien ship is drawn to it specified location.
*       The aesthetic of the alien ship is determined here.
*******************************************************************************/
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

/*******************************************************************************
* Method: fireLaser()
* Parameters: ArrayList of Laser Objects - alienLasArr
* Returns: NONE
* Desc: When the alien ships laser is on, and this method executed, the ships
*       location is determined and a new Laser Object is added to the alien
*       ships laser array. After firing the alien ships laser turns off and
*       cannot fire again until it is turned on again.
*******************************************************************************/
  void fireLaser(ArrayList alienLasArr){
    if(this.getLaser()){
      int xStart = int(this.getLocationX());
      int yStart = int(this.getLocationY());
      alienLasArr.add(new Laser(xStart, yStart, this.getLaserDir()));
      this.setLaser(false);
    }
  }
}
