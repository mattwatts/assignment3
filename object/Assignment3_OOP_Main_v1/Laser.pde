/*******************************************************************************
* Class: Laser
* Fields: Location, Velocity, Bearing, Speed and Size.
* Methods: move(), display(), removeShot()
* Desc: The laser object is used in ArrayLists to provide the player with
*       a way of destroying asteroids and the alien ship. It is also used for
*       the alien ship to destroy the player.
*******************************************************************************/
class Laser{
  PVector location,
          velocity;
  
  float   bearing,
          speed;
          
  int     size;
  
/*******************************************************************************
* Constructor: Laser()
* Parameters: iXPos, iYPos, iDir
* Returns: NONE
* Desc: Initiates the Laser object with its starting values that depends on the
*       position and bearing of the source firing the laser. The size and speed
*       of these Lasers are constant and can be modified here.
*******************************************************************************/
  Laser(float iXPos, float iYPos, float iDir){
    this.location = new PVector(iXPos,iYPos);
    this.velocity = new PVector(0,0);
    this.bearing = iDir;
    this.speed = 10;
    this.size = 10;
  }
  
//SETTERS AND GETTERS - METHOD DESCRIPTIONS ARE GENERALISED FOR ALL OF CLASS
/*******************************************************************************
* Setter(s): set<FieldName><OPTION>()
* Parameters: inputs - denoted with an 'i' prefix.
* Returns: NONE
* Desc: Setters are used in this class to be used throughout the program. It
*       allows the new values to occupy the Lasers fields. Some fields have
*       multiple setters denoted by the <OPTION> tag, such as the PVector 
*       fields that allow finer control over some of the Lasers data.
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

//METHODS - THESE METHODS HAVE MORE DESCRIPTION AS THEY ARE SPECIFIC TO CLASS
/*******************************************************************************
* Method: move()
* Parameters: NONE
* Returns: NONE
* Desc: Calculates the velocity of the laser and adds this vector field
*       to its current location
*******************************************************************************/  
  void move(){
    //Velocity is calculated using trigonomotry on its bearing.
    this.setVelocity(cos(this.getBearing()) * this.getSpeed(), 
    sin(this.getBearing()) * this.getSpeed());
    
    this.getLocationV().add(this.getVelocityV());
  }
  
/*******************************************************************************
* Method: display()
* Parameters: NONE
* Returns: NONE
* Desc: Displays a point to the screen to indicate the lasers current location.
*******************************************************************************/  
  void display(){
    strokeWeight(5);
    point(this.getLocationX() , this.getLocationY());
  }
  
/*******************************************************************************
* Method: removeShot()
* Parameters: ArrayList of Laser Objects - lasArr
* Returns: NONE
* Desc: removes the laser object from its given ArrayList.
*******************************************************************************/  
  void removeShot(ArrayList lasArr){
    lasArr.remove(this);
  }
}
