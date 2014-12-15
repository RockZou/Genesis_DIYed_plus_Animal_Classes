class Animal 
{
  int lifeSpan=10000;
   // animal state
  int aState = 0;
  //0 = not interacting
  // 1 = interaction 
  // 2 = post interaction
  // type 
  String kind;
  // gotta keep track of IDs 
  int listID = animalCounter; 
  //Interact type
  int interactType = int(random(0.51, 5.49));
  boolean released=false;
  //Posoitions 
  PVector position3D=new PVector(0, 0, 0);
  //speed
  float xSpeed, ySpeed, zSpeed;
  //Image 
  PImage body; 
  //size  
  // do we really wanna set this as default? 
  float xSize=50, ySize=50, zSize=50;
  // actions array 
  float[] actions = new float[500]; 
  // frame counter and timers for interactions 
  float tlapse = 60, framecount = 0; 
  boolean babyState=false;
  int babyTime=0;
  int stateDelay=60; 
  boolean shrunk=false;
  int shrunkTime=0;
  int timer = 45;

  // rotate and Pshape for Spinning Move 
  int rotate = 90; 
  //sound
  AudioPlayer soundClip; 
  //dead state and sound state
  boolean alive = false; 
  boolean sound = true;
  float noiseIndex=random(1000);
  // censor points 
  float  cpFrontx, cpFronty, cpBack;
  int actOn=-1;

  /*======initiation over==========*/

/*--------------BASIC MOVEMENT METHODS ---------*/
  void move()
  {
    imageMode(CENTER);
    if (released &&(aState==0||aState==2))
    {
      if (position3D.x<=-400)
      {
        xSpeed = abs(xSpeed);
        ySpeed = ySpeed+random(-5, 5);
      }
      if (position3D.x>=400)
      {
        xSpeed = -1*abs(xSpeed);
        ySpeed = ySpeed+random(-5, 5);
      }
      if (position3D.y<=-400)
      {
        ySpeed = abs(ySpeed);
        xSpeed = xSpeed+random(-5, 5);
      }
      if (position3D.y>=400)
      {
        ySpeed = -1*abs(ySpeed);
        xSpeed = xSpeed+random(-5, 5);
      }
      noiseIndex+=1;
      xSpeed+=map(noise(noiseIndex),0,1,-2,2);
      ySpeed+=map(noise(1000-noiseIndex),0,1,-2,2);
      xSpeed=constrain(xSpeed,-10,10);
      ySpeed=constrain(ySpeed,-10,10);
      position3D.x += xSpeed; 
      position3D.y += ySpeed;
    }
  }

  void collision() 
  {
    imageMode(CORNER);
    cpFrontx = ((position3D.x) + xSpeed);
    cpFronty = ((position3D.y) + ySpeed);
    for (int t=0;t<treeCounter;t++){
    if (theTrees[t].xSize/2>dist(cpFrontx,cpFronty,theTrees[t].position3D.x,theTrees[t].position3D.y))
    {
      changeDirection();
      break;
    }
    }
    for (int a = 0; a < animalCounter; a++)
    {
      if (a == listID) actions[a] = 0; 
      else
      { 
        float thresh = animals[a].xSize/2; 
        //collision detection
        if (thresh >= dist(cpFrontx, cpFronty, animals[a].position3D.x, animals[a].position3D.y ) && actions[a] == 0 && aState == 0 && animals[a].alive == true && alive == true )
        {
          println("Interact!"); 
          actions[a]= 1;
          aState = 1;
          setAct(a);
        }
        else if (thresh < dist(cpFrontx, cpFronty, -1*animals[a].position3D.x, -1*animals[a].position3D.y ) && actions[a] == 1) 
        {
          actions[a]=0;
        }
      }
    }
  } 

  void display()
  {
    imageMode(CENTER); 
    if (alive)
    {
      
      pushMatrix(); 
      translate(0, 0, 10);
      if (!released)
      {
        fill(0, 200, 0, 100);
        ellipse(-1*position3D.x, -1*position3D.y, xSize, ySize);
      }
      else//released
      {
        babyCheck();
        if (aState==0)
        {
          pushMatrix();
          fill(0, 200, 0, 100);  
          ellipse(-1*position3D.x, -1*position3D.y, xSize, ySize); 
          translate(-1*position3D.x,-1*position3D.y, position3D.z+xSize/2); 
          // rotate x to stand up image
          rotateX(radians(270));
          // rotate so that the picture is turning towards a point. 
          rotateY(atan(ySpeed/xSpeed));
          // must shrink check
          if (shrunkCheck()) 
          {
            image(body, 0, 0, -xSize, -(ySize/4));
          }
          else  image(body, 0, 0, -xSize, -ySize); 
          popMatrix();//translate(-1*position3D.x,-1*position3D.y, position3D.z); 
        }
        else if (aState==1)
          interact();
        else if (aState==2)
        {
           stateCheck();
          fill(0,0,125,100);
          ellipse(-1*position3D.x,-1*position3D.y,xSize,ySize);
         
          pushMatrix();
          translate(-1*position3D.x,-1*position3D.y,position3D.z+xSize/2);
          rotateX(radians(270));
          rotateY(atan(ySpeed/xSpeed));
          
          if (shrunkCheck())
          {
            image(body, 0, 0, -xSize, -(ySize/4));
          }
          else //not shrunk
            image(body, 0, 0, -xSize, -ySize); 
          popMatrix();
        }//end aState==2
      }//end else (released)
      popMatrix();//translate(0,0,20);
    }//if(alive)
  }
 /*-------------- END OF BASIC MOVEMENT METHODS ---------*/

  /***********interaction*******************/
  void interact()
  {
    imageMode(CENTER);
    if (interactType == 1) //jumping
    { 
      // we can make it without changing the other person's state on this interaction
      // could cause a bug if other is interacting. 
      //animals[actOn].aState=2;
      // take out where the enemy is at
      float ActHeight = animals[actOn].ySize; 
      float ActxPos = animals[actOn].position3D.x; 
      float ActyPos = animals[actOn].position3D.y; 
      //height control of jumping
      if (position3D.z < ActHeight) {
        if (zSpeed < 0) {
          // gotta choose where to drop to and change the speed to change direction
          if (animals[actOn].xSpeed > 0 )
          { 
            ActxPos -= abs(animals[actOn].xSpeed) + (animals[actOn].xSize*2);
            xSpeed = -1 * abs(xSpeed);
          } 
          else { 
            ActxPos += abs(animals[actOn].xSpeed) + (animals[actOn].xSize*2);
            xSpeed = abs(xSpeed);
          } 
          if (animals[actOn].ySpeed > 0) {
            ActyPos -= abs(animals[actOn].ySpeed) + (animals[actOn].ySize*2);
            ySpeed = -1 * abs(ySpeed);
          } 
          else { 
            ActyPos += abs(animals[actOn].ySpeed) + (animals[actOn].ySize*2);
            ySpeed = abs(ySpeed);
          }
        }
        position3D.z += zSpeed;
      }
      // if over, reset so they will be on top
      else {
        position3D.z -= (position3D.z - ActHeight);
        // then make a sound
        makeSound();
      }  

      // now on top, stay there for 2 seconds. 
      if (position3D.z == ActHeight) {
        tlapse--; 
        // when time runs out, change things 
        if (tlapse == 0) {
          position3D.z -= 1;
          zSpeed = (-1 * abs(zSpeed));
          tlapse = 60;
        }
      } 

      // when i\t lands on the ground, write back the current X and Y position and go back to normal state. 
      if (position3D.z <= 0 && (zSpeed < 0)) {
        zSpeed = abs(zSpeed);
        position3D.z = 0;
        aState= 2;
        position3D.x = ActxPos; 
        position3D.y = ActyPos;
      }
      // draw accordingly.
      translate(0, 0, 1);
      fill(125, 0, 0, 100); 
      ellipse(-1*ActxPos, -1*ActyPos, xSize, ySize);
      // commented out addition of xsize/2 to position3d.z
      translate( -1*ActxPos, -1*ActyPos, position3D.z+xSize/2); 
      // rotate x to stand up image
      rotateX(radians(270));
      // rotate so that the picture is turning towards a point. 
      rotateY(atan(ySpeed/xSpeed));
      image(body, 0, 0, -xSize, -ySize);
    } 
    // 2 Squish Ability
    // 
    else if (interactType == 2) 
    {
      //Change direction when height is reached 
      if (position3D.z >= zSize) zSpeed = -1*(abs(zSpeed));
      //add it to position3D.z 
      position3D.z += zSpeed;  
      // when on ground, set back the state and speed. 
      if (position3D.z <= 0 && zSpeed < 0 ) {
        animals[actOn].shrunk = true;
        animals[actOn].shrunkTime = 60;
        makeSound();
        position3D.z = 0;
        zSpeed = abs(zSpeed); 
        aState = 2;
      }
      // draw accordingly 
      translate(0, 0, 1);
      fill(125, 0, 0, 100); 
      ellipse(-1*position3D.x, -1*position3D.y, xSize, ySize);
      translate( -1*position3D.x, -1*position3D.y, position3D.z+xSize/2); 
      // rotate x to stand up image
      rotateX(radians(270));
      // rotate so that the picture is turning towards a point. 
      rotateY(atan(ySpeed/xSpeed));
      image(body, 0, 0, -xSize, -ySize);
    }
    // 3 Breed Ability
    else if (interactType == 3&& animalCounter<400) 
    { /*
      // gotta delay breeding speed, special for breeders
      stateDelay= 150;
      //ellipse for interacting
      translate(0, 0, 1);
      fill(125, 0, 0, 100); 
      ellipse(-1*position3D.x, -1*position3D.y, xSize, ySize);
      translate( -1*position3D.x, -1*position3D.y, position3D.z+xSize/2); 
      // rotate x to stand up image
      rotateX(radians(270));
      // rotate so that the picture is turning towards a point. 
      rotateY(atan(ySpeed/xSpeed));
      if (timer > 0) {
        float pregX = xSize + (45 - timer); 
        timer--; 
        image(body, 0, 0, -pregX, -ySize);
      }  
      else if (timer == 0) { 
        float choice = random(1);  
        String baby = ""; 
        PImage babyFace; 
        if (choice > 0.5) 
        {
          baby = getKind(); 
          babyFace = this.getBody();
        } 
        else 
        {
          baby = animals[actOn].getKind();
          babyFace = animals[actOn].getBody();
        }
        // instantiate an animal 
        if (baby == "cat") {
          animals[animalCounter] = new Cat(babyFace);
        }
        else if (baby == "cow") {
          animals[animalCounter] = new Cow(babyFace);
        }
        else if (baby == "dinosaur") {
          animals[animalCounter] = new Dinosaur(babyFace);
        }
        else if (baby == "dog") {
          animals[animalCounter] = new Dog(babyFace);
        }
        else if (baby == "bunny") {
          animals[animalCounter] = new Bunny(babyFace);
        }
        else if (baby == "pig") {
          animals[animalCounter] = new Pig(babyFace);
        }
        // should never fail 
        else {
          println("nothing is matching. BABY MAKING FAILED");
        } 
        // make it smaller, make it a baby. 
        // this code should not be ran if no baby made. but baby should be successfully made every time. 
        animals[animalCounter].babyState = true; 
        animals[animalCounter].babyTime = 45;
        animals[animalCounter].xSize = animals[animalCounter].xSize/4 ; 
        animals[animalCounter].ySize = animals[animalCounter].ySize/4 ; 
        animals[animalCounter].interactType = 3;
        //summon the baby next. gottta release place it near the parent but not on the parent. 
        animals[animalCounter].released = true; 
        animals[animalCounter].position3D.x = position3D.x + random(-xSize/2, xSize/2); 
        animals[animalCounter].position3D.y = position3D.y + random(-ySize/2, ySize/2); ; 
        animals[animalCounter].aState = 2; 
        animals[animalCounter].alive = true; 
        animalCounter++;
        // set back timer.original size.  
        image(body, 0, 0, -xSize, -ySize);
        makeSound();
        aState = 2; 
        timer = 45;
      }
      */
    }  
    // 4 Spinning Man 
    else if (interactType == 4) 
    {
       // now draw the animal 
     translate(0, 0, 1);
      fill(125, 0, 0, 100); 
      ellipse(-1*position3D.x, -1*position3D.y, xSize, ySize);
      translate( -1*position3D.x, -1*position3D.y, position3D.z+xSize/2); 
      // rotate x to stand up image
      pushMatrix();
      rotateX(radians(270));
      rotateY(atan(ySpeed/xSpeed));
      rotateY(radians(rotate));
      image(body, 0, 0, -xSize, -ySize);
      popMatrix(); 
     // gotta do stars
    translate(0, 0, ySize); 
    pushMatrix();
     scale(10);
     rotateX(90);
     rotateY(radians(rotate));
     shape(star); 
     popMatrix();  
      rotate+= 10; 
     
     // set back timer after while 
     if(rotate == 720){
     rotate = 90;
     aState = 2; 
     
     } 
    }
    // Eats Other Animals 
    else if (interactType == 5) 
    {
      float ActHeight = animals[actOn].ySize; 
      float ActxPos = animals[actOn].position3D.x; 
      float ActyPos = animals[actOn].position3D.y; 
      //set all necessary data and get bigger and faster 
      if (position3D.z >= ActHeight){ 
        zSpeed = -1*(abs(zSpeed));
        animals[actOn].alive = false; 
        xSize += animals[actOn].xSize/4; 
       ySize += animals[actOn].ySize/4;  
       xSpeed += animals[actOn].xSpeed/4; 
       ySpeed += animals[actOn].ySpeed/4; 
      } 
     
      //add it to position3D.z 
      position3D.z += zSpeed;  
      // when on ground, set back the state and speed. 
      if (position3D.z <= 0 && zSpeed < 0 ) 
      {
        makeSound();
        position3D.z = 0;
        zSpeed = abs(zSpeed); 
        aState = 2;
        position3D.x = ActxPos; 
        position3D.y = ActyPos;
      }
       // draw accordingly.
      translate(0, 0, 1);
      fill(125, 0, 0, 100); 
      ellipse(-1*ActxPos, -1*ActyPos, xSize, ySize);
      // commented out addition of xsize/2 to position3d.z
      translate( -1*ActxPos, -1*ActyPos, position3D.z+xSize/2); 
      // rotate x to stand up image
      rotateX(radians(270));
      // rotate so that the picture is turning towards a point. 
      rotateY(atan(ySpeed/xSpeed));
      image(body, 0, 0, -xSize, -ySize);
    }
    // 0 nothing 
    else {
      aState = 2;
    }
  }
  /************END interaction***************/

 /*------------------------------STATE CONTROL METHODS --------------------------- */
  // Baby State = just been born 
 void babyCheck()
 {
   if (babyState && babyTime > 0)
   {
     xSize++;
     ySize++;
     babyTime--;
   }
   else if (babyTime==0)
   {
     babyState=false;
   }
 
 }
 //Shrunk = Stepped on by Other Animal 
 // Shrunk check should be running every state
 boolean shrunkCheck() 
 {
   if (shrunkTime == 0 || shrunk == false) return false;
   else 
   {  
      shrunkTime --;
      return true;
   }
 } 
 
 // only ran in astate = 2; 
 void stateCheck()
 {
   if (stateDelay>0) stateDelay--;
   // switch back to normal state after a second. 
   else if (stateDelay == 0)
     {
       aState=0;
       stateDelay=60;
     }
 }
 /*------------------------------END OF STATE CONTROL METHODS --------------------------- */
 /*------------------------------HELPER METHODS --------------------------- */
 PImage getBody()
  {
  return body;
  }
  String getKind()
  {
    return kind;
  }
  // set interaction enemy
    void setAct(int a)
  {
    if (actOn==-1||actOn!=a)
      actOn=a;
  }
 // make sound
  void makeSound() 
  {
    if (sound)
    {
      this.soundClip.rewind();
      this.soundClip.play();
    }
  }  
  void changeDirection()
 {
    xSpeed = (-xSpeed)+random(-2,2);
    ySpeed = (-ySpeed)+random(-2,2);
 } 

  /*------------------------------END OF HELPER METHODS --------------------------- */
}
