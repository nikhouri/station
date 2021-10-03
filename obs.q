pctile:{ y (100 xrank y:asc y) bin x}

select minv:min data, q1:pctile[25;data], medv:med data, q3:pctile[75;data], maxv:max data, rng:(max data - min data), iqr:(pctile[75;data]-pctile[25;data]) by sym,units from obs

-15#obs

select last time, last data by sym,units from obs

shownow:{select last time, last data by sym,units from obs}

//

select mind:min data, medd:med data,maxd:max data by 60 xbar time.minute from obs where sym=`temperature

select minTemp:min data, q1:pctile[25;data], medTemp:med data, q3:pctile[75;data], maxTemp:max data, rng:(max data - min data), iqr:(pctile[75;data]-pctile[25;data]) by 30 xbar time.minute from obs where sym=`temperature
