#!/usr/bin/env python3
import time
import requests
import socket
import psutil
from datetime import datetime
try:
    from smbus2 import SMBus
    from bme280 import BME280
    BMEPRESENT = True
except ImportError:
    BMEPRESENT = False
try:
    from mics6814 import MICS6814
    MICSPRESENT = True
except ImportError:
    MICSPRESENT = False

LOOPSECS = 10
TRANSMITSECS = 5
STASHSAVESECS = 120

HOST = socket.gethostname()
PROTO = 'http://'
DBHOST = '192.168.0.12'
PORT = ':5010'
PATH = '/?'

STASH = []

def ts():
    """Make a kdb timespan for UTC now"""
    return datetime.utcnow().strftime("0D%H:%M:%S.%f")

def upd(data):
    """Send an update to the database"""
    ts, sym, host, units, data = data
    query = '.u.upd[`obs;(' + str(ts) + ';`' + str(sym) + ';`' + str(host) + \
        ';`' + str(units) + ';' + str(data) + ')]'
    try:
        r = requests.get(PROTO + DBHOST + PORT + PATH + query)
        return r.status_code
    except Exception:
        return -1

if __name__ == '__main__':

    # Temporary - disable MICS as the gas heater is throwing out
    # our temperature readings
    MICSPRESENT = False

    # Initialise the BME280 & MICS6814 breakouts, disable LEDs
    if BMEPRESENT:
        bus = SMBus(1)
        bme280 = BME280(i2c_dev=bus)
    if MICSPRESENT:
        gas = MICS6814()
        gas.set_brightness(0.0)
        gas.set_led(0, 0, 0)

    # Load any saved stashed values
    # TODO

    # Loop to keep sampling & sending to the DB
    while True:

        # Take measurements & stash them - make these strings??
        if BMEPRESENT: # If we have the BME chip, sample data
            STASH.append([ts(),'temperature',HOST,'C',bme280.get_temperature()])
            STASH.append([ts(),'pressure',HOST,'hPa',bme280.get_pressure()])
            STASH.append([ts(),'humidity',HOST,'pct',bme280.get_humidity()])
        if MICSPRESENT: # If we have the MICS chip, sample data
            STASH.append([ts(),'oxidising',HOST,'Ohms',gas.read_oxidising()])
            STASH.append([ts(),'reducing',HOST,'Ohms',gas.read_reducing()])
            STASH.append([ts(),'nh3',HOST,'Ohms',gas.read_nh3()])
        # Sample generic host load data
        STASH.append([ts(),'cpu',HOST,'pct',psutil.cpu_percent(percpu = False)])
        STASH.append([ts(),'cputemp',HOST,'C',psutil.sensors_temperatures()['cpu_thermal'][0].current])
        STASH.append([ts(),'mem',HOST,'pct',psutil.virtual_memory().percent])
        #print(str(STASH[-9:])) # Print our last samples

        # Try to transmit stashed data (and SOME of the last updates -
        #    so ex. generate 6 every time, try to send 30)
        # TODO: batch this up
        # TODO: move to thread? will lock up otherwise while sending
        # TODO: every STASHSAVESECS, persist to disk
        TEMPSTASH = []
        for obs in STASH:
            response = upd(obs)
            if (response != 200): # Failed, add it back into the stash
                TEMPSTASH.append(obs)
        STASH = TEMPSTASH

        time.sleep(LOOPSECS)