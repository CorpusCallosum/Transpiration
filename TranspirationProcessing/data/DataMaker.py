#DataMaker.py Generates fake elevator data for 240 Central Park South
#Author: Jack Kalish, November 26, 2011
#Version: .1

from datetime import datetime
from time import mktime
import random

numDataPoints = 10000
numFloors = 26
eventTypes = ["floor","door","people","arrow"];
 
"""
DATA FORMAT:
{
 timestamp: 754393459843, // seconds since unix epoch
 elevator: 3, // which elevator, number from 1-4
 type: "floor", // event type. options:
   // "floor" (floor # changed)
   // "door" (door opened/closed)
   // "people" (people or lack of people detected
   // "arrow" (arrow changed to up, down, or none)
 floor: 15 // extra parameters (depending on value of type). options:
   // floor: number (1-35) indicating which floor the elevator's now on
   // doorOpen: true / false
   // people: true / false
   // arrow: "up" / "down" / "none"
} """
 
#start array
print "{\"events\":["
for i in range(numDataPoints):
	print "{"
	#TIMESTAMP
	t=datetime.now()
	t=mktime(t.timetuple())+1e-6*t.microsecond
	print "\"timestamp\":",
	print (t+i),
	print ","
	
	#ELEVATOR NUMBER
	print "\"elevator\":",
	print random.randint(1, 4),
	print ","
	
	#EVENT TYPE
	e = random.choice(eventTypes)
	print "\"type\": "+"\""+e+"\","
	
	#ADDITIONAL PARAMETERS FOR TYPE
	if e == "floor":
		print "\"floor\":",
		print random.randint(1, numFloors)
	elif e == "door":
		print "\"doorOpen\":",
		print random.choice(["true","false"])
	elif e == "people":
		print "\"people\":",
		print random.choice(["true","false"])
	elif e == "arrow":
		print "\"arrow\":",
		print "\""+random.choice(["up","down","none"])+"\""	
	#CLOSE BRACKET
	
	
	if i < numDataPoints-1:
		print "},"
		

print "}"
#end array
print "]}"
