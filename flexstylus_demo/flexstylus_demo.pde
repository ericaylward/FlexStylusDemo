//Serial Comms
import processing.serial.*;
Serial myPort;
int[] serialInArray = new int[3];
int serialCount;
boolean firstContact = false;
int portNum = 0; // may need to change depending on which port you're using

//Cursor
float xpos, ypos;
cursorX flexCursor;

//Radial menu items
menuItem[] menuItems;
float[] menuItemPosX = new float[8];
float[] menuItemPosY = new float[8];
int activeMenuItem;
float radius;
float dist = 50;
float angle = 0;
float angle_stepsize = 0.785;
float centerScreenX;
float centerScreenY;
float defaultMenuItemSizeX;
float defaultMenuItemSizeY;
float defaultMenuItemOpacity;
int btnDrawTimer;
boolean drawMenu;
int numMenuItems_noOverlap;
boolean isOverlappingMenuItem;

//Bend Movement
int increaseMagnitudeX = 1;
int increaseMagnitudeY = 1;

//menuButton
mainMenu mainRadialMenu;
boolean menuPressed;
int defaultMainMenuSize;
boolean isOverlappingMainMenu;

//timer for menu
int m;

//drawing
boolean mouseHeld;
float oldX;
float oldY;
PGraphics buffer;
float strokeWeight;
color strokeColor;

//color wheel
colorWheel colorWheel;
float defaultCWSize;
float defaultCWCheckSize;
boolean isOverlappingCheck;
int checkTimer;
boolean drawColorWheel;

//erasing
color eraserColor;

void setup()
{
  size(1024,1024);
  buffer = createGraphics(1024,1024);
  
  String portName = Serial.list()[portNum];
  myPort = new Serial(this, portName, 9600);
  
  //cursor setup
  xpos = width/2;
  ypos = height/2;
  increaseMagnitudeX = width/255;
  increaseMagnitudeY = height/255;
  flexCursor = new cursorX();
  
  //main menu setup
  mainRadialMenu = new mainMenu();
  
  //menu item setup
  menuItems = new menuItem[8];
  centerScreenX = width/2;
  centerScreenY = height/2;
  menuPressed = false;
  defaultMenuItemOpacity = 220;
  drawMenu = false;
  isOverlappingMenuItem = false;
  activeMenuItem = 100;
  
  if (width <= height)
  {
    defaultMenuItemSizeX = width/10;
    defaultMenuItemSizeY = width/10;
    radius = width / 5;
    defaultMainMenuSize = width/17;
  }
  else if (width > height)
  {
    defaultMenuItemSizeX = height/10;
    defaultMenuItemSizeY = height/10;
    radius = height / 5;
    defaultMainMenuSize = height/17;
  }
  
  for (int i = 0; i == menuItemPosX.length; i++)
  {
    menuItemPosX[i] = radius * cos(angle);
    menuItemPosY[i] = radius * sin(angle);
    angle += angle_stepsize;    
    ellipseMode(CENTER);
    ellipse(menuItemPosX[i], menuItemPosY[i], 50, 50);
  }
  
  for (int j = 0; j <= 7; j++)
  {
    menuItems[j] = new menuItem(j);
  }
  
  //drawing setup
  strokeWeight = 5;
  strokeColor = color(0,0,0);
  
  //color wheel setup
  colorWheel = new colorWheel();
  defaultCWSize = 350;
  defaultCWCheckSize = 50;
  isOverlappingCheck = false;
  drawColorWheel = false;
  
  //eraser setup
  eraserColor = color(0,0);
}

