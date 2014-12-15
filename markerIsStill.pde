void markerIsStill(Animal[] a, int markerNumber, int timeThresh, int counter, int theMarker)
{   
    PVector[] position2D;
    int xCenter;
    int yCenter;
    a[counter-1].alive=true;
    
    position2D = augmentedRealityMarkers.getMarkerVertex2D(markerNumber);  
    xCenter = int(position2D[0].x + position2D[1].x + position2D[2].x + position2D[3].x)/4;
    yCenter = int(position2D[0].y + position2D[1].y + position2D[2].y + position2D[3].y)/4;

    if (dist(pxCenter, pyCenter, xCenter, yCenter)<10)
    markerTime++;
    pxCenter=xCenter;
    pyCenter=yCenter;

    //  if the marker has remained in the same position for 2 seconds, the animal is released;
    if (markerTime>timeThresh)
    { 
      a[counter-1].released=true;
      markerTime=0;
      if (markerNumber== treeMarkerNumber)
      {
        a[counter-1].position3D.x+=random(-40,40);
        a[counter-1].position3D.y+=random(-40,40);
        a[counter]=new Tree();
        treePlus=true;
      }
    }
    a[counter-1].position3D = augmentedRealityMarkers.screen2MarkerCoordSystem(theMarker, xCenter, yCenter);
              //compensate for the later tranlation
    a[counter-1].position3D.x+=offsetArray[theMarker].x;
    a[counter-1].position3D.y+=offsetArray[theMarker].y;
}
