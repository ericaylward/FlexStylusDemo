class cursorX
{
  float flexX1, flexY1;
  int mode;
  PVector bendVector1, bendVector2;
  cursorX()
  {
    flexX1 = width/2;
    flexY1 = height/2;
    mode = 0;
    bendVector1 = new PVector(0, 0);
    bendVector2 = new PVector(0, 0);
  }

  void drawShape()
  {
    //mouse/pen cursor

    ellipseMode(CENTER);
    switch (mode)
    {
    case 0:
      fill(0);
      noStroke();
      ellipse(mouseX, mouseY, 0, 0);
      break;

    case 1:
      noFill();
      stroke(0);
      strokeWeight(2);
      ellipse(mouseX, mouseY, 10, 10);
      break;

    case 2:
      break;
    }

    //flex cursor
    noStroke();
    ellipse(mouseX, mouseY, 2, 2);
    
    stroke(0);
    strokeWeight(2);
    //line(bendVector1.x, bendVector1.y, bendVector2.x, bendVector2.y);
    
    bendVector1 = new PVector(mouseX, mouseY);
    bendVector2 = new PVector(flexX1, flexY1);
  }
  void moveShape(float posX, float posY)
  {
    flexX1 = posX + mouseX;
    flexY1 = posY + mouseY;
  }
}