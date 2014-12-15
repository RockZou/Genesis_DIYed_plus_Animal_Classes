class Cat extends Animal 
{

  Cat(PImage pic) 
  {
    alive=true;
    released=true;
    position3D.x=random(-500,500);
    position3D.y=random(-500,500);
    body = pic; 
    tlapse = 60; 
    xSpeed = 1.5;
    ySpeed = 1.5;
    zSpeed = 10;  
    xSize = 45; 
    ySize = 35;
    zSize = 40; 
    this.soundClip = minim.loadFile("catsound.wav");  
    kind = "cat";
  }
}
class Cow extends Animal 
{

  Cow(PImage pic) 
  {
    
    released=true;
    position3D.x=random(-500,500);
    position3D.y=random(-500,500);
    alive=true;
    body = pic; 
    xSpeed = 2;
    ySpeed = 2.5; 
    zSpeed = 10;
    xSize = 60; 
    ySize = 50;
    zSize = 30;
    this.soundClip = minim.loadFile("cowsound.wav");  
    kind = "cow";
  }
}  
class Dog extends Animal 
{

  Dog(PImage pic) 
  {
    
    released=true;
    position3D.x=random(-500,500);
    position3D.y=random(-500,500);
    alive=true;
    body = pic; 
    xSpeed =3;
    ySpeed = 3;
   zSpeed = 8;  
    xSize = 45; 
    ySize = 40;
    zSize = 30;
    this.soundClip = minim.loadFile("dogsound.wav");  
    kind = "dog";
  }
}
class Bunny extends Animal 
{

  Bunny (PImage pic) 
  {
    
    released=true;
    position3D.x=random(-500,500);
    position3D.y=random(-500,500);
    alive=true;
    body = pic; 
    xSpeed = 0.75;
    ySpeed = 0.7; 
    zSpeed =15;
    xSize = 35; 
    ySize = 35;
    zSpeed = 45; 
    this.sound = false;   
    kind = "bunny";
  }
} 
class Dinosaur extends Animal 
{

  Dinosaur(PImage pic) 
  {
    
    released=true;
    position3D.x=random(-500,500);
    position3D.y=random(-500,500);
    alive=true;
    body = pic; 
    xSpeed =2;
    ySpeed = 2; 
    zSpeed = 10;
    xSize = 110; 
    ySize = 110;
    zSize = 50; 
    this.soundClip = minim.loadFile("dinosaursound.wav");  
    kind = "dinosaur";
    interactType =constrain(int(random(0.6, 10)),1,5);
  }
}  

class Pig extends Animal 
{

  Pig(PImage pic) 
  {
    
    released=true;
    position3D.x=random(-500,500);
    position3D.y=random(-500,500);
    alive=true;
    body = pic; 
    xSpeed =1;
    ySpeed = 1; 
    zSpeed = 5; 
    xSize = 60; 
    ySize = 30;
    zSize = 15;
    this.soundClip = minim.loadFile("pigsound.wav");  
    kind = "pig";
  
  }
}  
