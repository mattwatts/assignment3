class Explosion{
  PVector location;
  
  float radius;
  
  Explosion(float iXLoc, float iYLoc){
    this.location = new PVector(iXLoc, iYLoc);
    this.radius = 1;
  }
  
  //Setters and Getters
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
