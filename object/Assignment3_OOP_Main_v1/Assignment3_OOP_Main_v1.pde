// IMPLEMENT GRAPHICS BOOLEAN

// Game Elements
Game instance;
Ship playerOne;
ArrayList<Asteroid> enemies;
ArrayList<Laser> shots;
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
  enemies = new ArrayList();
  shots = new ArrayList();
  detonations = new ArrayList();
  
  instance.initAsteroids(enemies);
  initKeys();
}

void draw(){
  background(0);
  processKeyPress();
  
  moveAndDisplayPlayer();
  moveAndDisplayAsteroid();
  moveAndDisplayLaser();
  
  checkPlayer();
  checkLaser(shots);
  
  detectShipCollision(playerOne, enemies);
  detectLaserCollision(shots, enemies, detonations);
  
  displayExplosions();

  checkGame();
  
  //LABELS DRAWN AT THE END OF DRAW() LOOP!!!
  fill(255);
  textSize(16);
  textAlign(LEFT);
  text("Lives: " + instance.getLives(),0,32);
  text("Level: " + instance.getLevel(),0,16);
  text("Score: " + instance.getScore(),0,48);
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

void moveAndDisplayLaser(){
  for(Laser l : shots){
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

void detectLaserCollision(ArrayList projectile, ArrayList ast, ArrayList detonations){
  for(int i = 0; i < projectile.size(); i++){
    Laser currentLas = (Laser)projectile.get(i);
    for(int j = 0; j < ast.size(); j++){
      Asteroid currentAst = (Asteroid)ast.get(j);
      float lasX = currentLas.getLocationX();
      float lasY = currentLas.getLocationY();
      float astX = currentAst.getLocationX();
      float astY = currentAst.getLocationY();
      float distance = dist(lasX,lasY,astX,astY);
      if(distance <= (currentAst.getSize() / 2)){
        detonations.add(new Explosion(astX,astY));
        currentAst.destroy(ast, instance);
        currentLas.removeShot(projectile);
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
    instance.setLevel(instance.getLevel() + 1);
    instance.initAsteroids(enemies);
    //resets screen
    background(0);
    playerOne.resetShip();
    playerOne.display();
    for(Asteroid ast: enemies){
      ast.display();
    }
    shots = new ArrayList();
    detonations = new ArrayList();
    
    instance.readyFrame();
  }
  //In the event the ship is destroyed but still has lives
  if(playerOne.getSpawned() == false){
    playerOne.resetShip();
    playerOne.display();
    shots = new ArrayList();
    if(instance.clearCenter(enemies)){
      playerOne.setSpawned(true);
      instance.readyFrame();
    }else{
      instance.waitFrame();
    }
  }
  //In the event that the ship is destroyed and the ship has no lives = GAME OVER.
  if(instance.getGameOver()){
    instance.endFrame();
    noLoop();
  }
}



void detectShipCollision(Ship plyr, ArrayList ast){
  if(plyr.getSpawned() == true){
    for(int i = 0; i < ast.size(); i++){
      Asteroid currentAst = (Asteroid)ast.get(i);
      float plyrX = plyr.getLocationX();
      float plyrY = plyr.getLocationY();
      float astX = currentAst.getLocationX();
      float astY = currentAst.getLocationY();
      float distance = dist(plyrX, plyrY, astX, astY);
      if(distance <= (plyr.getSize()/2) + (currentAst.getSize()/2) + 2 ){
        plyr.setIsDead(true);
        currentAst.destroy(ast, instance);
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
    instance.setPaused(false);
    loop();
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
    //SO THE PLAYER CANT HOLD DOWN ENTER AND BLINK ALL OVER THE PLACE.
    if((key == ENTER) || (key == RETURN)){
      playerOne.teleport();
    }
    // LASER ON WHEN RELEASE TO LIMIT AUTO FIRING - HOLDING DOWN SPACE BUG.
    if(key == 32){
      playerOne.setLaser(true);
    }
  }
}
