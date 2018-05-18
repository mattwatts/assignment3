//cosc101 assessment 3
// Authors: Matthew Watts
// Student Number: 9102134
// Course: COSC101
// Usage: To compile and run the program, load this .pde file in "Processing",
//        and press the run button.
// Purpose: This program implements "Assignment 3 - Asteroids!"
// Further effects:
//   teleport ship
//   ship and asteroid explosions
//   ship moves and accelerates with realistic physics
//   forward and reverse thrust
//   small, medium, and large asteroids
//   smaller asteroids earn more points when shot
//   shot asteroids spawn baby asteroids
//     large spawns 2 medium
//     medium spawns 2 small
//   asteroids get faster on level up
//   visible exhaust from ship thrusters
//   medium asteroids are faster than larger asteroids
//   small asteroids are faster than medium asteroids
//   ship has multiple lives
//   ship resets to stationary at screen centre on new life
//   ship waits until screen centre is clear of asteroids before spawning new life
//   if the spawning waits too long without centre becoming clear, the ship spawns anyway
//   ship can have multiple laser bolts in flight simultaneously
//   there's a slight pause before the ship can fire another laser bolt
//   laser bolts travel for a number of pixels equal to screen height
//   more asteroids appear on level up

        // current location of ship
PVector shipLocation,
        // current velocity of ship
        shipVelocity,
        // location of ship explosion
        shipExplosionLocation,
        // current location of alien ship
        alienLocation,
        // current velocity of alien ship
        alienVelocity,
        // current location of alien laser bolt
        alienLaserLocation,
        // current velocity of alien laser bolt
        alienLaserVelocity,
        // location of alien ship explosion animation
        alienExplosionLocation;
      // current direction (bearing) of ship
float shipDirection,
      // current acceleration of ship
      acceleration;
// current locations of laser bolts
ArrayList<PVector> laserLocation = new ArrayList<PVector>();
// current velocity of laser bolts
ArrayList<PVector> laserVelocity = new ArrayList<PVector>();
// time remaining for laser bolts
ArrayList<Integer> laserOn = new ArrayList<Integer>();
      // determines how fast the laser bolt moves
float laserSpeed = 30,
      // determines how much thrust happens when up and down arrow pressed
      // pixels per frame per frame ship acceleration
      thrustConstant = 0.2,
      // how fast large asteroids move on level 1
      asteroidStartSpeed = 1,
      // how fast asteroid speed increases with difficulty increase
      asteroidSpeedChange = 0.25,
      // how fast alien ship speed increases with difficulty increase
      alienSpeedChange = 0.5,
      // speed of alien laser bolt
      alienLaserSpeed = 5,
      // initial ship direction is up: 1.5 pi radians is up
      initialShipDirection = 1.5*PI;
    // score is zero at start of level 1
int score=0,
    // game starts at level 1
    level=1,
    // how many lives do you have
    lives=4,
    // how many lives are currently remaining?
    livesRemaining = lives,
    // diameter of a laser bolt
    laserSize = 10,
    // how many asteroids does level 1 start with?
    startAsteroidCount = 4,
    // how many extra asteroids on new levels
    asteroidLevelUp = 2,
    // radius size on ship triangle
    shipSize = 10,
    // determines how quickly ship turns when left and right arrow pressed
    shipTurnSpeed = 50,
    // detection radius for "is asteroid close to display centre"
    centreRadius = 100,
    // if the spawning waits too long without centre becoming clear, the ship spawns anyway
    // how many frames must pass before a new ship is forced to spawn
    spawnWaitLimit = 300,
    // gameMode: 0="in progress", 1="waiting to spawn", 2="game over"
    gameMode = 0,
    // how many frames must pass before laser fires again
    laserFireFrames = 5,
    // how many frames have elapsed since laser bolt was fired
    framesSinceFire = laserFireFrames + 1,
    // how many frames must pass before a new game can start
    endGameFrames = 20,
    // stochastic delay before alien ship spawns
    alienSpawnSeconds = 10,
    // size of alien ship
    alienSize = 25,
    // level that alien first appears on
    alienLevel = 2,
    // stochastic delay before alien ship fires laser bolt
    alienLaserSpawnSeconds = 10,
    // size of alien laser bolt
    alienLaserSize = 10,
    // points for shooting alien ship
    scoreAlien = 200;
    // is the ship exhause showing: 0 = not showing, 1 = showing
int exhaust,
    // which ship explosion "frame" is currently displaying
    shipExplosion,
    // how many asteroids currently exist?
    // we set it to startAsteroidCount at start of level 1
    asteroids = startAsteroidCount,
    // how long have we been waiting for new ship to spawn?
    spawnWait,
    // how long have we been waiting for the new game to start
    endGameWait,
    // which alien explosion "frame" is currently showing
    alienExplosion;
        // is the left arrow key down?
