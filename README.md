# qt (humidity-temperature) sensor logger

## 1. Arduino setup

A wiring scheme that I found to work is on
[garagelab](http://garagelab.com/profiles/blogs/tutorial-humidity-and-temperature-sensor-with-arduino)
but even if that link breaks, you'll be able to find lots of material online.

Once it is set up, you need to compile the controller code and install it in the arduino. The code is in

    code/arduino_controller/arduino_controller.ino

and you should be able to load that straight into the arduino application. Then
try compiling it. Most likely you will have missing libraries. Use the menu
item `Sketch>Include Library>Manage Libraries`, then enter "DHT" in the search.
This should show several items. I installed `DHT sensor library` and tried
compiling again. It is quite difficult to locate libraries because of an odd
naming scheme, and I think the best advice is to try a compile, note any errors
in finding libraries, do a web search to find the actual name of the library,
and then install that. Since your system is likely to be set up differently
from mine, I'll leave it to you to learn how to install the libraries. It
should not be hard for anyone with even slight experience with arduino work.

Once it compiles, try downloading it into the arduino, and then check the
serial monitor using the menu item **Tools>Serial Monitor**. Note that you may
need to set the port, first; again, there's a menu item for that.  **Take note
of the port name** because you'll need it later, to tailor the LaunchDaemons
that control data aggregation. On my home machine, I found the port to be
called `/dev/cu.usbmodem1421`.

Once you've seen that it is sampling (a new set of numbers appearing on the
monitor a few times per minute) you should close the arduino application Then,
try typing

    cat /dev/cu.usbmodem1421

in the unix console to check again that things are working.


## 2. Database setup

The qt system stores data in an sqlite3 database, using a python script to read
the arduino output. That script is controlled by a launch daemon. I've set this
all up on OSX, and the scheme in other systems should be analogous.

Type the following in a terminal, to set up the database

    cd code/database
    make create
    cd ..

and then check that you have a newly-created flle named

    database/qt.db

If you want to store the databae somewhere else, you'll need to alter the code
in LaunchDaemons and other spots, too.

## 3. Plotting to the web

FIXME: write something here. I'll use R and a crontab, to create graphs and put
them on the web.


