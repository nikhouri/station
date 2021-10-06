# Example of pulling data from kdb via HTTP (instead of using Fusion)
library(ggplot2)

# Construct query
url <- 'http://localhost:5011/.csv?'
query <- 'select med data by 10 xbar time.minute,host,sym from obs'
uquery <- URLencode(query)

# Read data, convert time to POSIXct
df <- read.csv(paste0(url,uquery),stringsAsFactors=FALSE)
df$time = as.POSIXct(df$minute,format='%H:%M',tz='UTC')

# Plot the time series
qplot(data=df[df$sym=='temperature' & df$host=='garden',],x=time,y=data,color=sym,geom="line")