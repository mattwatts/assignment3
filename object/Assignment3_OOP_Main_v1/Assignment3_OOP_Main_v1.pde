// Game Elements
Game instance;
Ship playerOne;
AlienShip nuisance;
ArrayList<Asteroid> enemies;
ArrayList<Laser> shots;
ArrayList<Laser> alienShots;
ArrayList<Explosion> detonations;

//Control variables
boolean  upPressed,
         downPressed,
         leftPressed,
         rightPressed;

void setup(){
  size(1200, 900);
  frameRate(60);
  
  instance = new Game();
  playerOne = new Ship(true);
  nuisance = new AlienShip();
  enemies = new ArrayList();
  shots = new ArrayList();
  alienShots = new ArrayList();
  detonations = new ArrayList();
  
  instance.initAsteroids(enemies);
  initKeys();
}

void draw(){
  background(0);
  
  processKeyPress();
  
  moveAndDisplayPlayer();
  moveAndDisplayAsteroid();
  moveAndDisplayAlien();
  moveAndDisplayLaser(shots);
  moveAndDisplayLaser(alienShots);
  
  checkPlayer();
  checkLaser(shots);
  
  detectShipCollision(playerOne, enemies);
  detectShipCollision();
  detectLaserCollision(shots, enemies, detonations);
  detectLaserCollision(shots, nuisance, detonations);
  detectLaserCollision(alienShots, playerOne);
  
  displayExplosions();
  
  checkAlien();
  checkGame();
  
  // GAME LABELS
  instance.displayLifeLabel();
  instance.displayLevelLabel();
  instance.displayScoreLabel();
}

void processKeyPress(){
  if(upPressed){
    playerOne.accelerate("FORWARD");
  }
  
  if(downPressed){
    playerOne.accelerate("BACKWARD");
  }
  
  if(rightPressed){
    playerOne.turn("RIGHT");
  }
  
  if(leftPressed){
    playerOne.turn("LEFT");
  }
}

void moveAndDisplayPlayer(){
  if(!playerOne.getIsDead()){
    playerOne.display();
    playerOne.move();
  }
}

void moveAndDisplayAsteroid(){
  for(Asteroid asteroid : enemies){
    if(!asteroid.getIsDead()){
      asteroid.display();
      asteroid.move();
    }
  }
}

void moveAndDisplayAlien(){
  if(nuisance.getSpawned()){
    nuisance.display();
    nuisance.move();
  }
}

void moveAndDisplayLaser(ArrayList<Laser> source){
  for(Laser l : source){
    if(source == alienShots){
      stroke(255,255,0);
    }else{
      stroke(255);
    }
    l.display();
    l.move();
  }
}

void checkPlayer(){
  if (playerOne.getIsDead() == true){
    instance.setLives(instance.getLives() - 1);
    if(instance.getLives() == 0){
      instance.setGameOver(true);
    }
    playerOne = new Ship(false);
    playerOne.resetShip();
  }
}

void checkLaser(ArrayList lasArr){
  for(int i = 0; i < lasArr.size(); i++){
    Laser currentLas = (Laser)lasArr.get(i);
    if(currentLas.getLocationX() > width || currentLas.getLocationX() < 0){
      currentLas.removeShot(lasArr);
    }
    if(currentLas.getLocationY() > height || currentLas.getLocationY() < 0){
      currentLas.removeShot(lasArr);
    }
  }
}

// Detect laser collision with asteroids.
void detectLaserCollision(ArrayList projectile, ArrayList ast, ArrayList hit){
  for(int i = 0; i < projectile.size(); i++){
    int tolerance = 5;
    Laser currentLas = (Laser)projectile.get(i);
    for(int j = 0; j < ast.size(); j++){
      Asteroid currentAst = (Asteroid)ast.get(j);
      float lasX = currentLas.getLocationX();
      float lasY = currentLas.getLocationY();
      float astX = currentAst.getLocationX();
      float astY = currentAst.getLocationY();
      float distance = dist(lasX,lasY,astX,astY);
      if(distance <= ((currentAst.getSize() / 2) + tolerance)){
        hit.add(new Explosion(astX,astY));
        currentAst.destroy(ast, instance);
        currentLas.removeShot(projectile);
      }
    }
  }
}

// Detect laser collision with alien ship
void detectLaserCollision(ArrayList projectile, AlienShip target, ArrayList hit){
  for(int i = 0; i < projectile.size(); i++){
    int tolerance = 3;
    Laser currentLas = (Laser)projectile.get(i);
    float lasX = currentLas.getLocationX();
    float lasY = currentLas.getLocationY();
    float alienShipX = target.getLocationX();
    float alienShipY = target.getLocationY();
    float distance = dist(lasX, lasY, alienShipX, alienShipY);
    if(distance <= (target.getSize() / 2) + tolerance){
      hit.add(new Explosion(alienShipX, alienShipY));
      if(instance.getLives() < 6){
        instance.setLives(instance.getLives() + 1);
      }
      instance.setScoreCheck(instance.getScore() + 2500);
      instance.setScore(instance.getScore() + 200);
      nuisance = new AlienShip();
    }
  }
}

