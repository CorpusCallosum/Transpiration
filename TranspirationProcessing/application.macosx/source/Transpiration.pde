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
long _time = 0;
long _lastTime = 0;
long _nextEventTime = 0;
long _startTime = 0;


void setup() {
  size(960, 600);
frame.setBackground(new java.awt.Color(0, 0, 0));
//load the data
  events = loadStrings("data3.txt");
  println(events);

  tree = new Tree(width*.5);
  background(0);
  
  //get first time stamp
  try {
      event = new JSONObject(events[0]);
       _startTime = event.getLong("timestamp");
    }
    catch (JSONException e) {
      println ("There was an error parsing the JSONObject.");
      println(e);
    };
    
}

void draw() {
  blurCnt++;
  _time = millis();
  _time *= 1000;
  _time += _startTime;

  
  /*if (blurCnt == blurSpeed) {
   blurCnt = 0;
   filter(BLUR, 10);
   colorMode(HSB);
   tint(255,100);
   colorMode(RGB);
   }*/

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
     
      println("current event time:"+_nextEventTime);
      println("time passed:       "+_time);
     

     // if (_time >= _nextEventTime) {
        println("time >= _time)");
          _nextEventTime = event.getLong("timestamp");
           
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
        
     // }
      
    }
    catch (JSONException e) {
      println ("There was an error parsing the JSONObject.");
      println(e);
    };
    
    tree.update();
    i++;
  }
  else{
   i = 0; 
  }

  stroke(0);
  fill(0, 50);
  rect(0, 0, width, height);
  blurCnt++;
}

void sat() {
  colorMode(HSB);
  for (int i = 0; i< width*height;i++) {
    pixels[i] = color(hue(pixels[i]), saturation(pixels[i])-10, brightness(pixels[i]));
  }
  colorMode(RGB);
}

