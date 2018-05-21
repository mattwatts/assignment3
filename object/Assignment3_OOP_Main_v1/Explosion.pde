/*******************************************************************************
* Class: Explosion
* Fields: Location, Radius
* Methods: display(), grow()
* Desc: Visual effect written for the Asteroids Game, used within an array
*       and only added when a collision is detected. The explosion is created
*       at a specified location and will expand to a set radius.
*******************************************************************************/
class Explosion{
  PVector location;
  
  float radius;
  
/*******************************************************************************
* Constructor: Explosion()
* Parameters: iXLoc, iYLoc
* Returns: NONE
* Desc: Takes in a specified location coordinate for the explosion to occur.
*       starts with a radius of 1 and uses grow() to expand to a set radius.
*******************************************************************************/
  Explosion(float iXLoc, float iYLoc){
    this.location = new PVector(iXLoc, iYLoc);
    this.radius = 1;
  }
  
//SETTERS AND GETTERS - METHOD DESCRIPTIONS ARE GENERALISED FOR ALL OF CLASS
/*******************************************************************************
* Setter(s): set<FieldName><OPTION>()
* Parameters: inputs - denoted with an 'i' prefix.
* Returns: NONE
* Desc: Setters are used in this class to be used throughout the program. It
*       allows the new values to occupy the Explosions fields. Some fields have
*       multiple setters denoted by the <OPTION> tag, such as the PVector 
*       fields that allow finer control over some of the Explosions data.
*******************************************************************************/
  void setLocationV(float iXLoc, float iYLoc){
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
    PVector eLoc = this.location;
    return eLoc;
  }
  
  float getLocationX(){
    float eLocX = this.location.x;
    return eLocX;
  }
  
  float getLocationY(){
    float eLocY = this.location.y;
    return eLocY;
  }
  
  void setRadius(float iRadius){
    this.radius = iRadius;
  }
  
  float getRadius(){
    float eRadius = this.radius;
    return eRadius;
  }

//METHODS - THESE METHODS HAVE MORE DESCRIPTION AS THEY ARE SPECIFIC TO CLASS
/*******************************************************************************
* Method: display()
* Parameters: NONE
* Returns: NONE
* Desc: Draws a semi-transparent ellipse to the screen at its current radius.
*******************************************************************************/  
  void display(){
    noStroke();
    fill(#FFAB03, 125);
    ellipse(this.getLocationX(),this.getLocationY(),this.getRadius(),this.getRadius());
  }
  
/*******************************************************************************
* Method: grow()
* Parameters: ArrayList of Explosion objects - explodeList
* Returns: NONE
* Desc: Increments the current radius of the explosion by a factor of 10 pixels
*       until it reaches a radius of 250 pixels. Where the explosion is then
*       removed from the explosion array.
*******************************************************************************/  
  void grow(ArrayList explodeList){
    if(this.getRadius() < 250){
      this.setRadius(this.getRadius() + 10);
    }else{
      explodeList.remove(this);
    }
  }
}
