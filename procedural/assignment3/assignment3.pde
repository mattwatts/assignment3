//# asteroids-ass3
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
//   ship can have multiple laser bolts in flight simultaneously
//   there's a slight pause before the ship can fire another laser bolt
//   laser bolts travel for a number of pixels equal to screen height
//   more asteroids appear on level up

        // current location of ship
PVector shipLocation,
        // current velocity of ship
        shipVelocity,
        // location of ship explosion
        shipExplosionLocation;
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
float laserSpeed = 15,
      // determines how much thrust happens when up and down arrow pressed
      thrustConstant = 0.2,
      // determines how fast large asteroids move on level 1
      asteroidStartSpeed = 1,
      // determines how fast asteroid speed increases with difficulty increase
      asteroidSpeedChange = 0.25;
    // score is zero at start of level 1
int score=0,
    // game starts at level 1
    level=1,
    // how many lives do you have
    lives=4,
    // how many lives are currently remaining?
    livesRemaining = lives,
    // how big is the laser bolt?
    laserSize = 10,
    // how many asteroids does level 1 start with?
    startAsteroidCount = 4,
    // how many extra asteroids on new levels
    asteroidLevelUp = 2,
    // how long is segment size on ship triangle
    // this is a placeholder until ship graphic introduced
    shipSize = 10,
    // determines how quickly ship turns when left and right arrow pressed
    shipTurnSpeed = 50,
    // detection radius for "is asteroid close to display centre"
    centreRadius = 100,
    // gameMode: 0="in progress", 1="waiting to spawn", 2="game over"
    gameMode = 0,
    // how many frames must pass before laser fires again
    laserFireFrames = 20,
    // how many frames have elapsed since laser bolt was fired
    framesSinceFire = laserFireFrames + 1;
int exhaust,
    // which ship explosion "frame" is currently displaying
    shipExplosion,
    // how many asteroids currently exist?
    // we set it to startAsteroidCount at start of level 1
    asteroids = startAsteroidCount;
//boolean // is the laser bolt firing
        //laserOn;
        // is the left arrow key down?
boolean leftPressed = false,
        // is the right arrow key down?
        rightPressed = false,
        // is the up arrow key down?
        upPressed = false,
        // is the down arrow key down?
        downPressed = false,
        // is the space key down?
        spacePressed = false;
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
// what is the diameter for each asteroid circle: large=100, medium=50, small=25
// this is a placeholder until asteroid graphics introduced
int[] asteroidSizes = {75,50,25};
// how many points for shooting each asteroid size: large=25, medium=50, small=100
int[] scores = {25,50,100};
// each element of this array is a ship explosion "frame"
// a frame is a circle of specified diameter
// frames can be added/removed by simply growing or shrinking this fixed size array
int[] shipExplosions = {500,450,400,350,300,250,200,150,100,50};
// each element of this array is an asteroid explosion "frame"
int[] asteroidExplosions = {250,225,200,175,150,125,100,75,50,25};

void setup(){
  //size(600,800);
  size(500,650);
  
  // set the font size for displaying score
  textSize(26);

  // initial ship direction is up: 1.5 pi radians is up
  shipDirection = 1.5*PI;
  
  initGame();
  restartGame();
}

void draw(){
  // set a black background to draw on
  background(0);

  if (gameMode == 1) {
    // game mode is "waiting to spawn"
    waitToSpawn();
  }
  
  if (gameMode == 0) {
    // game mode is "in progress"
    // process key presses so user interface responds to user input on each frame
    processKeyPress();
  
    // laser bolt and ship
    drawLaser();
    drawShip();
  }
  
  // draw remaining elements of the game composition
  drawAsteroids();
  drawScore();
  drawExplosion();
  drawLives();
  
  if (gameMode == 2) {
    // game mode is "game over"
    // display game over messages
    text("Game over",width/2-60,height/2-20);
    text("Press any key to restart",width/2-130,height/2+10);
  }
  
  if (gameMode == 0) {
    // game mode is "in progress"
    // move the ship and laser bolt
    moveShip();  
    moveLaser();
  }
  
  // move the steroids
  moveAsteroids();
    
  if (gameMode == 0) {
    // game mode is "in progress"
    // detect collision between laser and asteroids
    detectLaserCollision();
    
    // detect collision between ship and asteroids
    detectShipCollision();
  }
}

