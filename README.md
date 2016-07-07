# qt (humidity-temperature) sensor logger

## Setup

### Install DHT library

**OLD**
I think it should be possible to install this library from within the arduino
application, but could not see how, so instead I found the Adafruid DHT library
on the web, downloaded it, renamed the resultant file 'DHT' and did
```
mv DHT ~/Documents/Arduino/libraries/
```
to install it on OSX ... on other machines, the location will differ, of course.

Then, I restarted the arduino app, and the DHT library was in the
`Sketch/Include Library` menu.


**NEW** Oh, Now I see the way to do this within the arduino app: menu
`Sketch/Include Library/Manage Libraries`, then enter "DHT" in the search. There are 3 options: `Adafruit DHT Unified`, `DHT sensor library` and `SimpleDHT`. The first two are by Adafruit, so let's skip the third. The first has the name Adafruit in it, so I'll take a guess and try that first ... may need to update this later...

### see if it samples

At the [Adafruit_DHT_Unified github
page](https://github.com/adafruit/Adafruit_DHT_Unified), I found an example, downloaded here to `DHT_Unified_Sensor/DHT_Unified_Sensor.ino`.

This fails to run until we go into the menus to set the com port.

Then it just fails to acquire data.


# References

* [tutorial including wiring](http://garagelab.com/profiles/blogs/tutorial-humidity-and-temperature-sensor-with-arduino)


