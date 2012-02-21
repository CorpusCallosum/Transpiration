class Elevator {
  int _currentFloor = 0;
  float _x, _startX, floorY;
  int numFloors = 26;
  PImage trunk;
  int ease = 40;
  
  boolean _hasMoved = false;

  ElevatorFloor[] elevatorFloors = new ElevatorFloor[numFloors];

  //Boolean _people = false;

  Elevator(float x) {
    println("made an elevator object");
    _startX = x;
    _x = x;

    //instantiate the floor objects
    for (int i=0;i<numFloors;i++) {
      float floorY = getFloorY(i);
      elevatorFloors[i] = new ElevatorFloor(i, _x, numFloors, floorY);
    }
    
  }

  void update() {
   
    //***DRAW ELEVATOR
    strokeWeight(5);
    float jit = .25;
    float nextX = _startX;// + random(-jit, jit);
    float yTarget = getFloorY(_currentFloor);
    floorY += (yTarget - floorY)/ease;
    line(_x, floorY, nextX, floorY-15);
    _x = nextX;
  }
  
  void setFloor(int eFloor) {
    if(_hasMoved){
      if(abs(eFloor - _currentFloor) == 1){
        _currentFloor = eFloor;
      }
    }
    else{
       _currentFloor = eFloor;
       _hasMoved = true;
    }
  }

  void setPeople(Boolean p) {

    if (p) {
      //people got on
      elevatorFloors[_currentFloor].getOn();
    }
    else {
       elevatorFloors[_currentFloor].getOff();
    }
  }

  float getFloorY(float fl) {
    
    //EXPONENTIAL
    float y = height - sqrt(fl/numFloors) *height;    
    return y;
  }
  
  int getFloor(){
     return _currentFloor; 
  }
  
  boolean getHasMoved(){
    return _hasMoved;  
  }
  
}