void initGame() {
  // initialise the ship location and direction vectors
  // pass 2 parameters to the PVector constructor so processing knows it's 2 dimensional
  shipLocation = new PVector(0,0); 
  
  shipExplosionLocation = new PVector(0,0);
}

void restartGame() {
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

void drawScore() {
// Purpose: draw the score in Blue
// Arguments: none
// Return value: none

  // set text colour blue
  fill(0,0,255);
  
  // write the score
  text(score,10,30);
  text("Level " + level,10,60);
  //text("lives: " + livesRemaining,10,90);
}

void drawLives() {
 // purpose: draw the number of lives remaining as ship icons
 fill(0,255,0);
 pushMatrix();
 translate(1,1);
 //rotate(1.5*PI);
 for (int i=0;i<livesRemaining-1;i++) {
   polygon(20+(i*20),80, shipSize, 3);
 }
 popMatrix(); 
}

void initAsteroids() {
  // create new asteroid set for the start of a level
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
  // draw asteroids
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
  // move the asteroids
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
  // calculate the acceleration
  PVector shipAcceleration;
  shipAcceleration = new PVector(cos(shipDirection),sin(shipDirection));
  shipAcceleration.setMag(acceleration);
  
  // update the velocity
  shipVelocity.add(shipAcceleration);
  
  exhaust = 1;
}

void moveShip() {
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

void teleportShip() {
  // teleport ship to a random location
  
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
  // draw a rocket exhaust
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
  polygon(0, 0, shipSize, 3);  // Triangle
  popMatrix();
}

void drawExplosion() {
  // draw frame of an explosion animation  
  int theExplosion;
  PVector thePosition = new PVector(0,0);
  
  if (shipExplosion > 0) {
    // colout is red
    fill(255,0,0);
    // draw frame of ship explosion animation
    ellipse(shipExplosionLocation.x,shipExplosionLocation.y,
            shipExplosions[shipExplosion-1],shipExplosions[shipExplosion-1]);
    // move to next frame of the ship explosion animation
    shipExplosion--;
  }
  
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

boolean detectAsteroidCentre() {
  // use circular collision detection to see if a asteroid is "near" centre of display
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
      
      //(x2-x1)^2 + (y1-y2)^2 <= (r1+r2)^2
      if (sq(thePosition.x - (width/2)) + sq(thePosition.y - (height/2)) <= sq(tolerance)) {
        // asteroid is near centre
        fReturn = true;
      }
    }
  }
  return(fReturn);
}

void waitToSpawn() {
  // the ship is born again with a new life
  // wait until screen centre is clear before relaunching ship
  if (!detectAsteroidCentre()) {
    // spawn ship
    // set game mode to "in progress"
    gameMode = 0;
  }
}

void nextLife() {
  // initial ship direction is up: 1.5 pi radians is up
  shipDirection = 1.5*PI;

  // the ship is in the centre of the screen
  shipLocation.x = width/2;
  shipLocation.y = height/2;

  // the ship is not moving
  shipVelocity.x = 0;
  shipVelocity.y = 0;  
}

boolean detectShipCollision() {
  // detect collision between ship and asteroids
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
      
      tolerance = (asteroidSizes[theSize]/2) + (shipSize/2);

      if (shipLocation.x >= (thePosition.x-tolerance) &
          shipLocation.x <= (thePosition.x+tolerance) &
          shipLocation.y >= (thePosition.y-tolerance) &
          shipLocation.y <= (thePosition.y+tolerance)) {
            // ship has collided with an asteroid
            // a life is destroyed
            fReturn = true;
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
              nextLife();
            } else {
              // game mode is "game over"
              gameMode = 2;
            }
      }
    }
  }
  return(fReturn);
}

