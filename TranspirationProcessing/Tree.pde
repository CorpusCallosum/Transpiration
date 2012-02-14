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
    e1 = new Elevator(_x-6);  
    elevators[0] = e1;
    e2 = new Elevator(_x-2);
    elevators[1] = e2;
    e3 = new Elevator(_x+2);
    elevators[2] = e3;
    e4 = new Elevator(_x+6);
    elevators[3] = e4;

    //instantiate the floor objects
    for (int i=0;i<numFloors;i++) {
      float floorY = getFloorY(i);
      elevatorFloors[i] = new ElevatorFloor(i, _x, numFloors, floorY);
    }

    trunk = loadImage("tree.png");
    _bg = loadImage("Tree_Scene_Frame_v04.png");


    //make a bunch of grass
    for (int i=0;i<_numGrass;i++) 
      grasses[i] = new Grass(random(0, width), random(5, 25));
    }

  void update() {

    //redraw the trunk 
    int w = 83;

    /* image(trunk, _startX-200, 0, w, height+50);
     image(trunk, _startX-400, 0, w, height+50);
     image(trunk, _startX-600, 0, w, height+50);
     image(trunk, _startX-300, 0, w, height+50);
     image(trunk, _startX-350, 0, w, height+50);*/

    //bg image
    image(_bg, 0, 0,width,height);
    //update the floors
    for (int i=0;i<numFloors;i++) {

      float windVariety = random(-.01, .01)/10;
      elevatorFloors[i].update(_wind+windVariety);
    }

    
    image(trunk, _x-w/2-5, 0, w, height);


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
    //LINEAR
   // float y = height - (fl/numFloors * height);
    
    //EXPONENTIAL
    float y = height - sqrt(fl/numFloors) *height;
    
    //LOGARITHMIC
    // natural logarithm
/*float exponent = log(fl/numFloors);

// reverse natural logarithm - "antilog"
float check = pow((float)Math.E, exponent);
println("pow (E, exponent)  = " + check);
    
    float y = height - check *height;*/
    
    return y;
  }
}

