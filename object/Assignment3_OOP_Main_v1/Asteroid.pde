/*******************************************************************************
* Class: Asteroid
* Fields: Polygon, Location, Velocity, Bearing, Speed, IsDead, Size & Score
* Methods: move(), display(), destroy(), initPoly()
* Desc: Main enemies of the Asteroid Game, drift around the play area and
*       provide the challenge and objective for the player.
*******************************************************************************/
class Asteroid{
  PShape polygon;
  
  PVector location,
          velocity;
  
  float   bearing,
          speed;
  
  boolean isDead;
  
  int     size,
          score;

/*******************************************************************************
* Constructor: Asteroid()
* Parameters: iXLoc, iYLoc, iBearing, iSpeed, iDead, iSize, iScore
* Returns: NONE
* Desc: Initiates the asteroid objects fields with easily modifiable parameters
*       The initPolygon() method is called here to determine Asteroids shape.
*******************************************************************************/
  // Long parameter list allows finer control over asteroid "children".
  Asteroid(float iXLoc, float iYLoc, float iBearing, float iSpeed, 
  boolean iDead, int iSize, int iScore){

    this.location = new PVector(iXLoc, iYLoc);
    this.velocity = new PVector(0.0,0.0);
    this.bearing = iBearing;
    this.speed = iSpeed;
    this.isDead = iDead;
    this.size = iSize;
    this.score = iScore;
    this.polygon = this.initPolygon((this.getSize()/2),int(random(12,24)));
  }
  
//SETTERS AND GETTERS - METHOD DESCRIPTIONS ARE GENERALISED FOR ALL OF CLASS
/*******************************************************************************
* Setter(s): set<FieldName><OPTION>()
* Parameters: inputs - denoted with an 'i' prefix.
* Returns: NONE
* Desc: Setters are used in this class to be used throughout the program. It
*       allows the new values to occupy the Asteroids fields. Some fields have
*       multiple setters denoted by the <OPTION> tag, such as the PVector 
*       fields that allow finer control over some of the Asteroids data.
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
  
//METHODS - THESE METHODS HAVE MORE DESCRIPTION AS THEY ARE SPECIFIC TO CLASS
/*******************************************************************************
* Method: move()
* Parameters: NONE
* Returns: NONE
* Desc: Calculates the trajectory of the asteroids and moves them around
*       the play area. When the asteroids leave the play area, it is moved
*       back onto the play area on the opposite side of the screen.
*******************************************************************************/
  void move(){
    if(!this.getIsDead()){
      //Determine velocity of asteroid using trigonometry.
      this.setVelocity(cos(this.getBearing()) * this.getSpeed(), 
                      sin(this.getBearing()) * this.getSpeed());

      this.getLocationV().add(this.getVelocityV());
      //Asteroids wrap around the play area.
      if(this.getLocationX() > width + (this.getSize() / 2)) {
        this.location.x = 0 - (this.getSize() / 2);
      }
      if(this.getLocationX() < 0 - (this.getSize() / 2)) {
        this.location.x = width + (this.getSize() / 2);
      }
      if(this.getLocationY() > height + (this.getSize() / 2)) {
        this.location.y = 0 - (this.getSize() / 2);
      }
      if(this.getLocationY() < 0 - (this.getSize() / 2)) {
        this.location.y = height + (this.getSize() / 2);
      }
    }
  }
  
/*******************************************************************************
* Method: display()
* Parameters: NONE
* Returns: NONE
* Desc: Draws the asteroids designated PShape field to the screen at the
*       asteroids current location.
*******************************************************************************/  
  void display(){
    if(!this.getIsDead()){
        shape(this.polygon, this.getLocationX(),this.getLocationY());
    }
  }

/*******************************************************************************
* Method: destroy()
* Parameters: ArrayList of Asteroid Objects - astArr
*             Game Object - runThru
* Returns: NONE
* Desc: When executed, increments the score by the number determined by its
*       score field. If the asteroid is large enough, given its size field,
*       The current location becomes the spawn point for two new asteroids that
*       increase in speed by 33%, halve in size and double in score value.
*       After the two new asteroids have been created, this asteroid is removed
*       from the array.
*******************************************************************************/  
  void destroy(ArrayList astArr, Game runThru){
    runThru.setScore(runThru.getScore() + this.getScore());
    if(this.getSize() >= 50){
      float spawnPointX = this.getLocationX();
      float spawnPointY = this.getLocationY();
      float spawnSpeed = this.getSpeed() * 1.3;
      int spawnSize = this.getSize() / 2;
      int spawnScore = this.getScore() * 2;
      //Two new asteroids are created and added to the array with specific
      //field values. FIRST Asteroid "Child"
      astArr.add(new Asteroid(spawnPointX, spawnPointY, random(0, TWO_PI), 
      spawnSpeed, false,  spawnSize, spawnScore));
      //SECOND Asteroid "Child"
      astArr.add(new Asteroid(spawnPointX, spawnPointY, random(0, TWO_PI), 
      spawnSpeed, false,  spawnSize, spawnScore));
    }
    astArr.remove(this);
  }

/*******************************************************************************
* Method: initPolygon()
* Parameters: float - radius
*             int - nPoints
* Returns: PShape - for polygon field.
* Desc: When a new asteroid is created, it uses this method to randomly
*       generate its shape to be drawn to the screen. 
*       FURTHER NOTE: The larger the asteroid the more circular it will appear.
*******************************************************************************/  
  PShape initPolygon(float radius, int nPoints){
    PShape temp;
    temp = createShape();
    temp.beginShape();
    temp.noFill();
    temp.strokeWeight(1);
    temp.stroke(255);
    float angle = TWO_PI / nPoints;
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
