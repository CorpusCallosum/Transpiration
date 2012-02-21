import processing.core.*; 
import processing.xml.*; 

import oscP5.*; 
import netP5.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class TranspirationProcessing extends PApplet {

//SETUP VARS
int numFloors = 27;
String[] events;
int i = 0;
int blurSpeed = 1;
int blurCnt = 0;
Tree tree;
long _lastTime = 0;
long _nextEventTime = 0;
long _startTime = 0;
long _timeOffset;




OscP5 oscP5;

//set resolution
int w = 1550;
int h = 720;
//int w = 1280;
//int h = 800;

//Send messages to tree
public void oscEvent(OscMessage msg) {
  if (msg.addrPattern().equals("/elevator/floor")) {
     //FLOOR EVENT
    int elevator = msg.get(0).intValue();
    int floorNumber = msg.get(1).intValue();
    println("Elevator "+elevator+" is now on floor "+floorNumber);
    //ADD CONTROL FOR BAD ELEVATOR DATA
    if(floorNumber >= 0 ){
      if(floorNumber <= numFloors){
        tree.setFloor(elevator, floorNumber);
      }
    }
  } else if (msg.addrPattern().equals("/elevator/people")) {
    //PEOPLE EVENT
    int elevator = msg.get(0).intValue();
    int people = msg.get(1).intValue();
    if (people == 0) {
      //PEOPLE GOT OFF
      println("Elevator "+elevator+" is empty");
      tree.setPeople(elevator, false);
    } else {
      //PEOPLE GOT ON
      println("Elevator "+elevator+" is occupied");
      tree.setPeople(elevator, true);
    }
  }
}



public void setup() {
  
  noCursor();
  
  oscP5 = new OscP5(this, 10240);
  
  size(w, h);
 frame.setBackground(new java.awt.Color(0, 0, 0));

//Create the Tree object
  tree = new Tree(width*.5f);
  background(0);
}

public void draw() {
  //UPDATE
  tree.update();
  
  //FADE EFFECT
  stroke(0);
  fill(0, 50);
  rect(0, 0, width, height);
  
  //GET CURRENT TIME, RESET AT 5PM EACH DAY
  if(hour() == 17){
    if(minute() == 0){
      if(second() == 0){
       tree.reset(); 
      }
    }
  }
}

public void keyPressed() {
  if (key == 'r') {
    //RESET
    tree.reset(); 
  }
}
class Branch {
  //subclass instantiated by Elevator for each floor
  //used to keep track of floor activity, and effect the curlinessof branch fractility

  //START BRANCH LENGTH
  float defaultGrowth = 10;
  float growthTarget = defaultGrowth;
  //MAX branch length
  float growthMax = 11.5f;
  //GROWTH RATE
  float growthRate = 1;


  float curlx = 0; 
  float curly = 0; 
  float f; 
  float deley = 10; 
  float growth = 0; 
 
  int branch, _fl, _cnt;
  float _x, _y, curlLength, _dir;
  int _detail = 2;
  int _c1 = 255;
  int _c2 = 255;
  int _c3 = 255;

  Branch(int fl, float x, float y) {
    //constructor
    _fl = fl;
    _x = x;
    _y = y;

    //decide branch direction
    float r = 0;

    if (fl%2 == 0) {
      _dir = 1 + random(-r, r);
    }
    else {
      _dir = -1 + random(-r, r);
    }

    curlLength = map(_fl, 1, 26, 3, 5);
    curlLength += random(-r, r);
  }

  public void drawBranch() {
    _cnt = 0;
    f = sqrt(2)/curlLength; 

    // translate(width/2,height/3*2); 
    // background(250);
  //  stroke(_c1);
   // colorMode(HSB);
   
    strokeWeight(1.5f);
    fill(255, 255, 255, 50);
    //curlx += (radians(360.f/height*mouseX)-curlx)/deley;
    //curly += (radians(360.f/height*mouseY)-curly)/deley;

    curlx += (radians(360.f/height*10*_dir)-curlx)/deley;
    curly += (radians(360.f/height*2)-curly)/deley;

    pushMatrix();
    translate(_x, _y);
          //rotate(-200*_dir);

    branch(height/5.f, 17);
    popMatrix();

    growth += (growthTarget/10-growth+.1f)/deley;
    
  }

  public void branch(float len, int num) 
  { 
   //  _c1 += (255-_c1)/50;
   // _c2 += (255-_c2)/50;
   // _c3 += (255-_c3)/50;
    stroke(_c1,_c2,_c3);
    //  stroke(0, 150, 0, 90);
    // println("branch");
    len = len*f*1.35f; 
    num -= 1; 
    if ((len > _detail) && (num > 0)) 
    { 
      //      if (blurCnt == blurSpeed) {
      //        blurCnt = 0;
      //        filter(BLUR, 1);
      //      }
      pushMatrix(); 
      rotate(curlx*10);

      line(0, 0, 0, -len-8); 
      translate(0, -len); 
      branch(len, num); 
      popMatrix(); 

      //    pushMatrix(); 
      //    line(0,0,0,-len); 
      //    translate(0,-len); 
      //    branch(len); 
      //    popMatrix(); 
      if(_cnt > 0){
        len *= growth; 
        pushMatrix(); 
        rotate(curlx-curly); 
        line(0, 0, 0, -len-5); 
        translate(0, -len); 
        branch(len, num); 
        popMatrix(); 
      }
      //len /= growth;
    }
    _cnt++;
  }

  public void grow() {
    if (growthTarget < growthMax) {
      growthTarget += growthRate;
      curlLength += growthRate/100;
      curlx += growthRate/20;
      curly += growthRate/20;
    }
  }

  public void shrink() {
    growthTarget -= growthRate;
    curlLength -= growthRate/100;
    curlx -= growthRate/20;
    curly -= growthRate/20;
  }
  
  //SHIVER IN THE WIND
  public void setWind(float wind){
    curlx += wind;
  }
  
  //RESET
  public void reset(){
    //RESET BRANCH SIZE
    growthTarget = defaultGrowth;
  }
}

class Elevator {
  int _maxFloorDifference = 2; // tests to see if floor change is less than this value
  
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

  public void update() {
   
    //***DRAW ELEVATOR
    strokeWeight(5);
    float jit = .25f;
    float nextX = _startX;// + random(-jit, jit);
    float yTarget = getFloorY(_currentFloor);
    floorY += (yTarget - floorY)/ease;
    line(_x, floorY, nextX, floorY-15);
    _x = nextX;
  }
  
  public void setFloor(int eFloor) {
    //TEST FOR FLOOR DIFFERENCE
    if(_hasMoved){
      if(abs(eFloor - _currentFloor) == _maxFloorDifference){
        _currentFloor = eFloor;
      }
    }
    else{
       _currentFloor = eFloor;
       _hasMoved = true;
    }
  }

  public void setPeople(Boolean p) {

    if (p) {
      //people got on
      elevatorFloors[_currentFloor].getOn();
    }
    else {
       elevatorFloors[_currentFloor].getOff();
    }
  }

  public float getFloorY(float fl) {
    
    //EXPONENTIAL
    float y = height - sqrt(fl/numFloors) *height;    
    return y;
  }
  
  public int getFloor(){
     return _currentFloor; 
  }
  
  public boolean getHasMoved(){
    return _hasMoved;  
  }
  
  public void setMaxFloorDifference(int m){
    _maxFloorDifference = m; 
  }
  
}

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

public void update(float wind) {
    //update the floor
    //draw the branch
    if(_id > 1){
    _branch.drawBranch();
    _branch.setWind(wind);
    }
}

public void getOff() {
  //someone gets off the elevator
  //people:false
  //make branch recurse more
  _branch.grow();
  
}

public void getOn() {
  //someone gets on the elevator at this floor
  //people:true
  _branch.shrink();
}

public void reset(){
  _branch.reset(); 
}


}
class Grass{
 