// Detect laser collision from alien ship to player
void detectLaserCollision(ArrayList alienProjectile, Ship target){
  if(target.getSpawned() && !nuisance.getLaser() && alienProjectile.size() > 0){
    for(int i = 0; i < alienProjectile.size(); i++){
      int tolerance = 3;
      Laser currentLas = (Laser)alienProjectile.get(i);
      float lasX = currentLas.getLocationX();
      float lasY = currentLas.getLocationY();
      float shipX = target.getLocationX();
      float shipY = target.getLocationY();
      float distance = dist(lasX, lasY, shipX, shipY);
      if(distance <= (target.getSize() / 2) + tolerance){
        target.setIsDead(true);
        currentLas.removeShot(alienProjectile);
        instance.setGameState("Hit by Alien Laser");
      }
    }
  }
}

void displayExplosions(){
  if(detonations.size() > 0){
    for(int i = 0; i < detonations.size(); i++){
      Explosion currentExp = (Explosion)detonations.get(i);
      currentExp.display();
      currentExp.grow(detonations);
    }
  }
}

void checkGame(){
  //In the event all the asteroids are destroyed.
  if(enemies.size() <= 0){
    levelComplete();
  }
  //In the event the ship is destroyed but still has lives
  if(playerOne.getSpawned() == false){
    levelRespawn();
  }
  //In the event that the ship is destroyed and the ship has no lives = GAME OVER.
  if(instance.getGameOver()){
    instance.endFrame();
    noLoop();
  }
}

void levelComplete(){
  instance.setLevel(instance.getLevel() + 1);
  instance.setGameState("New Level: " + nf(instance.getLevel(), 2));
  instance.initAsteroids(enemies);
  resetScreen();
  instance.readyFrame();
}

void levelRespawn(){
  resetScreen();
  if(instance.clearCenter(enemies)){
    playerOne.setSpawned(true);
    instance.readyFrame();
  }else{
    instance.waitFrame();
  }
}

void resetScreen(){
  background(0);
  instance.gameStateLabel();
  playerOne.resetShip();
  playerOne.display();
  for(Asteroid ast: enemies){
    ast.display();
  }
  if(nuisance.getSpawned()){
    nuisance.display();
  }
}

void checkAlien(){
  if(!nuisance.getSpawned() && instance.getScore() >= instance.getScoreCheck()){
    int alienSpawnRandOne = int(random(101));
    int alienSpawnRandTwo = int(random(101));
    if(alienSpawnRandOne >= 50 && alienSpawnRandTwo <= 50){
      nuisance.initAlien();
    }else{
      instance.setScoreCheck(instance.getScoreCheck() + 200);
    }
  }
  
  int tolerance = 3;
  if(nuisance.getSpawned() && 
  int(nuisance.getLocationX()) <= int(playerOne.getLocationX() + tolerance) &&
  int(nuisance.getLocationX()) >= int(playerOne.getLocationX() - tolerance)){  
     nuisance.fireLaser(alienShots);
  }
}

void detectShipCollision(){
  if(playerOne.getSpawned() == true){
    int tolerance = 2;
    float plyrX = playerOne.getLocationX();
    float plyrY = playerOne.getLocationY();
    float alienShipX = nuisance.getLocationX();
    float alienShipY = nuisance.getLocationY();
    float distance = dist(plyrX, plyrY, alienShipX, alienShipY);
    if(distance <= (playerOne.getSize()/2) + (nuisance.getSize()/2) + tolerance ){
      playerOne.setIsDead(true);
      nuisance = new AlienShip();
      instance.setScoreCheck(instance.getScore() + 2500);
      instance.setGameState("Hit by Alien Ship");
    }
  }
}

void detectShipCollision(Ship plyr, ArrayList ast){
  if(plyr.getSpawned() == true){
    int tolerance = 4;
    for(int i = 0; i < ast.size(); i++){
      Asteroid currentAst = (Asteroid)ast.get(i);
      float plyrX = plyr.getLocationX();
      float plyrY = plyr.getLocationY();
      float astX = currentAst.getLocationX();
      float astY = currentAst.getLocationY();
      float distance = dist(plyrX, plyrY, astX, astY);
      if(distance <= (plyr.getSize()/2) + (currentAst.getSize()/2) + tolerance ){
        plyr.setIsDead(true);
        currentAst.destroy(ast, instance);
        instance.setGameState("Hit by Asteroid");
      }
    }
  }
}

void initKeys(){
  upPressed = false;
  downPressed = false;
  leftPressed = false;
  rightPressed = false;
}

void keyPressed(){
  if(!(instance.getPaused()) || playerOne.getSpawned()){
    if(key == CODED){
      if(keyCode == UP){
        upPressed = true;
      }
      if(keyCode == DOWN){
        downPressed = true;
      }
      if(keyCode == RIGHT){
        rightPressed = true;
      }
      if(keyCode == LEFT){
        leftPressed = true;
      }
    }
    if(key == 32){
      playerOne.fireLaser(shots);
    }  
  }
  if(instance.getPaused()){
    if((key == ENTER) || (key == RETURN)){
      shots = new ArrayList();
      alienShots = new ArrayList();
      detonations = new ArrayList();
      instance.setPaused(false);
      loop();
    }
  }
}

void keyReleased(){
  if(!(instance.getPaused()) || playerOne.getSpawned()){
    if(key == CODED){
      if(keyCode == UP){
        upPressed = false;
        playerOne.setExhaust(false);
      }
      if(keyCode == DOWN){
        downPressed = false;
        playerOne.setExhaust(false);
      }
      if(keyCode == RIGHT){
        rightPressed = false;
      }
      if(keyCode == LEFT){
        leftPressed = false;
      }
    }
    // LASER ON WHEN RELEASE TO LIMIT AUTO FIRING - HOLDING DOWN SPACE BUG.
    if(key == 32){
      playerOne.setLaser(true);
    }
  }
}
