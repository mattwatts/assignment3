class Explosion{
  PVector location;
  
  float radius;
  
  Explosion(){
 
  }
  
  //Setters and Getters
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
  
  void setRadius(float radiusInput){
    this.radius = radiusInput;
  }
  
  float getRadius(){
    float r = this.radius;
    return r;
  }
  
  
  
  //Functions
    //draw
    //place explosion
    //play explosion animation
}
