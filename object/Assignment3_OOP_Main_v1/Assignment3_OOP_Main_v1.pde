/*******************************************************************************
  COSC101 - Assignment 03 - Asteroids!
  Authors: Christopher Davidson, Matthew Watts, Marcus Girard
  Student Numbers: CHRIS - 220149871, MATT - 9102134,<MARCUS' STUDENT NO>
  Course: COSC101 - Software Development Studio 1
  Desc: Asteroids Game, modelled after the ATARI 2600 version of 1974.
        A ship moves around the screen with UP,DOWN,LEFT and RIGHT Keys.
        The ship fires projectiles with the SPACE Key.
        When the game is "paused", players can resume with the ENTER Key.
        Asteroids drift around the screen.
        The ship can destroy the asteroids, spawning two more medium asteroids.
        These asteroids, when destroyed, spawn two small asteroids.
        An alien ship will appear on the top or bottom of the screen and shoot
        at the player. Forcing the player to move around the screen.
  Usage: To complie and run, load this .pde file in processing IDE, 
        click the "Play" button or press ctrl-r. Written in processing 3.3.7
        on a Windows 10 OS platform.
  Features: Asteroid and Alien Ship Explosions.
            Ship moves with PVector calculations.
            Ship can accelerate forwards and backwards.
            Visible exhaust graphics.
            Irregular and randomly generated asteroid shapes using PShapes.
            Large to medium to small asteroids.
            Smaller asteroids earn the player more score points.
            Smaller asteroids move faster around the screen.
            More asteroids are spawned on each level.
            Player has multiple, (with a max of six) lives.
            Player resets to center on new life and new level.
            Game waits for a clear center of screen before respawn.
            Player can fire rapid projectiles on each press of SPACE key.
            Projectiles disappear offscreen - More strategic player placing.
*******************************************************************************/

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
  
  //Initilise objects and object Arrays
  instance = new Game();
  playerOne = new Ship(true);
  nuisance = new AlienShip();
  enemies = new ArrayList();
  shots = new ArrayList();
  alienShots = new ArrayList();
  detonations = new ArrayList();
  
  //Initialise Asteroids and Controls
  instance.initAsteroids(enemies);
  initKeys();
}

void draw(){
  background(0);
  
  // Allows multiple key presses for more fluid interactivity.
  processKeyPress();
  
  //Drawn To Screen
  moveAndDisplayPlayer();
  moveAndDisplayAsteroid();
  moveAndDisplayAlien();
  moveAndDisplayLaser(shots);
  moveAndDisplayLaser(alienShots);
  displayExplosions();
  
  // Check Game State before Collisions
  checkPlayer();
  checkLaser(shots);
  checkLaser(alienShots);
  
  // Collision Detections
  // Between player and asteroids.
  detectShipCollision(playerOne, enemies);
  // Between player and alien ship
  detectShipCollision();
  // Between player lasers and asteroids
  detectLaserCollision(shots, enemies, detonations);
  // Between player lasers and alien ship
  detectLaserCollision(shots, nuisance, detonations);
  // Between alien lasers and the player
  detectLaserCollision(alienShots, playerOne);
  
  // Check Game State after Collisions
  checkAlienSpawn();
  checkAlienFire();
  checkGame();
  
  // GAME LABELS
  instance.displayLifeLabel();
  instance.displayLevelLabel();
  instance.displayScoreLabel();
}

/*******************************************************************************
* Function: processKeyPress()
* Parameters: NONE
* Returns: NONE
* Desc: Allows for multiple keypresses to be registered simultaneously.
    key presses change a global boolean value which is then taken into
    this function and depending what keys are true, executes the movement
    controls of the ship.
*******************************************************************************/
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

/*******************************************************************************
* Function: moveAndDisplayPlayer()
* Parameters: NONE
* Returns: NONE
* Desc: First determines if the player is "dead" or not, in the case that the
*       player is alive, the ship is drawn to the screen and then its data is
*       changed for the next iteration of draw().
*******************************************************************************/
void moveAndDisplayPlayer(){
  if(!playerOne.getIsDead()){
    playerOne.display();
    playerOne.move();
  }
}

/*******************************************************************************
* Function: moveAndDisplayAsteroid()
* Parameters: NONE
* Returns: NONE
* Desc: Iterates over the asteroid array using an enhanced loop.
*       For each asteroid, it is drawn to the screen and then its data is
*       changed for the next interation of draw()
*******************************************************************************/
void moveAndDisplayAsteroid(){
  for(Asteroid asteroid : enemies){
    if(!asteroid.getIsDead()){
      asteroid.display();
      asteroid.move();
    }
  }
}

/*******************************************************************************
* Function: moveAndDisplayAlien()
* Parameters: NONE
* Returns: NONE
* Desc: First checks to see if the alien ship has spawned. In the case it is
*       in play, the alien ship is drawn to the screen and then its data
*       changed for the next iteration of draw()
*******************************************************************************/
void moveAndDisplayAlien(){
  if(nuisance.getSpawned()){
    nuisance.display();
    nuisance.move();
  }
}

