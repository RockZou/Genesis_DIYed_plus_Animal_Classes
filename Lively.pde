/*****************************************TO DO LIST*****************************************/
/*

1. Clear + /Dial back + Pause/
2.randomize animal
3.auto release
4. Start, Ending Modes
//5. Bigger backGround
6.auto release

*/

//Necessary Improts 
import ddf.minim.*; 
import jp.nyatla.nyar4psg.*;
import processing.video.*;

/*=========for animal selection===========*/
int animalState;


//Audio and video Global Variables 
Minim minim; 
Capture video;
PImage temp;
PImage finalImage;
PImage sFinalImage;//shrunk final image

PImage frame;
PImage genesisframe;

PImage textureframe1;
PImage textureframe2;
PImage textureframe3;
PImage textureframe4;
PImage textureframe5;
PImage textureframe6;
PImage scanningmode1;
PImage scanningmode2;
PImage scanningmode3;
PImage treeBorder;
PImage yourCreation;
PImage noBoard;

PShape leaves;
PShape trunk;
PShape fence;
PShape star;

float fenceLength=7;
//textures
PImage ground, cement, dirt, grass, clouds, space, carpet;

PVector[] offsetArray = 
{
  new PVector(220, 220), new PVector(-220, 220), new PVector(-220, -220), new PVector(220, -220)
  //added Dec 14
  ,new PVector(0,0),new PVector(0,0),new PVector(0,0),new PVector(0,0),new PVector(0,0),
  new PVector(0,0),new PVector(0,0),new PVector(0,0),new PVector(0,0),new PVector(0,0),
  new PVector(0,0),new PVector(0,0),new PVector(0,0),new PVector(0,0),new PVector(0,0),
  new PVector(0,0),new PVector(0,0),new PVector(0,0),new PVector(0,0),new PVector(0,0)
};

//the number of pixels, width and height
int maxN, dbW, dbH;

int pxCenter=0, pyCenter=0, markerTime=0, pstate=0, stateTimer=0, backTimer=0;

//animalCounter variable
int b;
//marker track variable
int i;

//animalType indicator
int animalType=0;

//marker numbers
int animalMarkerNumber=13;
int treeMarkerNumber=12;
int fenceMarkerNumber=14;
int closeupMarkerNumber=15;
// to change the animal for closeup
int currentAnimalNumber=0;

int markerNumber=16;

//existingMarkers
boolean[] existingMarkers=new boolean[markerNumber];
boolean[] pexistingMarkers=new boolean[markerNumber];
//timer for continously appearing markers
int[] markerTimers=new int[markerNumber];

int treeCounter=0;
boolean treeIsReleased=false;
boolean treePlus=false;
int fenceCounter=0;
ArrayList<PVector> fenceVectors;
boolean selected=false;

// Necessary Game State 
int state = 1; 
// 0 = opening? 
// 1 = scan 
// 2 = Map Virtual 

//up to 100 animals can be created. 
Animal[] animals = new Animal[500];
Tree[]  theTrees = new Tree[1000];
//Fence[] theFences= new Fence[2000];
int animalCounter = 0; 

