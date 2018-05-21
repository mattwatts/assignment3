/*******************************************************************************
* Class: Ship
* Fields: Location, Velocity, Acceleration, RotateValue, Bearing, Speed, Thrust
*         Size, Spawned, ExhaustOn, LaserOn, IsDead.
* Methods: accelerate(), move(), turn(), teleport(), display(), 
*          displayExhaust(), fireLaser(), resetShip()
* Desc: Ship object that represents the player. The player interacts with the
*       ship object directly by using the controls to fulfil the games goals.
*******************************************************************************/
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

/*******************************************************************************
* Constructor: Ship()
* Parameters: boolean - hasSpawned
* Returns: NONE
* Desc: Initiates the fields of the Ship object, The ship starts in the middle
*       of the play area, is facing up and depending if the game is paused or
*       not, is "spawned" into the play area. Further properties like rotate
*       speed, max movement speed and size can be modified here.
*******************************************************************************/
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
  
//SETTERS AND GETTERS - METHOD DESCRIPTIONS ARE GENERALISED FOR ALL OF CLASS
/*******************************************************************************
* Setter(s): set<FieldName><OPTION>()
* Parameters: inputs - denoted with an 'i' prefix.
* Returns: NONE
* Desc: Setters are used in this class to be used throughout the program. It
*       allows the new values to occupy the Ships fields. Some fields have
*       multiple setters denoted by the <OPTION> tag, such as the PVector 
*       fields that allow finer control over some of the Ships data.
*******************************************************************************/
  void setLocation(float iXLoc, float iYLoc){
    this.location.x = iXLoc;
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

//METHODS - THESE METHODS HAVE MORE DESCRIPTION AS THEY ARE SPECIFIC TO CLASS
/*******************************************************************************
* Method: accelerate()
* Parameters: String - direction
* Returns: NONE
* Desc: Takes in a String that depends on the particular controls used when
*       this method is called. This allow the ship to move forwards and
*       backwards by controlling a "thrust" field. This thrust is then used to
*       determine its acceleration depending on the ships current bearing. This
*       acceleration is then added to its velocity field where its max speed is
*       determined. Finally a boolean controlling whether the ship has an
*       exhasut graphic drawn is set to true.
*******************************************************************************/  
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
  
/*******************************************************************************
* Method: move()
* Parameters: NONE
* Returns: NONE
* Desc: Takes the velocity field of the ship, from the acclerate method and
*       updates its current location within the play area. The method then
*       checks to see if the location of the ship is outside the play area
*       and updates its location to the opposite side of the play area so it
*       wraps around the screen.
*******************************************************************************/  
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
  
/*******************************************************************************
* Method: turn()
* Parameters: String - rotate
* Returns: NONE
* Desc: Takes in a String, depending on the particular controls used when this
*       method is called. Depending of the controls used, updates the ships
*       bearing by adding or subtracting a set rotationValue or rotateSpeed.
*       The values within the bearing field are contrained to radians between
*       0 and TWO_PI.
*******************************************************************************/  
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

/*******************************************************************************
* Method: teleport()
* Parameters: NONE
* Returns: NONE
* Desc: Randomally generates a location of the play area and moves the ship
*       to that location.
* Further Notes: Not currently used in this version, as i found during testing
*                players would not use this feature. I would have liked to
*                add some implementation where the random location is checked 
*                to see if an enemy was within a certain range before the 
*                change of location was executed. We origninally mapped this
*                method to the ENTER key and The resume play implementation
*                was more of a benefit to gameplay, so was remapped to "resume"
*******************************************************************************/  
  void teleport(){
    this.setVelocity(0.0,0.0);
    float randX = random(this.getSize(), width - this.getSize());
    float randY = random(this.getSize(), height - this.getSize());
    this.setLocation(randX, randY);
  }
  
/*******************************************************************************
* Method: display()
* Parameters: NONE
* Returns: NONE
* Desc: On its own matrix, a triangle is translated to its current location
*       rotated to its current bearing. There is also a check to see if its
*       exhaust is currently on to display its exhasut graphic.
*******************************************************************************/  
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
    popMatrix();
  }
  
/*******************************************************************************
* Method: displayExhaust()
* Parameters: float - thrustVal
* Returns: NONE
* Desc: Depending on the ships current thrust (which will be positive or 
*       negative) a certain exhaust graphic is displayed to the screen, giving
*       visual feedback to the player concerning the ships current movement.
*******************************************************************************/  
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
  
/*******************************************************************************
* Method: fireLaser()
* Parameters: ArrayList - projectile
* Returns: NONE
* Desc: First, determines if the ships laser is on. If it is on, then the laser
*       can be fired and a Laser object added to a given ArrayList. This method 
*       sets its starting location depending on the Ships current position and
*       bearing (to determine the "nose of the ship"). After the laser is fired
*       the ships laserOn field is turned off until the SPACE key is released.
*******************************************************************************/  
  void fireLaser(ArrayList projectile){
    if(this.getLaser()){
      float xStart = this.getLocationX() + (cos(this.getBearing()) * this.getSize());
      float yStart = this.getLocationY() + (sin(this.getBearing()) * this.getSize());
      projectile.add(new Laser(xStart, yStart, this.getBearing()));
      this.setLaser(false);
    }
  }

/*******************************************************************************
* Method: resetShip()
* Parameters: NONE
* Returns: NONE
* Desc: Resets the ships location, velocity, acceleration and bearing in the
*       event that the ship dies and is waiting to be respawned.
*******************************************************************************/  
  void resetShip(){
    this.setLocation(width/2,height/2);
    this.setBearing(1.5 * PI);
    this.setVelocity(0,0);
    this.setAcceleration(0,0);
  }
}
