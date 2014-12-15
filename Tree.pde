class Tree extends Animal
{
  
  float treeSize=random(3,10);
  float currentSize=0;
  Tree()
  {
    xSpeed =0;
    ySpeed =0; 
    xSize=50*treeSize/10;
    ySize=50*treeSize/10;
    sound = false; 
  }  

  void display()
  {
    if (alive)
    {
      pushMatrix();
      
      translate(-1*position3D.x, -1*position3D.y, 1); 
      if (!released)
      {
        fill(203, 203, 0, 100);
        ellipse(0, 0, xSize, ySize);
      }
      else//released
      {
        if (currentSize<treeSize)
        currentSize+=0.2;
        scale(currentSize);
        pushMatrix();
        rotateX(radians(90));
        shape(trunk);
        popMatrix();//rotateX(radians(90));
        
        //leaves
        pushMatrix();
        translate(1, 0, 5);
        rotateX(radians(90));
        shape(leaves);
        popMatrix();//translate(1, 0, 5);
      }
      popMatrix();//translate(-1*position3D.x, -1*position3D.y, 1)
   }
  }
} 

