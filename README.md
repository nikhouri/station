# Observatory 
Python & kdb+tick environment logging

# kdb+tick
The kdb+tick deployment is a stock install, barring the addition of a UTC timezone change at the top of all scripts (`tick.q`, `r.q`, and `u.q`). None of the scripts are included in the repository, they're all symlinked ag. the standard install location in `~/q` and `~/q/tick`.

```
\o 0
```


# Colour Spin on the MICS chip
Sometimes WiFi connectivity will drop, and it's tough to see if the weather station is truly dead or just having a bad time connecting. Every hour, the station signals if it's alive or not by flashing a rainbow on the MICS LED.

The cron job to do this is:

```
0 * * * * python3 /home/pi/observatory/colourspin.py
```