  float _x, _h, _xTarget;
  float _x2 = 0;
  
  Grass(float x, float h){
    _x = x;
    _h = h;
    _x2 = x;
    update();
  }
  
  public void update(){
    strokeWeight(1);
    _xTarget = _x+random(-5,5);
    _x2 += (_xTarget - _x2)/10;
    line(_x, height, _x2, height-_h); 
  }
  
}
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

  public void update() {

    //redraw the trunk 
    int w = 146;

    //bg image
    image(_bg, 0, 0,width,height);
    
    //update the floors
    for (int i=0;i<numFloors;i++) {
      float windVariety = random(-.01f, .01f)/10;
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

  public void setFloor(int e, int eFloor) {
    elevators[e-1].setFloor(eFloor);
  }

  public void setPeople(int e, Boolean p) {
    int fl = elevators[e-1].getFloor();
    if (p) {
      //people got on
      elevatorFloors[fl].getOn();
    }
    else {
      elevatorFloors[fl].getOff();
    }
  }

 public float getFloorY(float fl) {
    //EXPONENTIAL
    float y = height - sqrt(fl/numFloors) *height;
    return y;
  }
  
  //reset to default values
  public void reset(){
    //RESET ALL BRANCHES
    for (int i=0;i<numFloors;i++) {
      elevatorFloors[i].reset();
    }
  }
  
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "TranspirationProcessing" });
  }
}
