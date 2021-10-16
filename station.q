/ Nice 5NS & 7NS tables
pctile:{ y (100 xrank y:asc y) bin x}

fivens:{select lastv:last data, minv:min data, q1:pctile[25;data], medv:med data, q3:pctile[75;data], maxv:max data, rng:(max data - min data), iqr:(pctile[75;data]-pctile[25;data]) by host,sym,units from obs}

sevenns:{select lastv:last data, minv:min data, p10:pctile[10;data], p25:pctile[25;data], medv:med data, p75:pctile[75;data], p90:pctile[90;data], maxv:max data, rng:(max data - min data), iqr:(pctile[75;data]-pctile[25;data]), idr:(pctile[90;data]-pctile[10;data]) by host,sym,units from obs}

/ Latest samples
select last time, last data by host,sym,units from obs

/ Charts series
select low:pctile[5;data], median: med data, high:pctile[95;data] by 10 xbar time.minute,sym from obs where host=`garden