boolean leftPressed = false,
        // is the right arrow key down?
        rightPressed = false,
        // is the up arrow key down?
        upPressed = false,
        // is the down arrow key down?
        downPressed = false,
        // is the space key down?
        spacePressed = false,
        // is an alien ship visiting?
        alienOn = false,
        // is an alien laser firing?
        alienLaserOn = false;
       // says what happened with game result
String gameResult;
// current position of asteroid
ArrayList<PVector> asteroidPosition = new ArrayList<PVector>();
// is the asteroid dead?
ArrayList<Boolean> asteroidDead = new ArrayList<Boolean>();
// current direction (bearing) of asteroid
ArrayList<Float> asteroidDirection = new ArrayList<Float>();
// current size of asteroid: small=2, medium=1, large=0
ArrayList<Integer> asteroidSize = new ArrayList<Integer>();
// which asteroid explosion "frame" is currently displaying
ArrayList<Integer> asteroidExplosion =  new ArrayList<Integer>();
// how fast is the asteroid travelling
ArrayList<Float> asteroidSpeed =  new ArrayList<Float>();
// diameter for each asteroid circle: large=100, medium=50, small=25
int[] asteroidSizes = {75,50,25};
// how many points for shooting each asteroid size: large=25, medium=50, small=100
int[] scores = {25,50,100};
// each element of this array is a ship explosion "frame"
// a frame is a circle of specified diameter
// frames can be added/removed by simply growing or shrinking this fixed size array
int[] shipExplosions = {500,450,400,350,300,250,200,150,100,50};
// each element of this array is an asteroid explosion "frame"
int[] asteroidExplosions = {250,225,200,175,150,125,100,75,50,25};
// each element of this array is an alien explosion "frame"
int[] alienExplosions = {250,225,200,175,150,125,100,75,50,25};

void setup(){
// Purpose: initialise the game
  
  size(500,650);
  
  // set the font size for displaying score
  textSize(26);

  // initial ship direction is up: 1.5 pi radians is up
  shipDirection = initialShipDirection;
  
  frameRate(30);
  
  // initialise game variables and start the game
  initGame();
  restartGame();
}

void draw(){
// Purpose: draw a frame of the game
  
  // set a black background to draw on
  background(0);

  // spawn new ship
  waitToSpawn();
  
  // process key presses so user interface responds to user input on each frame
  processKeyPress();
  
  // draw laser bolt and ship
  drawLaser();
  drawShip();
  
  // draw remaining elements of the game composition
  drawAsteroids();
  drawAlienLaser();
  drawAlien();
  drawScore();
  drawExplosion();
  drawLives();
  
  // display game over messages
  drawGameOver();
  
  // move the ship and laser bolt
  moveShip();  
  moveLaser();
  
  // move the asteroids, alien, and alien laser bolt
  moveAsteroids();
  moveAlien();
  moveAlienLaser();
    
  // detect collision between lasers and asteroids, alien, ship
  detectLaserCollision();
    
  // detect collision between ship and asteroids, alien
  detectShipCollision();
}

void initGame() {
// Purpose: initialise the PVectors
  // pass 2 parameters to the PVector constructors so processing knows they're 2 dimensional
  shipLocation = new PVector(0,0); 
  shipExplosionLocation = new PVector(0,0);
  alienLocation = new PVector(0,0);
  alienVelocity = new PVector(0,0);
  alienExplosionLocation = new PVector(0,0);
  alienLaserLocation = new PVector(0,0);
  alienLaserVelocity = new PVector(0,0);
}

void restartGame() {
// Purpose: start or restart the game
  
  // the ship is not moving
  shipVelocity = new PVector(0,0);
  
  // the ship is in the centre of the screen
  shipLocation.x = width/2;
  shipLocation.y = height/2;
  
  // set game state to "in progress"
  gameMode = 0;
  // set laser to "not firing"
  //laserOn = false;
  // set exhaust to off
  exhaust = 0;
  // set ship expolosion animation to off
  shipExplosion = 0;
  
  // initialise the asteroids location, direction, status and sizes
  initAsteroids();  
}

void drawGameOver() {
// Purpose: draw the game over message
  
  if (gameMode == 2) {
    // game mode is "game over"
    // set text colour blue
    fill(0,0,255);
    // display game over messages
    text("Game over",width/2-60,height/2-20);
    text("Press any key to restart",width/2-130,height/2+10);
    
    // increment end game timer
    endGameWait++;
  }
}

void drawScore() {
// Purpose: draw the score

  // set text colour blue
  fill(0,0,255);
  
  // write the score
  text(score,10,30);
  text("Level " + level,10,60);
  //text("lives: " + livesRemaining,10,90);
}

void drawLives() {
// Purpose: draw the number of lives remaining as ship icons

 // colour is green
 fill(0,255,0);
 pushMatrix();
 translate(1,1);
 // draw an icon for each spare ship life remaining
 for (int i=0;i<livesRemaining-1;i++) {
   drawPolygon(20+(i*20),80, shipSize, 3);
 }
 popMatrix(); 
}

