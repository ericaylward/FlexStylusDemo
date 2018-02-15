class mainMenu
{
  PShape s;
  float posX;
  float posY;
  float sizeX;
  float sizeY;
  boolean isOverlapping;
  boolean isActive;
  float strokeWeight;
  float circleOpacity;
  
  mainMenu()
  {

    if (width <= height)
    {
      sizeX = width/17;
      sizeY = width/17;
      posX = width / 20;
      posY = width / 20;
    }
    else if (height < width)
    {
      sizeX = height/17;
      sizeY = height/17;
      posX = height/20;
      posY = height/20;
    }
    isOverlapping = false;
    circleOpacity = 230;
    s = loadShape("menuBtn.svg");
  }
  
  void update(float sizeXTemp, float sizeYTemp, float circleOpacityTemp)
  {
    sizeX = lerp(sizeX, sizeXTemp, 0.5);
    sizeY = lerp(sizeY, sizeYTemp, 0.5);
    
    circleOpacity = lerp(circleOpacity, circleOpacityTemp, 0.5);
  }
  
  void drawShape()
  {
    ellipseMode(CENTER);
    if(!isActive)
    {
      strokeWeight = lerp(strokeWeight, 0, 0.5);
    }
    else if(isActive)
    {
      strokeWeight = lerp(strokeWeight, 5, 0.5);
    }
    
    stroke(50,250,100);
    strokeWeight(strokeWeight);
    fill(0,0,0,circleOpacity);
    ellipse(posX, posY, sizeX, sizeY);
    
 
    s.enableStyle();
    shapeMode(CENTER);
    shape(s, posX, posY, sizeX, sizeY);

  }
}