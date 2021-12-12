\o 0
pctile:{ y (100 xrank y:asc y) bin x}

/ From https://code.kx.com/q/wp/rt-tick/

/Sample usage:
/q hdb.q C:/OnDiskDB/sym -p 5002
if[1>count .z.x;show"Supply directory of historical database";exit 0];
hdb:.z.x 0
/Mount the Historical Date Partitioned Database
@[{system"l ",x};hdb;{show "Error message - ",x;exit 0}]
