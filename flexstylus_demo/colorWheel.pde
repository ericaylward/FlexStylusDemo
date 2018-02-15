class colorWheel
{
  float posX;
  float posY;
  float sizeX;
  float sizeY;
  boolean isActive;
  PShape cW;
  
  PShape cWCheck;
  float posCheckX;
  float posCheckY;
  float sizeCheckX;
  float sizeCheckY;
  
  
  colorWheel()
  {
    sizeX = 0;
    sizeY = 0;
    posX = width/2;
    posY = height/2;
    cW = loadShape("colorWheel.svg");
    cW.enableStyle();
    
    posCheckX = posX+sizeX/2.5;
    posCheckY = posY-sizeY/2.5;
    sizeCheckX = 50;
    sizeCheckY = 50;
    cWCheck = loadShape("checkMark.svg");
    cWCheck.enableStyle();
  }
  
  void update(float sizeXTemp, float sizeYTemp, float sizeCheckXTemp, float sizeCheckYTemp)
  {
    sizeX = lerp(sizeX, sizeXTemp, 0.5);
    sizeY = lerp(sizeY, sizeYTemp, 0.5);
    
    sizeCheckX = lerp(sizeCheckX, sizeCheckXTemp, 0.5);
    sizeCheckY = lerp(sizeCheckY, sizeCheckYTemp, 0.5);
    
    posCheckX = posX+sizeX/2.5;
    posCheckY = posY-sizeY/2.5;
  }
  
  void drawShape()
  {
    shapeMode(CENTER);
    shape(cW, posX, posY, sizeX, sizeY);
    fill(0);
    noStroke();
    ellipse(posCheckX,posCheckY,sizeCheckX,sizeCheckY);
    shape(cWCheck,posCheckX,posCheckY,sizeCheckX,sizeCheckY);
    
  }
}
    