/*******************************************************************************
* Function: moveAndDisplayLaser()
* Parameters: ArrayList of Laser Objects - source
* Returns: NONE
* Desc: Iterates over the given source of Lasers using an enhanced loop.
*       Then changes its colour depending if it is an Alien shot or a players.
*       The laser shot is then drawn to the screen and its data changed for 
*       the next iteration of draw()
*******************************************************************************/
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

/*******************************************************************************
* Function: checkPlayer()
* Parameters: NONE
* Returns: NONE
* Desc: First, it determines if the player is dead. In the case that it is,
*       The function proceeds to decrement the games "lives", determines if
*       the game is over and in the case that it isn't, then proceeds to
*       construct a new ship for the player and place it in the center.
*******************************************************************************/
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

/*******************************************************************************
* Function: checkLaser()
* Parameters: ArrayList of Lasers - lasArr
* Returns: NONE
* Desc: Iterates over the array of laser objects and determines if it is within
*       the play area. In the case it is not, it is removed from the array.
*******************************************************************************/
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

/*******************************************************************************
* Function: detectLaserCollision() 
* Parameters: ArrayList of Laser Objects - projectile
*             ArrayList of Asteroid Objects - ast
*             ArrayList of Explosion Objects - hit
* Returns: NONE
* Desc: Iterates over the array of laser objects and determines its distance
*       from every asteroid in play. If the distance is within a specific range
*       (given some tolerance), the laser and asteroid are removed from their
*       respective arrays, An explosion object is then added to its array.
*******************************************************************************/
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

/*******************************************************************************
* Function: detectLaserCollision()
* Parameters: ArrayList of Laser Objects - projectile
*             AlienShip object - target
*             ArrayList of Explosion Objects
* Returns: NONE
* Desc: Iterates over the players laser array and determines its distance from
*       the alien ship object. In the event that this distance is within a 
*       specific range (given some tolerance), An explosion object is added to
*       its array and a "life" is added to the game (given it is under the max)
*       the score value that controls whether an alien ship is spawned is
*       updated and a new alien ship object if created outside of the play
*       area to be spawned.
*******************************************************************************/
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

