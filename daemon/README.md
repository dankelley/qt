**Daemon setup (OSX)**

Before you do anything here, you must first set up the Arduino and the database
as explained in `arduino/README.md` and in `database/README.md`, and you must
have taken note of the file location of the database and also the `/dev`
identifier for the USB port to which the Arduino is connected.

*Step 1.* Test the code locally before doing anything else. Do that by typing
e.g.

    python qt_controller.py 1 /dev/tty.usbmodem5D11 ~/Dropbox/databases/qt.db

where the last two arguments will be different for you, since both your home
directory and (likely) your USB ports will differ.  (My home port is 1421, my
work port is 5D11, as shown.)

If you get the error message

    Traceback (most recent call last):
      File "qt_controller.py", line 6, in <module>
        import serial
    ImportError: No module named serial

you must install the `pyserial` python package, e.g. by

    sudo pip install pyserial

or, to upgrade, by 

    sudo pip install --upgrade pyserial

Other python trouble-shooting I leave to you.  Once you have things working,
there should be a data entry in the database. Check that by typing

    echo '.dump' | sqlite3 ~/Dropbox/databases/qt.db 

in a terminal. There should be an insertion into the `observations` table. That
means that the python setup is ok.

*Step 2.* Edit `org.qt.controller.plist` as appropriate, to name the python
file that receives data from the Arduino and stores it in the database.  You
will also have to use the correct `dev/` name for the USB port to which the
Arduino is connected, of course.

*Step 3.* Install the launch daemon, by executing

    sudo cp org.qt.controller.plist /Library/LaunchDaemons

in a terminal. Then, start the daemon with

    sudo launchctl load /Library/LaunchDaemons/org.qt.controller.plist 

to set the code up to work. After this, no action will be required (since the
daemon will get launched at boot time, in future).


*Step 4.* Check that the daemon is working

The status is retrieved by

    sudo launchctl list | grep qt

where the second column lists 0 for working or 1 for failing.

After the daemon has been running for 10 minutes (by default), it will acquire
a datum. So, after say 25 minutes you should have a couple of data points, and
the output

    echo '.dump' | sqlite3 ~/Dropbox/databases/qt.db | grep 'INSERT INTO "observations"'

will display the entries.  The first few entries will be from your initial
tests (if you did any), and after that the entries should be on regular
intervals. The data are easy to read: the first item is an id, the second is
the station code, the third is the number of seconds since Jan 1, 1970, the
fourth is the relative humidity in percent, and the fifth and last is the
temperature in degreeC.

If you have no data, then you'll need to troubleshoot. The most likely
candidate for problems is your python setup (which is taken to be that from
homebrew with python in `/usr/local/lib`, in the present system).


**Troubleshooting.**


*Stopping the daemon*

To stop the process, execute

    sudo launchctl unload /Library/LaunchDaemons/org.qt.controller.plist 

in a terminal. It will still get restarted at reboot, so if you wish to remove
the action entirely, remove that `.plist` file by executing

    sudo rm /Library/LaunchDaemons/org.qt.controller.plist 


*Interrupting the daemon*

If you want to alter the code in the Arduino, you will need to interrupt the
daemon, so that the Arduino software will be able to communicate over the USB
port. Just unload it and load it again, as explained above.


*Diagnosing problems*

It might help to use

    tail -f /private/var/log/system.log

(or a GUI interface to `system.log`) to find any problems with the running of
the daemon.