void spawnAsteroid(float positionX, float positionY, float theSpeed, int theSize) {
  // spawn a baby asteroid
  // asteroid moving in a random direction
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
  // an asteroid has been hit with a laser bolt
  // potentially spawn baby asteroids
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

boolean detectLaserCollision() {
  // detect collision between laser and asteroids
  int tolerance, isLaserOn;
  int iHit = 0;
  boolean isDead;
  boolean fReturn = false;
  int theSize, theExplosion;
  PVector thePosition = new PVector(0,0);
  PVector theLocation = new PVector(0,0);

  for (int i=0;i<asteroids;i++) {
    isDead = asteroidDead.get(i);
    if ((! isDead) & (laserLocation.size() > 0)) {
      for (int j=0;j<laserLocation.size();j++) {
        isLaserOn = laserOn.get(j);
        if (isLaserOn > 0) {
          theSize = asteroidSize.get(i);
      
          tolerance = (asteroidSizes[theSize]/2) + (laserSize/2);
      
          thePosition = asteroidPosition.get(i);
          theLocation = laserLocation.get(j);
      
          if (theLocation.x >= (thePosition.x-tolerance) &
              theLocation.x <= (thePosition.x+tolerance) &
              theLocation.y >= (thePosition.y-tolerance) &
              theLocation.y <= (thePosition.y+tolerance)) {
                // laser hits asteroid
                fReturn = true;
                isLaserOn = 0;
                laserOn.set(j,isLaserOn);
                iHit = i;

                // destroy the asteroid
                isDead = true;
                asteroidDead.set(i,isDead);
            
                // asteroid is exploding
                // start asteroid explosion animation
                theExplosion = asteroidExplosions.length;
                asteroidExplosion.set(i,theExplosion);
          }
        }
      }
    }
  }
  
  if (fReturn) {
    // asteroid iReturn was hit
    asteroidHit(iHit);
  }
  
  return(fReturn);
}

// this function is a placeholder only until we substitute in ship graphics
void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void drawLaser() {
  // draw the laser bolts
  PVector theLocation = new PVector(0,0);
  int isLaserOn;
  
  if (laserLocation.size() > 0) {
    for (int i=0;i<laserLocation.size();i++) {
      isLaserOn = laserOn.get(i);
      if (isLaserOn > 0) {
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

void moveLaser() {
  // move the laser bolt
  PVector theLocation = new PVector(0,0);
  PVector theVelocity = new PVector(0,0);
  int isLaserOn;
  
  if (laserLocation.size() > 0) {
    // traverse array in reverse order because we might drop elements from the array
    for (int i=laserLocation.size()-1;i>=0;i--) {
      isLaserOn = laserOn.get(i);
      if (isLaserOn > 0) {
        // get the laser bolts location and velocity
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
  
  // increment framesSinceFire
  // when we fire a laser bolt, we wait for a bit before another one can fire
  framesSinceFire++;
}

void fireLaser() {
  // create a laser bolt
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

void initKeys() {
  // set all keys to up (not pressed)
  leftPressed = false;
  rightPressed = false;
  upPressed = false;
  downPressed = false;
  spacePressed = false;  
}

void processKeyPress() {
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

void keyPressed() {
  // detect when a key is pressed down
  if (gameMode == 2) {
    // game mode is "game over"
    // when game is over, press any key to restart game
    score = 0;
    level = 1;
    livesRemaining = lives;
    // initial ship direction is up: 1.5 pi radians is up
    shipDirection = 1.5*PI;
  
    restartGame();
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
  // detect when a key is realeased
  if (gameMode != 2) {
    // game mode is "waiting to spawn" or "in progress"
    // when game is in progress, record relevant key releases so user interface is responsive
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
