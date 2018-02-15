class menuItem
{
  PShape [] iconsArray;
  PShape s;
  float posX;
  float posY;
  float sizeX;
  float sizeY;
  boolean isOverlapping;
  boolean isActive;
  float strokeWeight;
  int arrayPosition;
  float circleOpacity;
  
  menuItem(int tempArrayPosition)
  {
    arrayPosition = tempArrayPosition;
    posX = width/2;
    posY = height/2;
    isOverlapping = false;
    iconsArray = new PShape[8];
    circleOpacity = 0;
    
    if (width <= height)
    {
      sizeX = 1;
      sizeY = 1;
    }
    else if (width > height)
    {
      sizeX = height/10;
      sizeY = height/10;
    }
    
    for (int i = 0; i <= 7; i++)
    {
      iconsArray[i] = loadShape(str(i + 1)+".svg");
    }
    s = iconsArray[arrayPosition];

  }
  
  void update(float posXTemp, float posYTemp, float sizeXTemp, float sizeYTemp, float circleOpacityTemp)
  {
    posX = lerp(posX, posXTemp, 0.5);
    posY = lerp(posY, posYTemp, 0.5);

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
      strokeWeight = lerp(strokeWeight, 7.5, 0.5);
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