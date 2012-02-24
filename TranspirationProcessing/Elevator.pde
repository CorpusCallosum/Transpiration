class Elevator {
  int _maxFloorDifference = 2; // tests to see if floor change is less than this value
  
  int _currentFloor = 0;
  float _x, _startX, floorY;
  int numFloors = 27;
  PImage trunk;
  int ease = 40;
  
  boolean _hasMoved = false;

  ElevatorFloor[] elevatorFloors = new ElevatorFloor[numFloors];

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
    //TEST FOR FLOOR DIFFERENCE
    if(_hasMoved){
      if(abs(eFloor - _currentFloor) <= _maxFloorDifference){
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
  
  void setMaxFloorDifference(int m){
    _maxFloorDifference = m; 
  }
  
}

