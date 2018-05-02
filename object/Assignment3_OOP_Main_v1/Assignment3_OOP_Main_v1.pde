ArrayList<Asteroid> enemyAL;

void setup(){
  size(900,1200);
  frameRate(30);
  
  int startAsteroidCount = 4;
  initAsteroids(startAsteroidCount, enemyAL);
  
  
}

void draw(){
  background(0);
}

void initAsteroids(int numOfAsteroids, ArrayList asteroidArray){
  for(int i = 0; i < numOfAsteroids; i++){
    asteroidArray.add(new Asteroid());
    Asteroid part = (Asteroid)asteroidArray.get(i);
    // if structre
    part.setLocation(0,0);
  }
}
