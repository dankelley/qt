# NOTE: you will need to alter the USB device name and the database name for this to work.

from __future__ import print_function
import sys
import socket
import serial
import datetime
from time import sleep, time
from string import atoi, atof
import sqlite3


DEBUG = False
# FIXME: database work
if 4 != len(sys.argv):
    print("Need 4 arguments; usage examples:")
    print("  python " + sys.argv[0] +  " 1 /dev/tty.usbmodem1421 /Users/kelley/databases/qt.db")
    print("i.e. station_code=1, device=/dev/tty.usbmodem1421, database=/Users/kelley/databases/qt.db")
    exit(2)
station_code = atoi(sys.argv[1])
usb = sys.argv[2]
db = sys.argv[3]


## Connect to database. NB: the database will need to be adjusted for other users.
conn = sqlite3.connect(db)
if not conn:
    print('cannot open database ' + db)
    exit(2)
curr = conn.cursor()
if DEBUG:
    print('opened database ' + db)

try:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
except:
    print('Failed to create socket; error code: ' + str(msg[0]) + ' , error message: ' + msg[1])
    sys.exit()
baud = 9600
try:
    ser = serial.Serial(usb, baud)
except:
    print('Failed to gain serial connection; error code: ' + str(msg[0]) + ' , error message: ' + msg[1])
    sys.exit()

first_newline = True
cbuf = ""
sleep(5) # device takes 2s to respond
line = ser.readline(20)
data = line.split(" ")
if 2 == len(data):
    ## checking the length prevents problems with partial lines
    t = atof(data[0])
    q = atof(data[1])
    ## missing-value code is -999 but we check inequality which is safer;
    ## also, check for high values (partial lines might do that, not sure).
    tOK = t > -900 and t < 50
    qOK = q > -900 and q < 101
    if tOK and qOK:
        sec = int(round((datetime.datetime.utcnow()-datetime.datetime(1970,1,1)).total_seconds()))
        sql = """insert into observations(station_code,time,t,q) VALUES (%d,%d,%f,%f)""" % (
                station_code, sec, t, q)
        if DEBUG:
            print(sql)
        curr.execute(sql)
        conn.commit()
    else:
        print("bad data at " + datetime.datetime.utcnow() + "UTC", file=sys.stderr)

