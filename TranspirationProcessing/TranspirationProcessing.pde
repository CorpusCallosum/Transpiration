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

import oscP5.*;
import netP5.*;

OscP5 oscP5;

//set resolution
int w = 1550;
int h = 720;
//int w = 1280;
//int h = 800;

//Send messages to tree
void oscEvent(OscMessage msg) {
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



void setup() {
  
  noCursor();
  
  oscP5 = new OscP5(this, 10240);
  
  size(w, h);
 frame.setBackground(new java.awt.Color(0, 0, 0));

//Create the Tree object
  tree = new Tree(width*.5);
  background(0);
}

void draw() {
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

void keyPressed() {
  if (key == 'r') {
    //RESET
    tree.reset(); 
  }
}
