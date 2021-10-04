# Observatory 
Python & kdb+tick environment logging.
```
q)select minv:min data, q1:pctile[25;data], medv:med data, q3:pctile[75;data], maxv:max data, rng:(max data - min data), iqr:(pctile[75;data]-pctile[25;data]) by host,sym,units from obs
host   sym         units| minv     q1       medv     q3       maxv     rng      iqr       
------------------------| ----------------------------------------------------------------
garden cpu         pct  | 1.5      1.7      1.7      1.8      50.9     49.4     0.1       
garden cputemp     C    | 29.324   29.324   29.324   29.862   31.476   2.152    0.538     
garden humidity    pct  | 69.71942 69.78379 69.85477 69.92609 98.46316 28.74374 0.142307  
garden mem         pct  | 23.2     23.3     23.3     23.3     23.3     0.1      0         
garden nh3         Ohms | 103582.5 103804.9 104027.9 104139.7 104363.6 781.1729 334.7868  
garden oxidising   Ohms | 183373.7 184125.7 184377.4 184629.6 185135.6 1761.951 503.9363  
garden pressure    hPa  | 720.8314 999.2943 999.302  999.3293 999.3805 278.5491 0.03496887
garden reducing    Ohms | 25031.8  25089.11 25132.14 25175.22 25261.52 229.7145 86.11233  
garden temperature C    | 17.81613 17.82122 17.8252  17.83554 22.56575 4.749617 0.01432103
rpi    cpu         pct  | 0        8.1      9.4      11.5     25.6     25.6     3.4       
rpi    cputemp     C    | 48.686   49.173   49.4165  50.147   50.634   1.948    0.974     
rpi    mem         pct  | 59.7     59.8     59.9     59.9     60.6     0.9      0.1
```

# kdb+tick
The kdb+tick deployment is a stock install, barring the addition of a UTC timezone change at the top of all scripts (`tick.q`, `r.q`, and `u.q`).

```
\o 0
```
None of the scripts are included in the repository, they're all symlinked ag. the standard install location in `~/q` and `~/q/tick`.

# Colour Spin on the MICS chip
Sometimes WiFi connectivity will drop, and it's tough to see if the weather station is truly dead or just having a bad time connecting. Every hour, the station signals if it's alive or not by flashing a rainbow on the MICS LED.

The cron job to do this is:

```
0 * * * * python3 /home/pi/observatory/colourspin.py
```