void initAsteroids() {
// Purpose: create new asteroid set for the start of a level
  float theDirection, theSpeed;
  boolean isDead = false;
  int theSize = 0, // asteroid is large size
      theExplosion = 0; // asteroid is not exploding
  
  asteroids = startAsteroidCount + ((level - 1) * asteroidLevelUp);  
  asteroidPosition.clear();
  asteroidDead.clear();
  asteroidDirection.clear();
  asteroidSize.clear();
  asteroidExplosion.clear();
  asteroidSpeed.clear();
  
  // initialise the asteroids location, direction, status and sizes
  for (int i=0;i<asteroids;i++) {
    PVector thePosition = new PVector(0,0);
    
    // make random direction of asteroid close to up or down
    // so initially the ship is not in its path
    if (random(2) < 1) {
      // asteroid direction close to up 50% of the time
      theDirection = random(1.4*PI,1.6*PI);    
    } else {
      // asteroid direction close to down 50% of the time
      theDirection = random(0.4*PI,0.6*PI);          
    }
    // make random x of asteroid close to left or right side of screen
    // so initially the ship is not in its path
    if (random(2) < 1) {
      // asteroid position close to left of screen 50% of the time
      thePosition.x = random(0,width/4);
    } else {
      // asteroid position close to right of screen 50% of the time
      thePosition.x = random(width*0.75,width);
    }
    // random y can be anywhere on the screen
    thePosition.y = random(height);
    
    // speed of large asteroids increases by asteroidSpeedChange on each level
    theSpeed = asteroidStartSpeed + ((level-1) * asteroidSpeedChange);
    
    // add values for this asteroid to the arrays
    asteroidPosition.add(thePosition);
    asteroidDead.add(isDead);
    asteroidDirection.add(theDirection);
    asteroidSize.add(theSize);
    asteroidExplosion.add(theExplosion);
    asteroidSpeed.add(theSpeed);
  }
}

void drawAsteroids() {
// Purpose: draw asteroids
  boolean isDead;
  int theSize;
  PVector thePosition = new PVector(0,0);
  
  for (int i=0;i<asteroids;i++) {
    isDead = asteroidDead.get(i);
    
    if (! isDead) {
      fill(120,120,120);
      thePosition = asteroidPosition.get(i);
      theSize = asteroidSize.get(i);
      
      ellipse(thePosition.x,thePosition.y,
              asteroidSizes[theSize],
              asteroidSizes[theSize]);
    }
  }
}

void moveAsteroids() {
// Purpose: move the asteroids
  float theDirection, theSpeed;
  boolean isDead;
  PVector thePosition = new PVector(0,0);
  
  for (int i=0;i<asteroids;i++) {
    isDead = asteroidDead.get(i);
    
    if (! isDead) {
      thePosition = asteroidPosition.get(i);
      theDirection = asteroidDirection.get(i);
      theSpeed = asteroidSpeed.get(i);
      
      // move asteroid
      thePosition.x += cos(theDirection)*theSpeed;
      thePosition.y += sin(theDirection)*theSpeed;
      
      // wrap asteroid around the edges of the screen
      if (thePosition.x > (width-1)) {
        thePosition.x -= width;
      }
      if (thePosition.x < 0) {
        thePosition.x += width;
      }
      if (thePosition.y > (height-1)) {
        thePosition.y -= height;
      }
      if (thePosition.y < 0) {
        thePosition.y += height;
      }
      
      asteroidPosition.set(i,thePosition);
    }
  }
}

void accelerateShip() {
// Purpose: accelerate or decelerate the ship
  
  // calculate the acceleration
  PVector shipAcceleration;
  shipAcceleration = new PVector(cos(shipDirection),sin(shipDirection));
  shipAcceleration.setMag(acceleration);
  
  // update the velocity
  shipVelocity.add(shipAcceleration);
  
  exhaust = 1;
}

void moveShip() {
// Purpose: move the ship
  if (gameMode == 0) {
    // game mode is "in progress"
    // move the ship
    // update ship location
    shipLocation.add(shipVelocity);
  
    // wrap ship around the edges of the screen
    if (shipLocation.x > (width-1)) {
      shipLocation.x -= width;
    }
    if (shipLocation.x < 0) {
      shipLocation.x += width;
    }
    if (shipLocation.y > (height-1)) {
      shipLocation.y -= height;
    }
    if (shipLocation.y < 0) {
      shipLocation.y += height;
    }
  }
}

void teleportShip() {
// Purpose: teleport ship to a random location
  
  // set all keys to up before teleport
  initKeys();
  
  // ship teleports to a random location
  shipLocation.x = random(4,width-6);
  shipLocation.y = random(4,height-6);
  
  // ship is standing still
  shipVelocity.x = 0;
  shipVelocity.y = 0;
}

