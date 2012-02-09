import org.json.*;

//Elevator e1, e2, e3, e4;
//Elevator[] elevators = new Elevator[4];
JSONObject data, event;
String[] events;
int i = 0;
int blurSpeed = 1;
int blurCnt = 0;
//int numElevators = 1;
Tree tree;
//long _time = 0;
long _lastTime = 0;
long _nextEventTime = 0;
long _startTime = 0;
long _timeOffset;



import oscP5.*;
import netP5.*;

OscP5 oscP5;

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
  
  
  
  oscP5 = new OscP5(this, 10240);
  
  

  size(960, 600);
 frame.setBackground(new java.awt.Color(0, 0, 0));




//load the data
 // events = loadStrings("data3.txt");
 // println(events);

//Create the Tree object
  tree = new Tree(width*.5);
  background(0);
  
  //get first time stamp
  /*try {
      event = new JSONObject(events[0]);
       _startTime = event.getLong("timestamp");
    }
    catch (JSONException e) {
      println ("There was an error parsing the JSONObject.");
      println(e);
    };
    
    Date d = new Date();
    long _currentTime = d.getTime(); 
    
    //set the time offset
    _timeOffset = _currentTime - _startTime;
    println(i);
    */

}

void draw() {
      //  println(i);

 // blurCnt++;
  //_time = millis();
  //_time *= 1000;
  //_time += _startTime;
//Date d = new Date();
//long _currentTime = d.getTime();///1000; 

  
  /*if (blurCnt == blurSpeed) {
   blurCnt = 0;
   filter(BLUR, 10);
   colorMode(HSB);
   tint(255,100);
   colorMode(RGB);
   }*/
/*
  //loop through all the data points
  //update all the elevators

  if (i<events.length) {
    println(i);
    String eventType;
    try {
      event = new JSONObject(events[i]);
    }
    catch (JSONException e) {
      println ("There was an error parsing the JSONObject.");
      println(e);
    };

    try {
      int elevator = event.getInt("elevator");
     
      println("offset event time : " + _nextEventTime);
      println("current time      : " + _currentTime);
      println("event time        : " + (_nextEventTime - _timeOffset));


     // println("time passed:       " + _time);
     
    // _nextEventTime = event.getLong("timestamp") + _timeOffset;


     if (_currentTime >= _nextEventTime) {
     //   println("time >= _time)");
          _nextEventTime = event.getLong("timestamp") + _timeOffset;
           
      //  _lastTime = time;
        //only execute the event if we are past the event time
        eventType = event.getString("type");
        println("event type:"+eventType);
        if (eventType.equals("floor")) {
          //draw a line from the current position to the floor
          int floorNum = event.getInt("floor");
          if (floorNum <= 26) {
            if (floorNum >= 0) {
              tree.setFloor(elevator, floorNum);
            }
          }
        }
        else if (eventType.equals("people")) {
          println("set people");
          tree.setPeople(elevator, event.getBoolean("people"));
        }
        //iterate to the next event
            i++;

      }
      
    }
    catch (JSONException e) {
      println ("There was an error parsing the JSONObject.");
      println(e);
    };
    
    tree.update();
  }
  else{
    //loop back to start of file
   i = 0; 
  }
*/
  tree.update();
  
  stroke(0);
  fill(0, 50);
  rect(0, 0, width, height);
//  blurCnt++;
}

/*
void sat() {
  colorMode(HSB);
  for (int i = 0; i< width*height;i++) {
    pixels[i] = color(hue(pixels[i]), saturation(pixels[i])-10, brightness(pixels[i]));
  }
  colorMode(RGB);
}*/

