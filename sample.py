#!/usr/bin/env python3

import time
import requests
from datetime import datetime
from smbus2 import SMBus
from bme280 import BME280
from mics6814 import MICS6814

LOOPSECS = 1
TRANSMITSECS = 5
STASHSAVESECS = 120

PROTO = 'http://'
HOST = '192.168.0.12'
PORT = ':5099'
PATH = '/?'

def ts():
    """Make a kdb timespan for UTC now"""
    return datetime.utcnow().strftime("0D%H:%M:%S.%f")

def upd(ts,mtype,munit,measure):
    """Send an update to the database"""
    query = 'upd[`obs;(' + str(ts) + ';`' + str(mtype) + ';`' + str(munit) + ';' + str(measure) + ')]'
    r = requests.get(PROTO + HOST + PORT + PATH + query)
    return r.status_code

# Stash data
# Save stashed data
# Load stashed data (ex. on startup, in case we crash)

if __name__ == '__main__':

    # Initialise the BME280 & MICS6814
    bus = SMBus(1)
    bme280 = BME280(i2c_dev=bus)
    gas = MICS6814()

    # Load any saved stashed values

    while True:

        # Take measurements & send them
        temperature = bme280.get_temperature()
        upd(ts(),'temperature','C',temperature)

        pressure = bme280.get_pressure()
        upd(ts(),'pressure','hPa',pressure)
        
        humidity = bme280.get_humidity()
        upd(ts(),'humidity','pct',humidity)
        
        oxidising = gas.read_oxidising()
        upd(ts(),'oxidising','Ohms',oxidising)
        
        reducing = gas.read_reducing()
        upd(ts(),'reducing','Ohms',reducing)
        
        nh3 = gas.read_nh3()
        upd(ts(),'nh3','Ohms',nh3)

        # 1. Stash measurements
        # 2. Every TRANSMITSECS seconds, try to transmit stash
        #   a. If it worked, clear stash
        #   b. If it failed (r.status_code != 200), leave stash alone. Every STASHSAVESECS, persist to disk

        print('Temp:{:05.2f}*C Pres:{:05.2f}hPa Humd:{:05.2f}%  OX:{:05.2f}Ohms  RED:{:05.2f}Ohms  NH3:{:05.2f}Ohms '.format(temperature, pressure, humidity, oxidising, reducing, nh3))
        time.sleep(LOOPSECS)