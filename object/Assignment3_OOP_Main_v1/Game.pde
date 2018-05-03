class Game{
  boolean gameOver;
  
  int     score,
          level;
          
  String  gameResult;
  
  Game(){
    
  }
  
  //Setters and Getters
  void setGameOver(boolean gameOverInput){
    this.gameOver = gameOverInput;
  }
  
  boolean getGameOver(){
    boolean gO = this.gameOver;
    return gO;
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
  
  void setGameResult(String resultInput){
    this.gameResult = resultInput;
  }
  
  String getGameResult(){
    String result = this.gameResult;
    return result;
  }
  
  //Functions
    // initial setup
    // reset level
    // increase/decrease difficulty
    // game over screen
}