void drawExhaust() {
// Purpose: draw a rocket exhaust for the ship
  fill(255,0,0);
  if (upPressed) {
    // draw a rocket exhaust behind the ship
    triangle((-1*shipSize/2),-4,(-1*shipSize/2),4,-30,0);
  }
  if (downPressed) {
    // draw a rocket exhaust in front of the ship
    triangle(shipSize/2,-4,shipSize/2,4,30,0);    
  }
  exhaust = 0;
}

void drawShip() {
// Purpose: draw the ship
  if (gameMode == 0) {
    // game mode is "in progress"
    // draw a triangle centred on xLoc,yLoc
    // later, we'll substitute an image instead of a triangle
    // https://processing.org/examples/regularpolygon.html
    pushMatrix();
    translate(shipLocation.x, shipLocation.y);
    rotate(shipDirection);
    if (exhaust > 0) {
      drawExhaust();
    }
    fill(0,255,0);
    drawPolygon(0, 0, shipSize, 3);  // Triangle
    popMatrix();
  }
}

void drawShipExplosion() {
// Purpose: draw frame of ship explosion animation
  if (shipExplosion > 0) {
    // colout is red
    fill(255,0,0);
    // draw frame of ship explosion animation
    ellipse(shipExplosionLocation.x,shipExplosionLocation.y,
            shipExplosions[shipExplosion-1],shipExplosions[shipExplosion-1]);
    // move to next frame of the ship explosion animation
    shipExplosion--;
  }  
}

void drawAsteroidExplosion() {
// Purpose: draw frame of asteroid explosion animation
  int theExplosion;
  PVector thePosition = new PVector(0,0);

  // draw frame of asteroid explosion animation
  for (int i=0;i<asteroids;i++) {
    theExplosion = asteroidExplosion.get(i);
    
    if (theExplosion > 0) {
      thePosition = asteroidPosition.get(i);
      
      // colour is green
      fill(0,255,0);
      // draw frame of asteroid explosion animation
      ellipse(thePosition.x,thePosition.y,
              asteroidExplosions[theExplosion-1],asteroidExplosions[theExplosion-1]);
              
      // move to next frame of the asteroid explosion animaiton
      theExplosion--;
      asteroidExplosion.set(i,theExplosion);
    }
  }
}

void drawAlienExplosion() {
// Purpose: draw frame of alien explosion animation
  if (alienExplosion > 0) {
    // colout is red
    fill(255,0,0);
    // draw frame of alien explosion animation
    ellipse(alienExplosionLocation.x,alienExplosionLocation.y,
            alienExplosions[alienExplosion-1],alienExplosions[alienExplosion-1]);
    // move to next frame of the alien explosion animation
    alienExplosion--;
  }  
}

void drawExplosion() {
// Purpose: draw frame of an explosion animation  
  
  // draw frame of ship explosion animation
  drawShipExplosion();
  
  // draw frame of asteroid explosion animation
  drawAsteroidExplosion();
  
  // draw frame of alien explosion animation
  drawAlienExplosion();
}

boolean detectAsteroidCentre() {
// Purpose: detect if a asteroid is "near" centre of display
  int tolerance;
  boolean isDead;
  boolean fReturn = false;
  int theSize;
  PVector thePosition = new PVector(0,0);
  
  for (int i=0;i<asteroids;i++) {
    isDead = asteroidDead.get(i);
    
    if (! isDead) {
      theSize = asteroidSize.get(i);
      thePosition = asteroidPosition.get(i);
      
      tolerance = (asteroidSizes[theSize]/2) + centreRadius;
      
      // circular collision detection:
      // uses formula (x2-x1)^2 + (y1-y2)^2 <= (r1+r2)^2
      if (sq(thePosition.x - (width/2)) + sq(thePosition.y - (height/2)) <= sq(tolerance)) {
        // asteroid is near centre
        fReturn = true;
      }
      
      spawnWait++;
      
      if (spawnWait > spawnWaitLimit) {
        // we've waited too long
        // spawn the ship anyway
        fReturn = false;
        spawnWait = 0;
      }
    }
  }
  return(fReturn);
}

void waitToSpawn() {
// Purpose: wait to spawn a new life for the ship
  if (gameMode == 1) {
    // game mode is "waiting to spawn"
    
    // the ship is born again with a new life
    // wait until screen centre is clear before relaunching ship

    // detect if the area around the display centre is free of asteroids
    if (!detectAsteroidCentre()) {
      // spawn ship
      // set game mode to "in progress"
      gameMode = 0;
    }
  }
}

void nextLife() {
// Purpose: the ship moves to one of its remaining spare lives
  
  // initial ship direction is up: 1.5 pi radians is up
  shipDirection = 1.5*PI;

  // the ship is in the centre of the screen
  shipLocation.x = width/2;
  shipLocation.y = height/2;

  // the ship is not moving
  shipVelocity.x = 0;
  shipVelocity.y = 0;  
}