/*******************************************************************************
* Function: detectLaserCollision()
* Parameters: ArrayList of alien ships Laser Objects - alienProjectile
*             Players Ship Object - target
* Returns: NONE
* Desc: First, determines if an alien ship has spawned, the iterates over the 
*       alien laser array, determines the distance between the laser and the
*       players ship and if the laser is within a certain distance (given a 
*       tolerance) the players ship is determined to be dead, the laser is
*       removed from its relevant array and a message is set for respawn.
*******************************************************************************/
// Detect laser collision from alien ship to player
void detectLaserCollision(ArrayList alienProjectile, Ship target){
  if(target.getSpawned() && !nuisance.getLaser() && alienProjectile.size() > 0){
    for(int i = 0; i < alienProjectile.size(); i++){
      int tolerance = 5;
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

/*******************************************************************************
* Function: displayExplosions()
* Parameters: NONE
* Returns: NONE
* Desc: Iterates over the explosion objects within its relevant array, displays
*       the explosion and changes its radius data for the next iteration of 
*       draw()
*******************************************************************************/
void displayExplosions(){
  if(detonations.size() > 0){
    for(int i = 0; i < detonations.size(); i++){
      Explosion currentExp = (Explosion)detonations.get(i);
      currentExp.display();
      currentExp.grow(detonations);
    }
  }
}

/*******************************************************************************
* Function: checkGame() 
* Parameters: NONE
* Returns: NONE
* Desc: Determines the current state of the game, in the case all asteroids
*       are destroyed, the levelComplete() function is executed. In the event
*       that the ship is destroyed but still has lives, the levelRespawn() is
*       executed. In the case that the ship is destoryed and has no lives
*       remaining, the game objects "gameOver" variable is set to true and
*       the games endFrame method is called.
*******************************************************************************/
void checkGame(){
  //In the event all the asteroids are destroyed.
  if(enemies.size() <= 0){
    levelComplete();
  }
  //In the event the ship is destroyed but still has lives.
  if(playerOne.getSpawned() == false){
    levelRespawn();
  }
  //In the event that the ship is destroyed and the ship has no lives.
  if(instance.getGameOver()){
    instance.endFrame();
    noLoop();
  }
}

/*******************************************************************************
* Function: levelComplete()
* Parameters: NONE
* Returns: NONE
* Desc: In the event that all asteroids are destroyed, the games level is
*       incremented, a game message is set and new asteroids are initiated.
*       the screen is reset and the readyFrame() is called to pause the game 
*       until the player is ready and presses the ENTER key.
*******************************************************************************/
void levelComplete(){
  instance.setLevel(instance.getLevel() + 1);
  instance.setGameState("New Level: " + nf(instance.getLevel(), 2));
  instance.initAsteroids(enemies);
  resetScreen();
  instance.readyFrame();
}

/*******************************************************************************
* Function: levelRespawn()
* Parameters: NONE
* Returns: NONE
* Desc: In the event that the players ship has been destroyed and still has
*       lives, the screen is reset and the center of the play area is 
*       determined to be clear or not. If the center is clear, the game pauses
*       and the player can resume play with the ENTER Key. If the center is
*       not clear, a wait screen is drawn until the asteroids move from the
*       center and then the readyFrame() method is executed.
*******************************************************************************/
void levelRespawn(){
  resetScreen();
  if(instance.clearCenter(enemies)){
    playerOne.setSpawned(true);
    instance.readyFrame();
  }else{
    instance.waitFrame();
  }
}

/*******************************************************************************
* Function: resetScreen()
* Parameters: NONE
* Returns: NONE
* Desc: Game elements that exclude Laser Objects and thier arrays are redrawn
*       to the screen along with a game state message that informs the player
*       as to why the players ship was destroyed and the game has paused.
*******************************************************************************/
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

/*******************************************************************************
* Function: checkAlien()
* Parameters: NONE
* Returns: NONE
* Desc: If no alien has already been spawned, determines if the players score
*       is greater then a specified value (initially 2500 points). If it is
*       then two random values are generated for a chance to spawn an alien.
*       In the case it fails, this value is incremented and checked when the
*       players score once again is greater than a new value.
*******************************************************************************/
void checkAlienSpawn(){
  if(!nuisance.getSpawned() && instance.getScore() >= instance.getScoreCheck()){
    int alienSpawnRandOne = int(random(101));
    int alienSpawnRandTwo = int(random(101));
    if(alienSpawnRandOne >= 50 && alienSpawnRandTwo <= 50){
      nuisance.initAlien();
    }else{
      instance.setScoreCheck(instance.getScoreCheck() + 300);
    }
  }
}

/*******************************************************************************
* Function: checkAlienFire()
* Parameters: NONE
* Returns: NONE
* Desc: Determines if the X location of the Alien ship is within a specified
*       range around the players ship X location. In the case it is, the alien
*       ship fires its laser.
*******************************************************************************/
void checkAlienFire(){
  int tolerance = 5;
  if(nuisance.getSpawned() && 
  //If alien ship is between the tolerance points on either side of player.
  int(nuisance.getLocationX()) <= int(playerOne.getLocationX() + tolerance) &&
  int(nuisance.getLocationX()) >= int(playerOne.getLocationX() - tolerance)){

     nuisance.fireLaser(alienShots);
  }
}

/*******************************************************************************
* Function: detectShipCollision()
* Parameters: NONE
* Returns: NONE
* Desc: When an alien ship is spawned, the distance between the players ship
*       and the alien ship is determined and if this distance is less than a
*       specified range (given a tolerance) the players ship is determined to
*       be "dead" and a new alien ship is initiated outside the play area.
*       the value that determines a new alien spawn is incremented and a new
*       game message is set.
*******************************************************************************/
void detectShipCollision(){
  if(nuisance.getSpawned() == true){
    int tolerance = 2;
    float plyrX = playerOne.getLocationX();
    float plyrY = playerOne.getLocationY();
    float alienShipX = nuisance.getLocationX();
    float alienShipY = nuisance.getLocationY();
    float distance = dist(plyrX, plyrY, alienShipX, alienShipY);
    if(distance <= (playerOne.getSize()/2) + (nuisance.getSize()/2) + tolerance){
      playerOne.setIsDead(true);
      nuisance = new AlienShip();
      instance.setScoreCheck(instance.getScore() + 2500);
      instance.setGameState("Hit by Alien Ship");
    }
  }
}

/*******************************************************************************
* Function: detectShipCollision()
* Parameters: players Ship Object - plyr
*             ArrayList of Asteroid Objects - ast
* Returns: NONE
* Desc: First, determines that the player has spawned. Then iterates over the
*       array of asteroids, determining a distance from it to the players ship.
*       If this distance is less than a given range (given a tolerance), the
*       players ship is determined to be dead, the asteroid is destroyed and
*       a new game message is set.
*******************************************************************************/
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

/*******************************************************************************
* Function: initKeys()
* Parameters: NONE
* Returns: NONE
* Desc: initialises the control variables used for player movement.
*******************************************************************************/
void initKeys(){
  upPressed = false;
  downPressed = false;
  leftPressed = false;
  rightPressed = false;
}

/*******************************************************************************
* Function: keyPressed()
* Parameters: NONE
* Returns: NONE
* Desc: Special Processing Function for Keyboard interactivity.
*       When the game is running and the players ship is spawned the controls
*       are active. The ships fire method is available with the SPACE Key.
*       When the game is paused from the readyFrame() or waitFrame() methods,
*       the ENTER key is used to resume play.
*******************************************************************************/
void keyPressed(){
  if(!instance.getPaused() || playerOne.getSpawned()){
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

/*******************************************************************************
* Function: keyReleased()
* Parameters: NONE
* Returns: NONE
* Desc: Special Processing Function for Keyboard Interactivity.
*       On the release of ARROW Keys, the movement control variables deactivate
*       and the players ships exhaust is turned off. The players ship is unable
*       to fire after an initial firing of the laser and the release of the
*       SPACE key reactivates the ships laser to be fired with keyPressed().
*******************************************************************************/
void keyReleased(){
  if(!instance.getPaused() || playerOne.getSpawned()){
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
