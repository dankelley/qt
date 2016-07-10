**Daemon setup (OSX)**

Before you do anything here, you must first set up the Arduino and the database
as explained in `arduino/README.md` and in `database/README.md`, and you must
have taken note of the file location of the database and also the `/dev`
identifier for the USB port to which the Arduino is connected.

*Step 1.* Test the code locally before doing anything else. Do that by typing
e.g.

    python qt_controller.py 1 6 /dev/tty.usbmodem1421 /Users/kelley/qt/database/qt.db

(where the last two arguments will be different for you!) and see what happens.
After several minutes, data will appear in the database. You can see the data
by typing

    echo '.dump' | sqlite3 /Users/kelley/qt/database/qt.db 

in a terminal, where the last token will of course need adjustment for your
setup. If this does not work, you must find out why, before going on to the
next step.

*Step 2.* Edit `org.qt.controller.plist` as appropriate, to name the python
file that receives data from the Arduino and stores it in the database.  You
will also have to use the correct `dev/` name for the USB port to which the
Arduino is connected, of course.

*Step 3.* Set up the launch daemon, by executing

    sudo cp org.qt.controller.plist /Library/LaunchDaemons

in a terminal. Assuming that this works, then execute

    sudo launchctl load /Library/LaunchDaemons/org.qt.controller.plist 

to set the code up to work. After this, no action will be required (since the
daemon will get launched at boot time, in future).

**Stopping the daemon**

To stop the process, execute

    sudo launchctl unload /Library/LaunchDaemons/org.qt.controller.plist 

in a terminal. It will still get restarted at reboot, so if you wish to remove
the action entirely, remove that `.plist` file by executing

    sudo rm /Library/LaunchDaemons/org.qt.controller.plist 

**Interrupting the daemon**

If you want to alter the code in the Arduino, you will need to interrupt the
daemon, so that the Arduino software will be able to communicate over the USB
port. Just unload it and load it again, as explained above.


**Diagnosing problems**

If you get an error about not finding 'serial', execute

    sudo pip install pyserial

and retry.

You may use

    tail -f /private/var/log/system.log

to find any problems with the running of the daemon.

**Developer notes**

1. I'm not sure how to handle `KeepAlive`.
2. What to do when we cannot connect to USB? Right now, it will keep retrying, if `KeepAlive` is true, 
so I removed that.