void shipExplodes() {
// Purpose: make a ship explosion
  // ship has collided with an asteroid or alien
  
  // set all keys to up
  initKeys();
  // start animation of ship explosion
  shipExplosion = shipExplosions.length;
  // set ship explosion location
  shipExplosionLocation.x = shipLocation.x;
  shipExplosionLocation.y = shipLocation.y;
  
  // how many lives do we have left?
  livesRemaining--;
  if (livesRemaining > 0) {
    // go to the next life
    // game mode is "waiting to spawn"
    gameMode = 1;
    // reset the waiting to spawn timer
    spawnWait = 0;
    // reset the ship parameters for a new life
    nextLife();
  } else {
    // game mode is "game over"
    gameMode = 2;
    // reset end game timer
    endGameWait = 0;
  }
}

void detectShipCollisionAsteroid() {
// Purpose: detect collision between ship and asteroids
  int toleranceAsteroid;
  boolean isDead;
  int theSize;
  PVector thePosition = new PVector(0,0);

  if (gameMode == 0) {
    // game mode is in progress
    for (int i=0;i<asteroids;i++) {
      isDead = asteroidDead.get(i);
    
      if (! isDead) {
        theSize = asteroidSize.get(i);
        thePosition = asteroidPosition.get(i);
      
        toleranceAsteroid = (asteroidSizes[theSize]/2) + (shipSize/2);

        // bounding box collision detection
        if (shipLocation.x >= (thePosition.x-toleranceAsteroid) &
            shipLocation.x <= (thePosition.x+toleranceAsteroid) &
            shipLocation.y >= (thePosition.y-toleranceAsteroid) &
            shipLocation.y <= (thePosition.y+toleranceAsteroid)) {
              // ship has collided with an asteroid
              // a life is destroyed
              shipExplodes();
        }
      }
    }
  }
}

void detectShipCollisionAlien() {
// Purpose: detect collision between ship and alien
  int toleranceAlien;
  
  // alien is visiting and game mode is in progress
  if ((alienOn) & (gameMode == 0)) {
    toleranceAlien = (alienSize/2) + (shipSize/2);
    
    // bounding box collision detection
    if (shipLocation.x >= (alienLocation.x-toleranceAlien) &
        shipLocation.x <= (alienLocation.x+toleranceAlien) &
        shipLocation.y >= (alienLocation.y-toleranceAlien) &
        shipLocation.y <= (alienLocation.y+toleranceAlien)) {
          // ship has collided with an alien
          // a life is destroyed
          shipExplodes();
    }
  }
}

void detectShipCollision() {
// Purpose: detect collision between:
//   ship and asteroids
//   ship and alien
  
  // detect collision between ship and asteroids
  detectShipCollisionAsteroid();
  
  // detect collision between ship and alien
  detectShipCollisionAlien();
}

void spawnAsteroid(float positionX, float positionY, float theSpeed, int theSize) {
// Purpose: spawn a baby asteroid
  // baby asteroid moves in a random direction
  float theDirection = random(2*PI);
  boolean isDead = false;
  int theExplosion = 0;
  // asteroid starts where the parent asteroid exploded
  PVector thePosition = new PVector(positionX,positionY);
  
  // add another asteroid
  asteroids++;
  
  // add this asteroids attributes to the ArrayList's
  asteroidPosition.add(thePosition);
  asteroidDirection.add(theDirection);
  asteroidSize.add(theSize);
  asteroidDead.add(isDead);
  asteroidExplosion.add(theExplosion);
  // asteroid speed increases by asteroidSpeedChange when it decreases in size
  asteroidSpeed.add(theSpeed+asteroidSpeedChange);
}

void asteroidHit(int iAsteroid) {
// Purpose: an asteroid has been hit with a laser bolt
//          potentially spawn baby asteroids
  boolean isDead;
  int theSize;
  PVector thePosition = new PVector(0,0);
  float theSpeed;

  // increase the score
  theSize = asteroidSize.get(iAsteroid);
  score += scores[theSize];
  
  // get the position and speed of the hit asteroid
  thePosition = asteroidPosition.get(iAsteroid);
  theSpeed = asteroidSpeed.get(iAsteroid);
  
  // spawn new asteroids
  if (theSize == 0) {
    // large asteroid destroyed: spawn 2 medium asteroids
    spawnAsteroid(thePosition.x,thePosition.y,theSpeed,1);
    spawnAsteroid(thePosition.x,thePosition.y,theSpeed,1);
  }
  if (theSize == 1) {
    // medium asteroid destroyed: spawn 2 small asteroids
    spawnAsteroid(thePosition.x,thePosition.y,theSpeed,2);
    spawnAsteroid(thePosition.x,thePosition.y,theSpeed,2);
  }
  // if small asteroid destroyed, we spawn nothing
  
  // if there's no asteroids remaining, move to the next level
  int deadAsteroids = 0;
  for (int i=0;i<asteroids;i++) {
    isDead = asteroidDead.get(i);
    if (isDead) {
      deadAsteroids++;
    }
  }
  if (deadAsteroids == asteroids) {
    // all asteroids are dead - no live asteroids left
    // we move to the next level
    level++;
    restartGame();
  }
}

