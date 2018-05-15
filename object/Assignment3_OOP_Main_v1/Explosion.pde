class Explosion{
  //PImage for gFX == true.
  // point array for gFX == false
  PVector location;
  
  float radius;
  
  Explosion(float xpos, float ypos){
    this.location = new PVector(xpos, ypos);
    this.radius = 1;
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
  
  //METHODS
  void display(){
    noStroke();
    fill(#FFAB03, 125);
    ellipse(this.getLocationX(),this.getLocationY(),this.getRadius(),this.getRadius());
  }
  
  void grow(ArrayList explodeList){
    if(this.getRadius() < 250){
      this.setRadius(this.getRadius() + 10);
    }else{
      explodeList.remove(this);
    }
  }
}