void draw()
{
  background(255, 255, 255);
  image(buffer,0,0);
  fill(strokeColor);
  ellipse(50,200,50,50);
  
  //change cursor
  flexCursor.mode = activeMenuItem;
  
  //color wheel draw
  if(drawColorWheel)
  {
    if (activeMenuItem == 1)
    {
      if(colorWheel.isActive)
      {
        colorWheel.update(350,350, defaultCWCheckSize, defaultCWCheckSize);
        colorWheel.drawShape();
      }
      else if(!colorWheel.isActive)
      {
        colorWheel.update(0,0, 0, 0);
        colorWheel.drawShape();
        
        if(millis() >= checkTimer+150)
        {
          drawColorWheel = false;
          activeMenuItem = 0;
        }
      }
    }
  }
  
  //Radial Menu
  if (drawMenu)
  {
    if (menuPressed)
    {
      for (int k = 0; k < menuItemPosX.length; k++)
      {
        if(angle < 2*PI)
        {
          menuItemPosX[k] = radius * cos(angle-1.57) + centerScreenX;
          menuItemPosY[k] = radius * sin(angle-1.57) + centerScreenY;
          angle += angle_stepsize;
        }
        
        if(overMenuItem(menuItemPosX[k], menuItemPosY[k], defaultMenuItemSizeX))
        {
          menuItems[k].update(menuItemPosX[k], menuItemPosY[k], defaultMenuItemSizeX+50, defaultMenuItemSizeY+50, 255);
          menuItems[k].drawShape();
          menuItems[k].isOverlapping = true;
        }
        else if(!(overMenuItem(menuItemPosX[k], menuItemPosY[k], defaultMenuItemSizeX)))
        {
          menuItems[k].update(menuItemPosX[k], menuItemPosY[k], defaultMenuItemSizeX, defaultMenuItemSizeY, defaultMenuItemOpacity);
          menuItems[k].drawShape();
          menuItems[k].isOverlapping = false;
        }
      }
    }
    else if(!menuPressed)
    {
      for (int k = 0; k < menuItemPosX.length; k++)
      {
        menuItems[k].update(width/2,height/2, 1, 1, 0);
        menuItems[k].drawShape();
      }
      
      if(millis() >= m+150)
      {
         drawMenu = false;
         isOverlappingMenuItem = false;
      }
    }
  }
  
  //Main Menu
  if(overMenuItem(mainRadialMenu.posX, mainRadialMenu.posY, mainRadialMenu.sizeX))
  {
    mainRadialMenu.update(defaultMainMenuSize+10, defaultMainMenuSize+10, 255);
    isOverlappingMainMenu = true;
  }
  else if(!overMenuItem(mainRadialMenu.posX, mainRadialMenu.posY, mainRadialMenu.sizeX))
  {
    mainRadialMenu.update(defaultMainMenuSize, defaultMainMenuSize, defaultMenuItemOpacity);
    isOverlappingMainMenu = false;
  }
  
  //over check mark
  if(overMenuItem(colorWheel.posCheckX, colorWheel.posCheckY, colorWheel.sizeCheckX) && activeMenuItem == 1)
  {
    isOverlappingCheck = true;
    colorWheel.update(defaultCWSize, defaultCWSize, defaultCWCheckSize+25, defaultCWCheckSize+25);
  }
  else if(!overMenuItem(colorWheel.posCheckX, colorWheel.posCheckY, colorWheel.sizeCheckX))
  {
    isOverlappingCheck = false;
  }
  
  //execute action if mouse is held
  if(mouseHeld && !isOverlappingMenuItem && !isOverlappingMainMenu)
  {
    switch(activeMenuItem)
    {
      case 0:
      drawing();
      //println("0");
      break;
      
      case 1:
      sampling();
      //println("1");
      break;
      
      case 2:
      break;
      
      case 3:
      erasing();
      //println("3");
      break;
      
      case 4:
      break;
      
      case 5:
      break;
      
      case 6:
      break;
      
      case 7:
      break;
    }
  }
  
  flexCursor.moveShape(xpos, ypos);
  flexCursor.drawShape();
  
  mainRadialMenu.drawShape();
  
}