void asteroidExplodes(int laser, int asteroid) {
// Purpose: make an asteroid explode
  int isLaserOn, theExplosion;              
  boolean isDead;
  
  // set laser bolt off
  isLaserOn = 0;
  laserOn.set(laser,isLaserOn);

  // destroy the asteroid
  isDead = true;
  asteroidDead.set(asteroid,isDead);
            
  // asteroid is exploding
  // start asteroid explosion animation
  theExplosion = asteroidExplosions.length;
  asteroidExplosion.set(asteroid,theExplosion);
  
  // asteroid was hit
  // spawn baby asteroids
  asteroidHit(asteroid);
}

void alienExplodes(int laser) {
// Purpose: make an alien explode
  int isLaserOn;
  
  // destroy the alien
  alienOn = false;
  
  // set laser bolt off
  isLaserOn = 0;
  laserOn.set(laser,isLaserOn);
  
  // increment score for shooting the alien
  score += scoreAlien;

  // alien is exploding
  // start alien explosion animation
  alienExplosion = alienExplosions.length;
  // set alien explosion location
  alienExplosionLocation.x = alienLocation.x;
  alienExplosionLocation.y = alienLocation.y;
}

void detectLaserCollisionAsteroid() {
// Purpose: detect collision between ship laser and asteroids
  int toleranceAsteroid, isLaserOn;
  boolean isDead;
  int theSize;
  PVector thePosition = new PVector(0,0);
  PVector theLocation = new PVector(0,0);
  
  if (gameMode == 0) {
    // game mode is "in progress"
    // detect collision between ship laser and asteroids
    for (int i=0;i<asteroids;i++) {
      isDead = asteroidDead.get(i);
      if ((! isDead) & (laserLocation.size() > 0)) {
        for (int j=0;j<laserLocation.size();j++) {
          isLaserOn = laserOn.get(j);
          if (isLaserOn > 0) {
            // break the loop if we have killed an asteroid and are still firing
            if (i <= asteroidSize.size()) {
              theSize = asteroidSize.get(i);
      
              toleranceAsteroid = (asteroidSizes[theSize]/2) + (laserSize/2);
      
              thePosition = asteroidPosition.get(i);
              theLocation = laserLocation.get(j);

              // bounding box collision detection
              if (theLocation.x >= (thePosition.x-toleranceAsteroid) &
                  theLocation.x <= (thePosition.x+toleranceAsteroid) &
                  theLocation.y >= (thePosition.y-toleranceAsteroid) &
                  theLocation.y <= (thePosition.y+toleranceAsteroid)) {
                    // laser hits asteroid
                    asteroidExplodes(j,i);
              }
            }
          }
        }
      }
    }
  }
}

void detectLaserCollisionAlien() {
// Purpose: detect collision between ship laser and alien
  int toleranceAlien, isLaserOn;
  PVector theLocation = new PVector(0,0);

  if (gameMode == 0) {
    // game mode is "in progress"
    // detect collision between ship laser and alien
    if ((laserLocation.size() > 0) && (alienOn)) {
      for (int i=0;i<laserLocation.size();i++) {
        isLaserOn = laserOn.get(i);
        if (isLaserOn > 0) {
          toleranceAlien = (alienSize/2) + (laserSize/2);
        
          theLocation = laserLocation.get(i);

          // bounding box collision detection
          if (theLocation.x >= (alienLocation.x-toleranceAlien) &
              theLocation.x <= (alienLocation.x+toleranceAlien) &
              theLocation.y >= (alienLocation.y-toleranceAlien) &
              theLocation.y <= (alienLocation.y+toleranceAlien)) {
                // laser hits alien
                alienExplodes(i);
          }
        }
      }
    }
  }
}

void detectLaserCollisionShip() {
// Purpose: detect collision between alien laser and ship
  int toleranceShip;
    
  if (gameMode == 0) {
    // game mode is "in progress"
    if (alienLaserOn) {
      toleranceShip = (shipSize/2) + (alienLaserSize/2);

      // bounding box collision detection
      if (shipLocation.x >= (alienLaserLocation.x-toleranceShip) &
          shipLocation.x <= (alienLaserLocation.x+toleranceShip) &
          shipLocation.y >= (alienLaserLocation.y-toleranceShip) &
          shipLocation.y <= (alienLaserLocation.y+toleranceShip)) {
            // laser hits alien
            shipExplodes();
      }
    }
  }
}

void detectLaserCollision() {
// Purpose: detect collision between:
//   ship laser and asteroids
//   ship laser and alien
//   alien laser and ship

  // detect collision between ship laser and asteroids
  detectLaserCollisionAsteroid();
  
  // detect collision between ship laser and alien
  detectLaserCollisionAlien();
  
  // detect collision between alien laser and ship
  detectLaserCollisionShip();
}

