class Tree {
  int _currentFloor = 0;
  float _x, _startX;
  int numFloors = 27;
  PImage trunk, _bg;
  Elevator e1, e2, e3, e4;
  int numElevators = 4;

  float _wind = 0;
  float _windTarget = 0;

  Elevator[] elevators = new Elevator[4];
  ElevatorFloor[] elevatorFloors = new ElevatorFloor[numFloors];

  //grass
  int _numGrass = 500;
  Grass[] grasses = new Grass[_numGrass];

  Tree(float x) {
    println("made an elevator object");
    _startX = x;
    _x = x;

    //instantiate 4 elevator objects
    e1 = new Elevator(_x-12);  
    elevators[0] = e1;
    e2 = new Elevator(_x-4);
    elevators[1] = e2;
    e3 = new Elevator(_x+4);
    elevators[2] = e3;
    e4 = new Elevator(_x+12);
    elevators[3] = e4;

    //instantiate the floor objects
    for (int i=0;i<numFloors;i++) {
      float floorY = getFloorY(i);
      elevatorFloors[i] = new ElevatorFloor(i, _x, numFloors, floorY);
    }

    trunk = loadImage("images/hires/Just_Tree_wider.png");
    _bg = loadImage("images/hires/Tree_widerResolution.jpg");


    //make a bunch of grass
    for (int i=0;i<_numGrass;i++) 
      grasses[i] = new Grass(random(0, width), random(5, 25));
    }

  void update() {

    //redraw the trunk 
    int w = 146;

    //bg image
    image(_bg, 0, 0,width,height);
    
    //update the floors
    for (int i=0;i<numFloors;i++) {
      float windVariety = random(-.01, .01)/10;
      elevatorFloors[i].update(_wind+windVariety);
    }

    
    image(trunk, _x-w/2, 0);


    //***DRAW ELEVATORS
    for (int eCnt = 0; eCnt<numElevators;eCnt++) {
      elevators[eCnt].update();
    }    

    //get windy
    _windTarget = random(-1, 1);
    _windTarget /= 100;
    _wind += (_windTarget - _wind)/100;

    for (int gCnt=0; gCnt<_numGrass; gCnt++) {
      grasses[gCnt].update();
    }
  }

  void setFloor(int e, int eFloor) {
    elevators[e-1].setFloor(eFloor);
  }

  void setPeople(int e, Boolean p) {
    int fl = elevators[e-1].getFloor();
    if (p) {
      //people got on
      elevatorFloors[fl].getOn();
    }
    else {
      elevatorFloors[fl].getOff();
    }
  }

 float getFloorY(float fl) {
    //EXPONENTIAL
    float y = height - sqrt(fl/numFloors) *height;
    return y;
  }
  
  //reset to default values
  void reset(){
    //RESET ALL BRANCHES
    for (int i=0;i<numFloors;i++) {
      elevatorFloors[i].reset();
    }
  }
  
}

