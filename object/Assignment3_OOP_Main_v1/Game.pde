class Game{
  boolean paused,
          gameOver,
          gFX;
  
  int     numOfAst,
          score,
          level,
          lives;
          
  String  gameResult;
  
  Game(){
    this.paused = false;
    this.gameOver = false;
    this.gFX = false;
    this.numOfAst = 3;
    this.score = 0;
    this.level = 1;
    this.lives = 4;
    this.gameResult = "Null";
  }
  
  //Setters and Getters
  void setPaused(boolean pausedInput){
    this.paused = pausedInput;
  }
  
  boolean getPaused(){
    boolean gP = this.paused;
    return gP;
  }
  
  void setGameOver(boolean gameOverInput){
    this.gameOver = gameOverInput;
  }
  
  boolean getGameOver(){
    boolean gO = this.gameOver;
    return gO;
  }
  
  void setGFX(boolean gFXInput){
    this.gFX = gFXInput;
  }
  
  boolean getGFX(){
    boolean graphics = this.gFX;
    return graphics;
  }
  
  void setNumOfAst(int astNumInput){
    this.numOfAst = astNumInput;
  }
  
  int getNumOfAst(){
    int noa = this.numOfAst;
    return noa;
  }
  
  void setScore(int scoreInput){
    this.score = scoreInput;
  }
  
  int getScore(){
    int sc = this.score;
    return sc;
  }
  
  void setLevel(int lvlInput){
    this.level = lvlInput;
  }
  
  int getLevel(){
    int lvl = this.level;
    return lvl;
  }
  
  void setLives(int livesInput){
    this.lives = livesInput;
  }
  
  int getLives(){
    int liv = this.lives;
    return liv;
  }
  
  void setGameResult(String resultInput){
    this.gameResult = resultInput;
  }
  
  String getGameResult(){
    String result = this.gameResult;
    return result;
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
    text("READY? Press any Key", width/2, (height/3)*2);
    this.setPaused(true);
    noLoop();
  }
  
  void endFrame(){
    instance.setGameResult("Your Score is : " + instance.getScore());
    background(0);
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("GAME OVER", width/2, (height/5)*2);
    text(instance.getGameResult(), width/2, (height/5)*3);
  }
}