// load sounds 
// AudioPlayer interact1 =  minim.loadFile("jumping_teon.mp3");  
// AudioPlayer interact3,interact4,interact5; 
void setup() 
{
 // load all sounds 
 // interact1 = minim.loadFile("jumping_teon.mp3"); 
   
  // interact2 = minim.loadFile("creature_footstep_large.mp3");
   
  // interact3 = minim.loadFile("born.wav");
   
  //  interact4 = minim.loadFile("rope_spin_in_air_like_lasso_version_4.mp3");
   
//    interact5 = minim.loadFile("person_bites_into_toasted_tea_cake.mp3");

  // make sure to render your sketch using a 3D renderer.  OPENGL or P3D will both work.
  size(640, 480, OPENGL);
  smooth();
  frameRate(30);
  
  //create our video object
  String[] cameras = Capture.list();
  if (cameras.length == 0)
  {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i] + "number: " + i);
    }
  }

 // create our video object
  //video = new Capture(this, cameras[4]);
  video = new Capture(this,640,480);
  video.start();
  

  // this is used to correct for distortions in your webcam
  augmentedRealityMarkers = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);

  // attach the pattern you wish to track to this marker.  this file also needs to be in the data folder
  // 80 is the width of the pattern

  /*=============================redundant board=======================*/
  // the first marker will be referred to as marker #0

  //0
  augmentedRealityMarkers.addARMarker(loadImage("m1.jpg"), 16, 25, 80);
  //1
  augmentedRealityMarkers.addARMarker(loadImage("m2.jpg"), 16, 25, 80);
  //2
  augmentedRealityMarkers.addARMarker(loadImage("m3.jpg"), 16, 25, 80);
  //3
  augmentedRealityMarkers.addARMarker(loadImage("m4.jpg"), 16, 25, 80);
  //4 = grass
  augmentedRealityMarkers.addARMarker(loadImage("tex1.png"), 16, 25, 80);
  //5 = cement
  augmentedRealityMarkers.addARMarker(loadImage("tex2.png"), 16, 25, 80);
  //6
  augmentedRealityMarkers.addARMarker(loadImage("tex3.png"), 16, 25, 80);
  //7
  augmentedRealityMarkers.addARMarker(loadImage("tex4.png"), 16, 25, 80);
  //8
  augmentedRealityMarkers.addARMarker(loadImage("tex5.png"), 16, 25, 80);
  //9
  augmentedRealityMarkers.addARMarker(loadImage("tex6.png"), 16, 25, 80);
  //10
  augmentedRealityMarkers.addARMarker("patt.hiro", 80);
  //11
  augmentedRealityMarkers.addARMarker("patt.kanji", 80);
  //12
  augmentedRealityMarkers.addARMarker(loadImage("tree.jpg"), 16, 25, 80);
  //13
  augmentedRealityMarkers.addARMarker(loadImage("release.png"), 16, 25, 80);
  //14
  augmentedRealityMarkers.addARMarker(loadImage("fence.png"), 16, 25, 80);
  //15
  augmentedRealityMarkers.addARMarker(loadImage("closeup.png"), 16, 25, 80);
  
  
  genesisframe = loadImage("genesisborder.png");
  textureframe1 = loadImage("cementborder.png");
  textureframe2 = loadImage("cloudborder.png");
  textureframe3 = loadImage("dirtborder.png");
  textureframe4 = loadImage("grassborder.png");
  textureframe5 = loadImage("snowborder.png");
  textureframe6 = loadImage("spaceborder.png");
  
  frame = genesisframe;
  
  scanningmode1 = loadImage("scanningmode1.png");
  scanningmode2 = loadImage("scanningmode2.png");
  scanningmode3 = loadImage("scanningmode3.png");
  
  treeBorder = loadImage("treeborder.png");
  noBoard = loadImage("noboardborder.png");
  yourCreation = loadImage("yourcreation.png");
  
  
  grass = loadImage("grass.jpg");
  dirt = loadImage("dirt.jpg");
  cement = loadImage("cement.jpg");
  clouds = loadImage("clouds.jpg");
  space = loadImage("space.jpg");
  clouds = loadImage("clouds.jpg");
  carpet = loadImage("carpet.jpg");
  ground = grass;
  
  
  leaves = loadShape("leaves.obj");
  trunk = loadShape("trunk.obj");  
  fence = loadShape("fence.obj");
  star = loadShape("stars.obj");
  
/*=========for animal selection===========*/

  minim = new Minim(this); 
  theTrees[0]= new Tree();
  fenceVectors=new ArrayList<PVector>();
  treeCounter++;
}


