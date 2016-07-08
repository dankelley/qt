import sys
import socket
import serial
from time import sleep, time
from string import atoi
DEBUG = False 
# FIXME: database work
if 5 != len(sys.argv):
    print "Usage examples:"
    print "  python " + sys.argv[0] +  " 1 10 60 /dev/tty.usbmodem1421   # home"
    print "i.e. station_code=1, sample_delta_t=10, sample_average_interval=60, device=/dev/tty.usbmodem1421"
    exit(2)
this_station_id = skyview_secret.station_id[secret_station_id]
this_station_code = skyview_secret.station_code[secret_station_id]
sampling_interval = atoi(sys.argv[2])
reporting_interval = atoi(sys.argv[3])
usb = sys.argv[4]
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
ser.write('>')
sleep(0.1)
first_newline = True
cbuf = ""
max = int(round(reporting_interval / sampling_interval))
times = []
values = []
while (True):
    sleep(0.01) # perhaps this is good for avoiding overtalking?
    c = ser.read(1)
    if len(c) > 0:
        if c == '\n':
            if first_newline:
                first_newline = False
            else:
                values.append(atoi(cbuf))
                times.append(time())
                if len(values) == max:
                    light_mean, light_stdev = meanstd(values)
                    time_mean, time_stdev = meanstd(times)
                    #print int(round(time_mean)), int(round(light_mean)), int(round(light_stdev))
                    msg = "%d %4s %d %d %d" % (
                            this_station_id, this_station_code, int(round(time_mean)), int(round(light_mean)), int(round(light_stdev)))
                    if DEBUG:
                        print msg
                    sock.sendto(msg, (skyview_secret.aggregator_ip, skyview_secret.aggregator_port))
                    times = []
                    values = []
            ser.write('>')
            sleep(sampling_interval)
            cbuf = ""
        else:
            cbuf = cbuf + c
