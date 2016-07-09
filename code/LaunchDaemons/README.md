**Initial setup (OSX)**

In a terminal, execute

    sudo cp org.qt.controller.plist /Library/LaunchDaemons
    sudo cp qt_controller.py /Library/LaunchDaemons

to store some code as a launch daemon. Then do

    sudo launchctl load /Library/LaunchDaemons/org.qt.controller.plist 

(or reboot the machine) to set the code up to work. After this, no action will
be required.

To stop the process, use

    sudo launchctl unload /Library/LaunchDaemons/org.qt.controller.plist 

and remove the files. (Note that you'll need to unload and reload, if you want
to download a new program into the arduino, because otherwise the USB line will
be blocked by this launch daemon.)


**Diagnosing problems**

If you get an error about not finding 'serial', do as follows and retry

    sudo pip install pyserial

Generally, use

    tail -f /private/var/log/system.log

to find any problems with the running of the daemon.

