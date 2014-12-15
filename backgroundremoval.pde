// AR marker object - this keeps track of all of the patterns you wish to look for
MultiMarker augmentedRealityMarkers;
//int markerNumber=15;

//record Keeper,-1 for unscaned, 1 for white, 0 for color;
int[] thePixels;
color whiteBg1;
float whiteR1, whiteG1, whiteB1;
// also grab one from the bottom right - this lets us smooth things out if there are shadows on the image
// (so we have two shades of white to compare to)
color whiteBg2;
float whiteR2, whiteG2, whiteB2;
// threshold
int threshold = 50;
// to keep a clear margin of the drawing board
int skip=5;

void backgroundRemoval()
{
  if (existingMarkers[10]&&existingMarkers[11])
  {
        PVector[] hiro  = augmentedRealityMarkers.getMarkerVertex2D(10);
        PVector[] kanji = augmentedRealityMarkers.getMarkerVertex2D(11);
  
  /******************start anti rotation*******************/
    
        int drawingBoxW=int(kanji[3].x-hiro[1].x);
        int drawingBoxH=int(kanji[3].y-hiro[1].y);
        
        temp= new PImage(drawingBoxW, drawingBoxH, ARGB);      
        //temp.copy(rotatedVideo2, 0+skip,0+skip, (int)drawingBoxW-2*skip, (int)drawingBoxH-2*skip, 0, 0, (int)drawingBoxW, (int)drawingBoxH);
        temp.copy(video, int(hiro[1].x)+skip,int(hiro[1].y)+skip, (int)drawingBoxW-2*skip, (int)drawingBoxH-2*skip, 0, 0, (int)drawingBoxW, (int)drawingBoxH);
        temp.loadPixels();
        
  /**********************END anti rotation*************************************/
  
  /*********************start background removal***********************/     
        //initialize for background removal
        maxN=drawingBoxW*drawingBoxH;
        println("this is MaxN:",maxN);
        dbW=drawingBoxW;
        dbH=drawingBoxH;
        thePixels=new int[maxN];
        for(int i=0;i<maxN;i++)
        thePixels[i]=-1;
        theCurrent.clear();
        theFollowing.clear();
  
        // let's grab a pixel from the top left assume it is a "white" pixel - anything close to this pixel color can be removed
        whiteBg1 = temp.pixels[ 10 + 10*temp.width];
        whiteR1 = red(whiteBg1);
        whiteG1 = green(whiteBg1);
        whiteB1 = blue(whiteBg1);
        
        // also grab one from the bottom right - this lets us smooth things out if there are shadows on the image
        // (so we have two shades of white to compare to)
        whiteBg2 = temp.pixels[ temp.width-10 + (temp.height-10)*temp.width];
        whiteR2 = red(whiteBg2);
        whiteG2 = green(whiteBg2);
        whiteB2 = blue(whiteBg2);
        
        //background removal
        int i=0;
        while (!pixelIsWhite(i))
        {
          thePixels[i]=0;
          i++;
        }
        theCurrent.append(i);
        thePixels[i]=1;
        search(i);
        
        //using the map to copy the non-background part to finalImage
        finalImage=new PImage(dbW,dbH,ARGB);
        finalImage.loadPixels();
        for (i=0;i<maxN;i++)
        if (thePixels[i]!=1)
        finalImage.pixels[i]=temp.pixels[i];
     /*-----------------------end background removal--------------------------*/
        
     /******************START shrink the image vertically********************/
        i=0;
        while (finalImage.pixels[i]==0)
        i++;
        int startH=posY(i);
        i=maxN-1;
        while (finalImage.pixels[i]==0)
        i--;
        int endH=posY(i);
        int maxH=endH-startH;
        sFinalImage= createImage(dbW,maxH,ARGB);
        sFinalImage.copy(finalImage,0,startH,dbW,maxH,0,0,dbW,maxH);
        imageMode(CENTER);
        image(sFinalImage,width/2,height/2);
        imageMode(CORNER);
     /*----------------------END shrink the image-------------------------------*/
    }
}

void search(int startingPoint)
{
  boolean finished=false;
  //stop when nothing happens after a loop
  int c=0;
  
  while(!finished)
  {
    finished=true;

    //visit every node in current
    for (int i=0;i<theCurrent.size();i++)
      {
        //get the node in theCurrent
        int t;
        t=theCurrent.get(i);
        int x=posX(t);
        int y=posY(t);
        //visit every node around it
        
        if (x<dbW-1&&thePixels[loc(x+1,y)]==-1)
        {
          int location=loc(x+1,y);
          //if there still is unscaned pixels, it's not over
          finished=false;
          //if the pixels is white, mark it as scanned and add the 
          //coordinates to theFollowing
          if (pixelIsWhite(location))
          {
            thePixels[location]=1;
            theFollowing.append(location);
          }
          else
          {
            thePixels[location]=0;
          }
        }
        if (y<dbH-1&&thePixels[loc(x,y+1)]==-1)
        {
          int location=loc(x,y+1);
          finished=false;
          if (pixelIsWhite(location))
          if (pixelIsWhite(location))
          {
            thePixels[location]=1;
            theFollowing.append(location);
          }
          else
          {
            thePixels[location]=0;
          }
        }
        if (x>0&&thePixels[loc(x-1,y)]==-1)
        {
          int location=loc(x-1,y);
          finished=false;
          if (pixelIsWhite(location))
          {
            thePixels[location]=1;
            theFollowing.append(location);
          }
          else
          {
            thePixels[location]=0;
          }
        }
        if (y>0&&thePixels[loc(x,y-1)]==-1)
        {
          int location=loc(x,y-1);
          finished=false;
          if (pixelIsWhite(location))
          {
            thePixels[location]=1;
            theFollowing.append(location);
          }
          else
          {
            thePixels[location]=0;
          }
        }
      }
      
    //update current with theFollowing
    theCurrent.clear();
    for (int i=0;i<theFollowing.size();i++)
      theCurrent.append(theFollowing.get(i)); 
    theFollowing.clear();
  }//while ends 
  
}
boolean pixelIsWhite(int loc)
{
  color tempColor=temp.pixels[loc];
  float r=red(tempColor);
  float b=blue(tempColor);
  float g=green(tempColor);
  return(dist(whiteR1, whiteG1, whiteB1, r, g, b) < threshold || dist(whiteR2, whiteG2, whiteB2, r, g, b) < threshold);
}

int loc(int x, int y)
{
  return(y*dbW+x);
}

int posX(int location)
{
  return(location%dbW);
}

int posY(int location)
{
  return(location/dbW);
}

