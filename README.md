# Setting up the qt (humidity-temperature) logger

## 1. Arduino setup

Several sites explain the wiring; I used
[garagelab](http://garagelab.com/profiles/blogs/tutorial-humidity-and-temperature-sensor-with-arduino)
and it worked fine, even though the pull-up resistor I had was the wrong
resistance (I think ... I don't have docs on the actual sensor I'm using,
though).

Once it is set up, you need to compile the controller code and install it in
the Arduino. The Arduino code (or "sketch") is in

    arduino/arduino_controller.ino

so your first step will be to try compiling this in the arduino application.
If you have missing libraries, use the menu item `Sketch>Include Library>Manage
Libraries`, then enter "DHT" in the search. I installed `DHT sensor library`
from that list, found other things missing, and went into a search-install
cycle about which I took no notes. If this is too daunting, you should give up
now, because more complicated steps are to follow.

Once the sketch compiles, try downloading it into the Arduino, and then check
the serial monitor using the menu item **Tools>Serial Monitor**. Note that you
may need to set the port, first; again, there's a menu item for that.  **Take
note of the port name** because you'll need it in later steps.  (On my home
machine, I found the port to be called `/dev/cu.usbmodem1421`.)

Once you've seen that it is sampling (a new set of numbers appearing on the
monitor a few times per minute) you should close the arduino application Then,
try typing

    cat /dev/cu.usbmodem1421

in the unix console to check again that things are working.


## 2. Database setup

Read and follow the instructions in

    database/README.md

To see what's in the file, type

    echo '.dump' | sqlite3 database/qt.db 

If you want to store the database somewhere else, you'll need to alter the code
in LaunchDaemons and other spots, too.

## 3. Daemon setup

Read and follow the instructions in

    daemon/README.md


## 4. Plotting setup

Read and follow the instructions in

    plotting/README.md

