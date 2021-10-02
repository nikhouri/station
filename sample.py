#!/usr/bin/env python3
import time
import requests
from datetime import datetime
from smbus2 import SMBus
from bme280 import BME280
from mics6814 import MICS6814
import psutil

LOOPSECS = 30
TRANSMITSECS = 5
STASHSAVESECS = 120

PROTO = 'http://'
HOST = '192.168.0.12'
PORT = ':5010'
PATH = '/?'

STASH = []

def ts():
    """Make a kdb timespan for UTC now"""
    return datetime.utcnow().strftime("0D%H:%M:%S.%f")

def upd(meas):
    """Send an update to the database"""
    mts, mtype, munit, measure = meas
    query = '.u.upd[`obs;(' + str(mts) + ';' + str(mtype) + ';' + str(munit) + \
        ';' + str(measure) + ')]'
    try:
        r = requests.get(PROTO + HOST + PORT + PATH + query)
        return r.status_code
    except Exception:
        return -1

if __name__ == '__main__':

    # Initialise the BME280 & MICS6814 breakouts, disable LEDs
    bus = SMBus(1)
    bme280 = BME280(i2c_dev=bus)
    gas = MICS6814()
    gas.set_brightness(0.0)
    gas.set_led(0, 0, 0)

    # Load any saved stashed values

    # Loop to keep sampling & sending to the DB
    while True:

        # Take measurements & stash them - make these strings??
        STASH.append([ts(),'`temperature','`C',bme280.get_temperature()])
        STASH.append([ts(),'`pressure','`hPa',bme280.get_pressure()])
        STASH.append([ts(),'`humidity','`pct',bme280.get_humidity()])
        STASH.append([ts(),'`oxidising','`Ohms',gas.read_oxidising()])
        STASH.append([ts(),'`reducing','`Ohms',gas.read_reducing()])
        STASH.append([ts(),'`nh3','`Ohms',gas.read_nh3()])
        STASH.append([ts(),'`cpu','`pct',psutil.cpu_percent(percpu = True)])
        STASH.append([ts(),'`cputemp','`C',psutil.sensors_temperatures()['cpu_thermal'][0].current])
        STASH.append([ts(),'`mem','`pct',psutil.virtual_memory().percent])
        #print(str(STASH[-9:]))

        # Try to transmit stashed data (and SOME of the last updates -
        #    so ex. generate 6 every time, try to send 30)
        # TODO: batch this up
        # TODO: move to thread? will lock up otherwise while sending
        # TODO: every STASHSAVESECS, persist to disk
        TEMPSTASH = []
        for meas in STASH:
            response = upd(meas)
            if (response != 200): # Failed, put it back into the stash
                TEMPSTASH.append(meas)
        STASH = TEMPSTASH

        time.sleep(LOOPSECS)