void mousePressed()
{
  oldX=mouseX;
  oldY=mouseY;
  mouseHeld = true;
  //if clicking radial menu item
  if (drawMenu && menuPressed)
  {
    for (int i = 0; i < menuItemPosX.length; i++)
    {
      numMenuItems_noOverlap = 0;
      //checks if overlapping at least 1 menu item
      for (int k = 0; k < menuItemPosX.length; k++)
      {
        if (menuItems[k].isOverlapping == true)  
        {
          isOverlappingMenuItem = true;
        }
        else if (menuItems[k].isOverlapping == false)
        {
          numMenuItems_noOverlap++;
          if (numMenuItems_noOverlap == menuItemPosX.length)
          {
            isOverlappingMenuItem = false;
            
            //closes menu if misclick
            closeMenu();
          }
        }
      }  
      if(isOverlappingMenuItem)
      {
        if(menuItems[i].isOverlapping == true)
        {
          menuItems[i].isActive = true;
          activeMenuItem = i;
          
          //single click menu items/actions go here
          //colour sampling
          if (i == 1)
          {
            closeMenu();
            drawColorWheel = true;
            colorWheel.isActive = true;
            isOverlappingMenuItem = false;
            isOverlappingMainMenu = false;
          }
          //erase all
          else if(i == 4)
          {
           buffer.beginDraw();
           buffer.clear();
           buffer.endDraw();
          }
          //screenshot
          else if(i == 6)
          {
           buffer.save("art.png"); 
          }
        }
        else if(menuItems[i].isOverlapping == false)
        {
          menuItems[i].isActive = false;
        }
      }
    }
  }
  
  //if mouse clicked while colour select open
  else if(activeMenuItem == 1 && isOverlappingCheck)
  {
    colorWheel.isActive = false;
    checkTimer = millis();
  }
  
  //if clicking main menu
  if (isOverlappingMainMenu)
  {
    if(drawMenu)
    {
      closeMenu();
    }
    else if(!drawMenu)
    {
      openMenu();
    }
  }

}

void mouseReleased()
{
  mouseHeld = false;
}

void keyPressed()
{
  if(key == '1')
  {
    strokeWeight++;
  }
  else if(key == '2')
  {
    if(strokeWeight >=1)
    {
      strokeWeight--;
    }
  }
  else if(key == '3')
  {
    println("mouseHeld: " + mouseHeld + " - " + "isOverlappingMainMenu: " + isOverlappingMainMenu + " - " + "isOverlappingMenuItem: " + isOverlappingMenuItem);
    //isOverlappingMenuItem = false;
  }
}

void drawing()
{
  buffer.beginDraw();
  buffer.stroke(strokeColor);
  buffer.strokeWeight(strokeWeight);
  buffer.line(mouseX, mouseY, oldX, oldY);
  oldX=mouseX;
  oldY=mouseY;
  buffer.endDraw();
}

void sampling()
{
  if(!isOverlappingCheck && colorWheel.isActive)
  {
    strokeColor = color(get(mouseX, mouseY));
  }
}


void erasing()
{
  buffer.beginDraw();
  buffer.loadPixels();
  for (int x=0; x<buffer.width; x++) {
    for (int y=0; y<buffer.height; y++ ) {
      float distance = dist(x,y,mouseX,mouseY);
      if (distance <= strokeWeight/2) {
        int loc = x + y*buffer.width;
        buffer.pixels[loc] = eraserColor;
      }
    }
  }
  buffer.updatePixels();
  buffer.endDraw();
}

void closeMenu()
{
  menuPressed = false;
  m = millis();
  mainRadialMenu.isActive = false;
  isOverlappingMenuItem = false;
}

void openMenu()
{
  menuPressed = true;
  drawMenu = true;
  mainRadialMenu.isActive = true;
}

boolean overMenuItem(float tempMenuItemX, float tempMenuItemY, float tempDiameter)
{
  float distX = tempMenuItemX - mouseX;
  float distY = tempMenuItemY - mouseY;
  
  if(sqrt(sq(distX) + sq(distY)) < tempDiameter/2)
  {
    return true;
  }
  else
  {
   return false; 
  }
}


void serialEvent(Serial myPort)
{
  int inByte = myPort.read();
  if (firstContact == false)
  {
    if (inByte == 'A')
    {
      myPort.clear();
      firstContact = true;
      myPort.write('A');
    }
  }
  else
  {
    serialInArray[serialCount] = inByte;
    serialCount++;
    if (serialCount > 2)
    {
      xpos = increaseMagnitudeX * ((serialInArray[0]) - (255/2));
      ypos = increaseMagnitudeY * ((serialInArray[1]) - (255/2));
      myPort.write('A');
      serialCount = 0;
    }
  }
  
}