int bendL = 0;
int bendR = 0;
int inByte = 0;

void setup()
{
  // put your setup code here, to run once:
  Serial.begin(9600);
  while(!Serial)
  {
    ;
  }
  bendL = analogRead(0);
  bendR = analogRead(5);
  establishContact();
}

void loop()
{
  if (Serial.available() > 0)
  {
    inByte = Serial.read();
    
    bendL = analogRead(0)/4;
    bendR = analogRead(5)/4;
    
    Serial.write(bendL);
    Serial.write(bendR);
    Serial.write(3);
  }
  //Serial.println("print");
  //Serial.println("Left:" + String(bendL) + "   " + "Right:" + String(bendR));
  //Serial.print("Left:" + String(bendL) + "   " + "Right:" + String(bendR));
}

void establishContact()
{
  while (Serial.available() <= 0)
  {
    Serial.print('A');
    delay(300);
  }
}


