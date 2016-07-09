## Overview

This directory is for code (a) to be uploaded into the micro-controller to run
the DHT humidity-temperature (qt) sensor, (b) to send queries to the
micro-controller and to process the results and store in an sqlite file, (c) to
plot the results. Note that (b) and (c) are run by daemons.

## Directories and files contained here

* DHT_Unified_Sensor/ -- code found online; it demonstrates broader usage
* README.md -- this file
* arduino_controller/ -- arduino code to be uploaded to the arduino micro-controller
* database/ -- has .sql code and a Makefile to create an sqlite database named qt.db
