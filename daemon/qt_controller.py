# NOTE: you will need to alter the USB device name and the database name for this to work.

import sys
import socket
import serial
import datetime
from time import sleep, time
from string import atoi, atof
import sqlite3

DEBUG = True
# FIXME: database work
if 4 != len(sys.argv):
    print "Need 4 arguments; usage examples:"
    print "  python " + sys.argv[0] +  " 1 10 /dev/tty.usbmodem1421   # home"
    print "i.e. station_code=1, aggregate=10, device=/dev/tty.usbmodem1421"
    exit(2)
station_code = atoi(sys.argv[1])
aggregate = atoi(sys.argv[2])
usb = sys.argv[3]


## Connect to database. NB: the database will need to be adjusted for other users.
conn = sqlite3.connect("/Users/kelley/qt/database/qt.db")
if not conn:
    print 'cannot open database /Users/kelley/qt/database/qt.db'
    exit(2)
curr = conn.cursor()

def meanstd(x):
    from math import sqrt
    n, mean, std = len(x), 0, 0
    for a in x:
        mean = mean + a
    mean = mean / float(n)
    for a in x:
        std = std + (a - mean)**2
    std = sqrt(std / float(n-1))
    return mean, std

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
baud = 9600
ser = serial.Serial(usb, baud)
sleep(1.0) # no need for a high data rate
first_newline = True
t = []
q = []
cbuf = ""
while (True):
    sleep(1.0) # perhaps this is good for avoiding overtalking?
    c = ser.read(1)
    if len(c) > 0:
        # Accumlate 'c' into 'cbuf', and process at end of line
        if c == '\n':
            if first_newline:
                first_newline = False
            else:
                data = cbuf.split(" ")
                if 2 == len(data):
                    ## checking the length prevents problems with partial lines
                    t.append(atof(data[0]))
                    q.append(atof(data[1]))
                    if len(t) == aggregate:
                        t_mean, t_stdev = meanstd(t)
                        q_mean, q_stdev = meanstd(q)
                        #sec = int(round(time()))
                        sec = int(round((datetime.datetime.utcnow()-datetime.datetime(1970,1,1)).total_seconds()))
                        msg = "%d %d %.2f %.2f %.2f %.2f" % (
                                station_code, sec, t_mean, t_stdev, q_mean, q_stdev)
                        if DEBUG:
                            print msg
                        sql = """insert into observations(station_code,time,t,q) VALUES (%d,%d,%f,%f)""" % (station_code, sec, t_mean, q_mean)
                        if DEBUG:
                            print sql
                        curr.execute(sql)
                        conn.commit()
                        t = []
                        q = []
            cbuf = ""
        else:
            cbuf = cbuf + c
