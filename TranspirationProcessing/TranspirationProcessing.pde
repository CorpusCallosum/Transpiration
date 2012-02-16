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
    int elevator = msg.get(0).intValue();
    int floorNumber = msg.get(1).intValue();
    println("Elevator "+elevator+" is now on floor "+floorNumber);
    tree.setFloor(elevator, floorNumber);
  } else if (msg.addrPattern().equals("/elevator/people")) {
    int elevator = msg.get(0).intValue();
    int people = msg.get(1).intValue();
    if (people == 0) {
      println("Elevator "+elevator+" is empty");
      tree.setPeople(elevator, false);
    } else {
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

 // blurCnt++;
  /*if (blurCnt == blurSpeed) {
   blurCnt = 0;
   filter(BLUR, 10);
   colorMode(HSB);
   tint(255,100);
   colorMode(RGB);
   }*/
  tree.update();
  
  stroke(0);
  fill(0, 50);
  rect(0, 0, width, height);
}

/*
//Change color saturation?
void sat() {
  colorMode(HSB);
  for (int i = 0; i< width*height;i++) {
    pixels[i] = color(hue(pixels[i]), saturation(pixels[i])-10, brightness(pixels[i]));
  }
  colorMode(RGB);
}*/