void drawPolygon(float x, float y, float radius, int points) {
// Purpose: draw a polygon
// Arguments: x,y: centroid location for polygon
//            radius: radius for polygon
//            points: number for points
  float angle_between_points = TWO_PI / points;
  beginShape();
  for (float delta = 0; delta < TWO_PI; delta += angle_between_points) {
    vertex(x + cos(delta) * radius,y + sin(delta) * radius);
  }
  endShape(CLOSE);
}

void drawLaser() {
// Purpose: draw the ships laser bolts
  if (gameMode == 0) {
    // game mode is "in progress"
    // draw the laser bolts
    if (laserLocation.size() > 0) {
      for (int i=0;i<laserLocation.size();i++) {
        int isLaserOn = laserOn.get(i);
        if (isLaserOn > 0) {
          PVector theLocation = new PVector(0,0);
          theLocation = laserLocation.get(i);
          // colour is red
          fill(255,0,0);
          ellipse(theLocation.x,theLocation.y,laserSize,laserSize);
          // decriment life of this laser bolt
          isLaserOn--;
          laserOn.set(i,isLaserOn);
        }
      }
    }
  }
}

void moveLaser() {
// Purpose: move the ships laser bolts
  if (gameMode == 0) {
    // game mode is "in progress"
    // move the laser bolts
    if (laserLocation.size() > 0) {
      // traverse array in reverse order because we might drop elements from the array
      for (int i=laserLocation.size()-1;i>=0;i--) {
        int isLaserOn = laserOn.get(i);
        if (isLaserOn > 0) {
          // get the laser bolts location and velocity
          PVector theLocation = new PVector(0,0);
          PVector theVelocity = new PVector(0,0);
          theLocation = laserLocation.get(i);
          theVelocity = laserVelocity.get(i);
        
          // update laser location
          theLocation.add(theVelocity);
        
          // wrap laser around display when it reaches the edge of the display
          if (theLocation.x < 0) {
            theLocation.x += width;
          }
          if (theLocation.x > (width-1)) {
            theLocation.x -= width;
          }
          if (theLocation.y < 0) {
            theLocation.y += height;
          }
          if (theLocation.y > (height-1)) {
            theLocation.y -= height;
          }
        
          // store the new laser bolts location
          laserLocation.set(i,theLocation);
        
          // decriment laserOn for the laser bolt
          // laser bolt travels for a number of frames, then dies
          isLaserOn--;
        
          // remove laser bolts where laserOn is zero
          // the laser bolt has travelled for allowed number of frames, or has hit an asteroid
          if (isLaserOn < 1) {
            laserLocation.remove(i);
            laserVelocity.remove(i);
            laserOn.remove(i);
          }
        }
      }
    }
  }
  
  // increment framesSinceFire
  // when we fire a laser bolt, we wait for a bit before another one can fire
  framesSinceFire++;
}

void fireLaser() {
// Purpose: fire a laser bolt
  PVector theLocation = new PVector(0,0);
  PVector theVelocity = new PVector(0,0);
  int isLaserOn;
  
  // laser bolt has the ships velocity and location
  theLocation.x = shipLocation.x;
  theLocation.y = shipLocation.y;
  theVelocity.x = (cos(shipDirection) * laserSpeed) + shipVelocity.x;
  theVelocity.y = (sin(shipDirection) * laserSpeed) + shipVelocity.y;
  
  // laser bolt travels for a number of frames equal to the width of the screen
  isLaserOn = round(width/laserSpeed);
  
  // store the laser bolts attributes
  laserLocation.add(theLocation);
  laserVelocity.add(theVelocity);
  laserOn.add(isLaserOn);
  
  // we have just fired a laser bolt, so wait for a bit before another one can fire
  framesSinceFire = 0;
}

void drawAlienLaser() {
// Purpose: draw alien laser bolt
  waitAlienLaser();
  if (alienLaserOn) {
    // draw the alien laser
    // colour is yellow
    fill(255,255,0);
    ellipse(alienLaserLocation.x,alienLaserLocation.y,alienLaserSize,alienLaserSize);
  }
}

void moveAlienLaser() {
// Purpose: move alien laser bolt
  if (alienLaserOn) {
    alienLaserLocation.add(alienLaserVelocity);
    
    // alien laser bolt disappears when it reaches the edge of the display
    if (alienLaserLocation.x < 0) {
      alienLaserOn = false;
    }
    if (alienLaserLocation.x > (width-1)) {
      alienLaserOn = false;
    }
    if (alienLaserLocation.y < 0) {
      alienLaserOn = false;
    }
    if (alienLaserLocation.y > (height-1)) {
      alienLaserOn = false;
    }
  }
}

