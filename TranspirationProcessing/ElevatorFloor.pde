class ElevatorFloor {
  //subclass instantiated by Elevator for each floor
  //used to keep track of floor activity, and effect the curlinessof branch fractility
  int _id, _numFloors;
  Branch _branch;


  //constructor
  ElevatorFloor(int id, float x, int numFloors, float y) {
    _id = id;
    _numFloors = numFloors;
   // float y = getFloorY(id);
    _branch = new Branch(_id, x, y);
  }

void update(float wind) {
    //update the floor
    //draw the branch
    if(_id > 1){
    _branch.drawBranch();
    _branch.setWind(wind);
    }
}

void getOff() {
  //someone gets off the elevator
  //people:false
  //make branch recurse more
  _branch.grow();
  
}

void getOn() {
  //someone gets on the elevator at this floor
  //people:true
  _branch.shrink();
}

void reset(){
  _branch.reset(); 
}


}
