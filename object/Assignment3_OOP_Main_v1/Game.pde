class Game{
  boolean paused,
          gameOver;
  
  int     numOfAst,
          score,
          scoreCheck,
          level,
          lives;
          
  String  gameState;
  
  Game(){
    this.paused = false;
    this.gameOver = false;
    this.numOfAst = 3;
    this.score = 0;
    this.scoreCheck = 2500;
    this.level = 1;
    this.lives = 4;
    this.gameState = "Null";
  }
  
  //Setters and Getters
  void setPaused(boolean iPaused){
    this.paused = iPaused;
  }
  
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
  
  void setGameState(String iState){
    this.gameState = iState;
  }
  
  String getGameState(){
    String gState = this.gameState;
    return gState;
  }
  
  //METHODS
  //Labels and Frames
  void initAsteroids(ArrayList astArr){
    int astTotal = this.getNumOfAst() + (this.getLevel() * 1);
    for(int i = 0; i < astTotal; i++){
      astArr.add(new Asteroid(0,0, 0, 1, false, 100, 25));
      Asteroid currentAst = (Asteroid)astArr.get(i);
      int startSide = int(random(3));
      if(startSide == 0){          // 0 = Right side of screen
        currentAst.setLocation(random(width - 50, width), random(100, height - 100));
        currentAst.setBearing(random(3 * QUARTER_PI, 5 * QUARTER_PI));   
      } else if(startSide == 1){   // 1 = Bottom side of screen
        currentAst.setLocation(random(100, width - 100), random(height - 50, height));
        currentAst.setBearing(random(5 * QUARTER_PI, 7 * QUARTER_PI));
      } else if(startSide == 2){   // 2 = Left side of screen
        currentAst.setLocation(random(50), random(100, height - 100));
        if(random(2) < 1){
          currentAst.setBearing(random(0, QUARTER_PI));
        } else{
          currentAst.setBearing(random(7 * QUARTER_PI, TWO_PI));
        }
      } else {                     // 3 = Top side of screen
      currentAst.setLocation(random(100, width - 100), random(0, 50));
      currentAst.setBearing(random(QUARTER_PI, 3 * QUARTER_PI));
      }
    }
  }
  
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
  
  void waitFrame(){
    fill(125, 85);
    noStroke();
    ellipse(width/2,height/2,300,300);
    fill(255);
    textAlign(CENTER);
    textSize(16);
    text("Waiting For Clear Spawn Area", width/2, (height/3)*2);
  }
  
  void readyFrame(){
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("READY? Press ENTER to Continue", width/2, (height/3)*2);
    this.setPaused(true);
    noLoop();
  }
  
  void endFrame(){
    instance.setGameState("Your Score is : " + instance.getScore());
    background(0);
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("GAME OVER", width/2, (height/5)*2);
    text(instance.getGameState(), width/2, (height/5)*3);
  }
  
  void displayScoreLabel(){
    fill(255);
    textSize(32);
    textAlign(LEFT);
    text("Score: " + this.getScore(),15,32);
  }
  
  
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
  
  void displayLevelLabel(){
    String lvlLab = nf(this.getLevel(), 2);
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text(lvlLab, width/2, 32);
  }
  
  void gameStateLabel(){
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text(instance.getGameState(), width/2, height/3);
  }
}