void draw()
{
  
  //theTrees[treeCounter-1].alive=false;
  
  // we only really want to do something if there is fresh data from the camera waiting for us
  if (video.available())
  {
    hint(DISABLE_DEPTH_TEST);
    video.read();
    imageMode(CORNER);
    //scale(-1,1);
    image(video, 0, 0);
    //scale(-1,1);
    hint(ENABLE_DEPTH_TEST);
    standardState();
    pstate=0;
    
    // ask the AR marker object to attempt to find our patterns in the incoming video stream
    try {
      augmentedRealityMarkers.detect(video);
    }
    catch (Exception e) {
      println("Issue with AR detection ... resuming regular operation ..");
    }
    
    for (int c=0;c<markerNumber;c++)
    {
      existingMarkers[c]=false;
      if (augmentedRealityMarkers.isExistMarker(c))
      existingMarkers[c]=true;
    }

    
    if (state == 1)    //scanning
    {
        scanningMode();
        backgroundRemoval();
        animalType=SelectAnimal();
        if (existingMarkers[10]&&existingMarkers[11])
        {
          enterTenFrames();
        }
        
        if (doubleMarkerOverTime(10,11,30))
        {/****************************************************************************************/
          successfulScan();
          switch (animalType)
          {
            case 0:
            break;
            case 1:
            animals[animalCounter] = new Cat(sFinalImage);
            break;
            case 2:
            animals[animalCounter] = new Cow(sFinalImage);
            break;
            case 3:
            animals[animalCounter] = new Dinosaur(sFinalImage);
            break;
            case 4:
            animals[animalCounter] = new Bunny(sFinalImage);
            break;
            case 5:
            animals[animalCounter] = new Dog(sFinalImage);
            break;
            case 6:
            animals[animalCounter] = new Pig(sFinalImage);
            break;
          }
          animalType=0;
          state = 2;
          currentAnimalNumber=animalCounter;
          animalCounter++;
          stateTimer=0;
        }
    }//end if state==1;
    
    //projection
    else if (state == 2)
    {
       noBoardDetected();
       
       if (existingMarkers[4]) 
       {
         ground = grass;
         grassMarkerDetected();
       }
       else if (existingMarkers[5])
       { 
         ground = cement;
         cementMarkerDetected();
       }
       else if (existingMarkers[6])
       {
         ground = space;
         spaceMarkerDetected();
       }
       else if (existingMarkers[7])
       {
         ground = clouds;
         cloudMarkerDetected();
       }
       else if (existingMarkers[8])
       {
         ground = carpet;
         snowMarkerDetected();
       }
       else if (existingMarkers[9]) 
       {
         ground = dirt;
         dirtMarkerDetected();
       }
        
      
      if (doubleMarkerOverTime(10,11,30))
      {
        //enterTenFrames();
        markerTimers[10]=0;
        markerTimers[11]=0;
        state=1;//scan
      }
      println("gotit");
      for (i = 0; i < 4; i++)
      {
        if (existingMarkers[closeupMarkerNumber])
        {
          i=closeupMarkerNumber;
          println("closeuped");
        }
        // does the board markers exist?
        if (existingMarkers[i])
        {
          standardState();
          if (existingMarkers[treeMarkerNumber]&&!theTrees[treeCounter-1].released)//if the tree marker exist
          {
            println("closeuped2");
            theTrees[treeCounter-1].alive=true;
            //println("marker",treeMarkerNumber,"exist");
            treePlus=false;
        /*******************tree code deleted*********************************/
            markerIsStill(theTrees,treeMarkerNumber, 5, treeCounter,i);
            if (treePlus)
            treeCounter++;
          }
          
          //fence********************************************
          
          //**********************END fence******************
          
          // set the AR perspective
          augmentedRealityMarkers.setARPerspective();

          // next, remember the current transformation matrix
          pushMatrix();

          // change the transformation matrix so that we are now drawing in 3D space on top of the marker
          setMatrix(augmentedRealityMarkers.getMarkerMatrix(i));

          // flip the coordinate system around so that we can draw in a more intuititve way (if you don't do this
          // then the x & y axis will be flipped)
          scale(-1, -1);

          // draw a box on the marker to show which marker is providing us with our reference
          rectMode(CENTER);
          
          
          
          if (existingMarkers[closeupMarkerNumber])
          {
            println("closeuped4");
            closeUp();
            pushMatrix();
            translate(animals[currentAnimalNumber].position3D.x,animals[currentAnimalNumber].position3D.y,0);
            //beginCamera();
            //camera(animals[i-4].position3D.x+50,animals[i-4].position3D.y+50,animals[i-4].position3D.z+50,animals[i-4].position3D.x,animals[i-4].position3D.y,animals[i-4].position3D.z,0,0,0);
          }
          println("closeuped5");
          pushMatrix();//to remember the offset translate
          // MOVE TO THE CENTER OF THE BOARD using the offset array
          
          translate(offsetArray[i].x, offsetArray[i].y, 0);
          println("closeup6");
          
          //floor obj
          noStroke();
          tint(255,150);
          beginShape();
          texture(ground);
          //Dec 13, changed 240 to 1000
          vertex(-500, -500, 0, 0);
          vertex(500, -500, 1000, 0);
          vertex(500, 500, 1000, 1000);
          vertex(-500, 500, 0, 1000);
          endShape();
          tint(255,255);
          println("closeup7");
          this.display();
          

          popMatrix();
          if (existingMarkers[closeupMarkerNumber])
          {
            popMatrix();
            //endCamera();            
          }
          // all done!  time to clean up ...

          // reset to the default perspective
          perspective();

          // restore the 2D transformation matrix
          popMatrix();

          // break out of the loop - no need to look for other markers!
          break;
        }
      }
    }//end if state==2 projection


    
for (int c=0;c<markerNumber;c++)
{
  pexistingMarkers[c]=existingMarkers[c];
}
hint(DISABLE_DEPTH_TEST);
imageMode(CORNER);
image(frame,0,0);
hint(ENABLE_DEPTH_TEST);
  }//end video.available
}//end draw

