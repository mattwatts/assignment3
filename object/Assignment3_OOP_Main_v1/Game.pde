/*******************************************************************************
* Class: Game
* Fields: Paused, GameOver, NumOfAst, Score, ScoreCheck, Level, Lives, 
*         GameState.
* Methods: initAsteroids(), clearCenter(), waitFrame(), readyFrame(),
*          endFrame(), displayScoreLabel(), displayLifeLabel(),
*          displayLevelLabel(), 
* Desc: Game Object keeps track of the state of the game and operates certain
*       methods when conditions of the game are met. This object is also
*       responcible for giving feedback to the player to enhance user
*       experience.
*******************************************************************************/
class Game{
  boolean paused,
          gameOver;
  
  int     numOfAst,
          score,
          scoreCheck,
          level,
          lives,
          maxLives;
          
  String  gameState;
  
/*******************************************************************************
* Constructor: Game()
* Parameters: NONE
* Returns: NONE
* Desc: Constructor initialises fields with the starting values associated with
*       the beginning of a new game.
*******************************************************************************/
  Game(){
    this.paused = false;
    this.gameOver = false;
    this.numOfAst = 3;
    this.score = 0;
    this.scoreCheck = 2500;
    this.level = 1;
    this.lives = 4;
    this.maxLives = 6;
    this.gameState = "Null";
  }
  
//SETTERS AND GETTERS - METHOD DESCRIPTIONS ARE GENERALISED FOR ALL OF CLASS
/*******************************************************************************
* Setter(s): set<FieldName><OPTION>()
* Parameters: inputs - denoted with an 'i' prefix.
* Returns: NONE
* Desc: Setters are used in this class to be used throughout the program. It
*       allows the new values to occupy the Games fields. Some fields have
*       multiple setters denoted by the <OPTION> tag, such as the PVector 
*       fields that allow finer control over some of the Games data.
*******************************************************************************/
  void setPaused(boolean iPaused){
    this.paused = iPaused;
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
  boolean getPaused(){
    boolean gPaused = this.paused;
    return gPaused;
  }
  
  void setGameOver(boolean iGameOver){
    this.gameOver = iGameOver;
  }
  
  boolean getGameOver(){
    boolean gGameOver = this.gameOver;
    return gGameOver;
  }
  
  void setNumOfAst(int iAstNum){
    this.numOfAst = iAstNum;
  }
  
  int getNumOfAst(){
    int gAstNum = this.numOfAst;
    return gAstNum;
  }
  
  void setScore(int iScore){
    this.score = iScore;
  }
  
  int getScore(){
    int gScore = this.score;
    return gScore;
  }
  
  void setScoreCheck(int iScoreCheck){
    this.scoreCheck = iScoreCheck;
  }
  
  int getScoreCheck(){
    int gScoreCheck = this.scoreCheck;
    return gScoreCheck;
  }
  
  void setLevel(int iLVL){
    this.level = iLVL;
  }
  
  int getLevel(){
    int gLVL = this.level;
    return gLVL;
  }
  
  void setLives(int iLives){
    this.lives = iLives;
  }
  
  int getLives(){
    int gLives = this.lives;
    return gLives;
  }
  
  void setMaxLives(int iMax){
    this.maxLives = iMax;
  }
  
  int getMaxLives(){
    int gMax = this.maxLives;
    return gMax;
  }
  
  void setGameState(String iState){
    this.gameState = iState;
  }
  
  String getGameState(){
    String gState = this.gameState;
    return gState;
  }
  
//METHODS - THESE METHODS HAVE MORE DESCRIPTION AS THEY ARE SPECIFIC TO CLASS
/*******************************************************************************
* Method: initAsteroids()
* Parameters: ArrayList for asteroid objects. - astArr
* Returns: NONE
* Desc: Used to begin a level with a starting number of asteroid enemies. This
*       number is dependant on the current level number and for each element in
*       the given ArrayList, a random spawn position is generated and its
*       direction of movement is random within a range that is semi-toward
*       the players position.
*******************************************************************************/
  void initAsteroids(ArrayList astArr){
    int astTotal = this.getNumOfAst() + (this.getLevel() * 1);
    for(int i = 0; i < astTotal; i++){
      astArr.add(new Asteroid(0,0, 0, 1, false, 100, 25));
      Asteroid currentAst = (Asteroid)astArr.get(i);
      int startSide = int(random(3));
      // 0 = Right side of screen
      if(startSide == 0){          
        currentAst.setLocation(random(width - 50, width), random(100, height - 100));
        currentAst.setBearing(random(3 * QUARTER_PI, 5 * QUARTER_PI));   
      } 
      // 1 = Bottom side of screen
      else if(startSide == 1){
        currentAst.setLocation(random(100, width - 100), random(height - 50, height));
        currentAst.setBearing(random(5 * QUARTER_PI, 7 * QUARTER_PI));
      } 
      // 2 = Left side of screen
      else if(startSide == 2){
        currentAst.setLocation(random(50), random(100, height - 100));
        if(random(2) < 1){
          currentAst.setBearing(random(0, QUARTER_PI));
        } else{
          currentAst.setBearing(random(7 * QUARTER_PI, TWO_PI));
        }
      } 
      // 3 = Top side of screen
      else {
      currentAst.setLocation(random(100, width - 100), random(0, 50));
      currentAst.setBearing(random(QUARTER_PI, 3 * QUARTER_PI));
      }
    }
  }
  
/*******************************************************************************
* Method: clearCenter()
* Parameters: ArrayList for asteroid objects. - astArr
* Returns: boolean - clear
* Desc: For each frame of the main program, this method starts with the total
*       number of ArrayList elements or Asteriods and iterates over the given 
*       ArrayList and decrements for every element that is a greater distance
*       from the center. The asteroids continue to move and this method called
*       until this method can achieve a zero value in which the boolean is 
*       switched from false to true. This true value is returned into an if
*       structure where corresponding methods can be executed.
*******************************************************************************/  
  boolean clearCenter(ArrayList astArr){
    boolean clear = false;
    int astInRange = astArr.size();
    for(int i = 0; i < astArr.size(); i++){
      Asteroid currentAst = (Asteroid)astArr.get(i);
      float distanceFromCenter = dist(currentAst.getLocationX(),currentAst.getLocationY(),width/2,height/2);
      if(distanceFromCenter > 150){
        astInRange--;
      }
    }
    if(astInRange == 0){
      clear = true;
    }
    return clear;
  }
  
/*******************************************************************************
* Method: waitFrame()
* Parameters: NONE
* Returns: NONE
* Desc: Displays visual elements to the screen to inform the player that the
*       program is executing the clearCenter() method and what the area
*       considered to be the center is. The Game field "paused" is set to true
*       so interactivity is limited during this process.
*******************************************************************************/  
  void waitFrame(){
    fill(125, 85);
    noStroke();
    ellipse(width/2,height/2,300,300);
    fill(255);
    textAlign(CENTER);
    textSize(16);
    text("Waiting For Clear Spawn Area", width/2, (height/3)*2);
    this.setPaused(true);
  }

/*******************************************************************************
* Method: readyFrame()
* Parameters: NONE
* Returns: NONE
* Desc: Displays the visual elements to the screen to inform the player that
*       the game is ready to resume on the press of the ENTER Key. Game field
*       "paused" is set to true to limit interactivity during the noLoop().
*******************************************************************************/  
  void readyFrame(){
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("READY? Press ENTER to Continue", width/2, (height/3)*2);
    this.setPaused(true);
    noLoop();
  }
  
/*******************************************************************************
* Method: endFrame()
* Parameters: NONE
* Returns: NONE
* Desc: Displays the visual elements to the screen to communicate to the
*       player that the game is over and inform the player of thier final score
*******************************************************************************/  
  void endFrame(){
    instance.setGameState("Your Score is : " + instance.getScore());
    background(0);
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("GAME OVER", width/2, (height/5)*2);
    text(instance.getGameState(), width/2, (height/5)*3);
  }
  
/*******************************************************************************
* Method: displayScoreLabel()
* Parameters: NONE
* Returns: NONE
* Desc: Displays the score to the screen during gameplay to inform the player
*       of thier current score as it increases.
*******************************************************************************/  
  void displayScoreLabel(){
    fill(255);
    textSize(32);
    textAlign(LEFT);
    text("Score: " + this.getScore(),15,32);
  }
  
/*******************************************************************************
* Method: displayLifeLabel()
* Parameters: NONE
* Returns: NONE
* Desc: For each life that the game has in its "lives" field, a visual
*       representation of the player ship is drawn to the screen along its
*       determined X axis (yOffset). During gameplay, to limit this from 
*       obscuring the screen a maximum ammount of lives is used.
*******************************************************************************/    
  void displayLifeLabel(){
    for(int i = 0; i < this.getLives(); i++){
      int xOffset = (i * 30) + 30;
      int yOffset = 48;
      stroke(255);
      strokeWeight(1);
      noFill();
      triangle(xOffset,yOffset,xOffset+15,yOffset+30,xOffset-15,yOffset+30);
    }
  }

/*******************************************************************************
* Method: displayLevelLabel()
* Parameters: NONE
* Returns: NONE
* Desc: Displays the level counter to the screen during gameplay to inform the
*       player of thier current progress.
*******************************************************************************/  
  void displayLevelLabel(){
    String lvlLab = nf(this.getLevel(), 2);
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text(lvlLab, width/2, 32);
  }
  
/*******************************************************************************
* Method: displayGameStateLabel()
* Parameters: NONE
* Returns: NONE
* Desc: During gameplay, the games "gameState" field is updated when the player
*       loses a life. This method displays this field as a String on the reset,
*       wait and game over frames to inform the player of how they died or
*       when the game is over.
*******************************************************************************/  
  void displayGameStateLabel(){
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text(instance.getGameState(), width/2, height/3);
  }
}