void waitAlienLaser() {
// Purpose: randomly spawn an alien laser bolt
  if ((level >= alienLevel) && (alienOn)) {
    if (!alienLaserOn) {
      // we might fire an alien laser
      if (random(alienLaserSpawnSeconds*frameRate*2) < 3) {
        // randomly spawn an alien laser
        alienLaserOn = true;
        // the alien laser fires from the alien ship
        alienLaserLocation.x = alienLocation.x;
        alienLaserLocation.y = alienLocation.y;
        // the alien laser fires downwards
        alienLaserVelocity.x = 0;
        alienLaserVelocity.y = alienLaserSpeed;
      }
    }
  }
}

void drawAlien() {
// Purpose: draw alien ship
  // randomly spawn alien ship if it doesn't exist
  waitAlien();
  if (alienOn) {
    // colour is yellow
    fill(255,255,0);
    // draw alien
    ellipse(alienLocation.x,alienLocation.y,alienSize,alienSize);
  }
}

void moveAlien() {
// Purpose: move alien ship
  if (alienOn) {
    alienLocation.add(alienVelocity);
    
    // alien disappears when it reaches the edge of the display
    if (alienLocation.x < 0) {
      alienOn = false;
    }
    if (alienLocation.x > (width-1)) {
      alienOn = false;
    }
    if (alienLocation.y < 0) {
      alienOn = false;
    }
    if (alienLocation.y > (height-1)) {
      alienOn = false;
    }
  }
}

void waitAlien() {
// Purpose: randomly spawn alien ship if it doesn't exist
  if ((level >= alienLevel) && (!alienOn)) {
    // we might spawn an alien
    if (random(alienSpawnSeconds*frameRate*2) < 3) {
      // randomly spawn an alien visitor
      alienOn = true;
      alienLocation.y = 30;
      alienVelocity.y = 0;
      if (random(2) < 1) {
        // alien visits from the left
        alienLocation.x = 0;
        alienVelocity.x = 1 + (alienSpeedChange * (level - 1));
      } else {
        // alien visits from the right
        alienLocation.x = width-1;
        alienVelocity.x = -1 * (1 + (alienSpeedChange * (level - 1)));
      }
    }
  }
}

void initKeys() {
// Purpose: set all keys to up (not pressed)
  leftPressed = false;
  rightPressed = false;
  upPressed = false;
  downPressed = false;
  spacePressed = false;  
}

void processKeyPress() {
// Purpose: do key action for keys that are currently pressed

  if (gameMode == 0) {
    // game mode is "in progress"
    // process key presses so user interface responds to user input on each frame
    // called by every frame drawn
    // this allows us to have fluid and multiple simultaneous key presses
    if (leftPressed) {
      // left arrow key, turn left
      shipDirection -= PI/shipTurnSpeed;
      if (shipDirection < 0) {
        shipDirection = 2*PI;
      }    
    }
    if (rightPressed) {
      // right arrow key, turn right
      shipDirection += PI/shipTurnSpeed;
      if (shipDirection > (2*PI)) {
        shipDirection = 0;
      }
    }
    if (upPressed) {
      // up arrow key, accelerate
      acceleration = thrustConstant;
      accelerateShip();
    }
    if (downPressed) {
      // down arrow key, decelerate
      acceleration = -1 * thrustConstant;
      accelerateShip();
    }
    if (spacePressed) {
      // space key, fire laser
      // we allow a laser bolt to fire every laserFireFrames frames
      if (framesSinceFire > laserFireFrames) {
        fireLaser();
      }
    }
  }
}

void keyPressed() {
// Purpose: detect when a key is pressed down
  if (gameMode == 2) {
    // game mode is "game over"
    if (endGameWait > endGameFrames) {
      // when game is over, press any key to restart game
      score = 0;
      level = 1;
      livesRemaining = lives;
      // initial ship direction is up: 1.5 pi radians is up
      shipDirection = 1.5*PI;
  
      restartGame();
    }
  } else {
    // game mode is "waiting to spawn" or "in progress"
    // when game is in progress, record relevant key presses so user interface is responsive
    if (key == CODED) {
      if (keyCode ==  LEFT) {
        leftPressed = true;
      }
      if (keyCode ==  RIGHT) {
        rightPressed = true;
      }
      if (keyCode ==  UP) {
        upPressed = true;
      }
      if (keyCode ==  DOWN) {
        downPressed = true;
      }
    }
    if (key == 32) {
      spacePressed = true;
    }
  }
}

void keyReleased() {
// Purpose: detect when a key is released
  if (gameMode != 2) {
    // game mode is "waiting to spawn" or "in progress"
    // record relevant key releases so user interface is responsive
    if (key == CODED) {
      if (keyCode ==  LEFT) {
        leftPressed = false;
      }
      if (keyCode ==  RIGHT) {
        rightPressed = false;
      }
      if (keyCode ==  UP) {
        upPressed = false;
      }
      if (keyCode ==  DOWN) {
        downPressed = false;
      }
    }
    if (key == 32) {
      spacePressed = false;
    }
    if (keyCode == ENTER) {
      // teleport ship when ENTER key released
      teleportShip();
    }
  }
}