/**************************1 deleted**************************/

boolean doubleMarkerOverTime(int markerNumber1, int markerNumber2, int timerThresh)
{
  if (existingMarkers[markerNumber1]&&existingMarkers[markerNumber2]&&pexistingMarkers[markerNumber1]&&pexistingMarkers[markerNumber2])
  {
    println("marker 10 and 11 exist");
    markerTimers[markerNumber1]++;
    markerTimers[markerNumber2]++;
    if (markerTimers[markerNumber1]==timerThresh&&markerTimers[markerNumber2]==timerThresh)
    return (true);
  }
  else
  {
    //println("cleared");
    markerTimers[markerNumber1]=0;
    markerTimers[markerNumber2]=0;
  }
  return (false);
}


void display()
{
  imageMode(CENTER);
  /*for ( b=0;b<fenceCounter;b++)
  {
    theFences[b].display();
  }
  */
  for ( b=0;b<treeCounter;b++)
  {
    theTrees[b].display();
  }
  for ( b = 0; b < animalCounter; b++)
  {
    animals[b].move();
    animals[b].collision();
    animals[b].display();
  }
}

void standardState()
{
  frame = genesisframe;
}

void noBoardDetected()
{
  frame = noBoard;
}

void scanningMode()
{
  frame = scanningmode1;
}

void enterTenFrames()
{
  frame = scanningmode2;
}

void successfulScan()
{
  frame = scanningmode3;
}

void cementMarkerDetected()
{
  frame = textureframe1;
}

void cloudMarkerDetected()
{
  frame = textureframe2;
}

void dirtMarkerDetected()
{
  frame = textureframe3;
}

void grassMarkerDetected()
{
  frame = textureframe4;
}

void snowMarkerDetected()
{
  frame = textureframe5;
}

void spaceMarkerDetected()
{
  frame = textureframe6;
}

void treeMarkerDetected()
{
  frame = treeBorder;
}

void closeUp()
{
  frame = yourCreation;
} 

/*

boolean sketchFullScreen() {
  return true;
} 
*/

