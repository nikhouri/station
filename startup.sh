#!/bin/sh

# Start tickerplant, RDB, HDB
q ~/q/tick.q sym ~/observatory/tick -p 5010
q tick/hdb.q ~/observatory/tick/sym -p 5012
q ~/q/tick/r.q localhost:5000 localhost:5002 -p 5011