
//use ArrayList to store the nodes
IntList theCurrent=new IntList();
IntList theFollowing=new IntList();
//key and mouse presses
void keyPressed()
{
  if (key == '+' || key == '=')
  threshold++;
  if (key == '-')
  threshold--;
  if(key == 'z' || key =='Z')
  state = 2; 
  if(key == 's' || key == 'S')
  {
    state = 1;
    selected=false;
  }
if (key == CODED)
{
  println("animalCounter is ", animalCounter);
 if (keyCode == RIGHT){
  if (currentAnimalNumber<(animalCounter-1))
  {
  println(currentAnimalNumber,"plused");
  currentAnimalNumber++;
  }
  else currentAnimalNumber=0;
 }
 else if (keyCode == LEFT){
  if (currentAnimalNumber>0)
  {
    println(currentAnimalNumber,"minused");
  currentAnimalNumber--;
  }
  else currentAnimalNumber=animalCounter-1;
 } 
  println(currentAnimalNumber);
}

if((key=='a' || key =='A')&& state == 1)
{
 //create a new animal 
 println("Character Created!"); 
/**^^^^^^^^^^^^newly added^^^^^^^^**/
 state = 2;
}

}

