#!/usr/bin/env python3

import math
import time
from datetime import datetime
import colorsys
from mics6814 import MICS6814

DELAY = 0 # The chip itself is slow to update

mics = MICS6814()
mics.set_brightness(1)

for x in range(0,360):
  r,g,b = [int(c*255) for c in colorsys.hsv_to_rgb(x/360,0.75,1)]
  #print(str(x) + '* R:' + str(r) + ' G:' + str(g) + ' B:' + str(b))
  mics.set_led(r,g,b)
  time.sleep(DELAY)

mics.set_brightness(0.0)
mics.set_led(0,0,0)
