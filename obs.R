# Example of pulling data from kdb via HTTP (instead of using Fusion)
library(ggplot2)

# RDB query
url <- 'http://localhost:5011/.csv?'
query <- 'select med data by 10 xbar time.minute,host,sym from obs'
uquery <- URLencode(query)
dfr <- read.csv(paste0(url,uquery),stringsAsFactors=FALSE)
dfr$time = as.POSIXct(dfr$minute,format='%H:%M',tz='UTC')

# HDB query
url <- 'http://localhost:5012/.csv?'
query <- 'select med data by date,10 xbar time.minute,host,sym from obs where date>.z.d-7'
uquery <- URLencode(query)
dfh <- read.csv(paste0(url,uquery),stringsAsFactors=FALSE)
dfh$time = as.POSIXct(paste0(dfh$date,"T",dfh$minute),format='%FT%H:%M',tz='UTC')

# Quick plot of the rdb time series
qplot(data=dfr[dfr$sym=='temperature',],x=time,y=data,color=sym,geom="line")

# Quick plot of the hdb time series
qplot(data=dfh[dfh$sym=='cputemp',],x=time,y=data,color=host,geom="line")

# Tol Vibrant colour map
tolvibrant <- c("#EE3377", "#0077BB", "#33BBEE", "#009988", "#EE7733", "#CC3311", "#BBBBBB")

# Number format function
numfmt <- function(x) format(x, big.mark=" ", decimal.mark=".", scientific=FALSE)

# Nicer plot of the rdb time series
ggplot(dfr[dfr$sym=='temperature',]) +
  # Data series
  geom_line(aes(x=time,y=data,color=host), size=1) + # color=host
  # Axis scales and colour scales
  scale_y_continuous(label=numfmt) +
  scale_color_discrete(type=tolvibrant) +
  # Plot labels
  labs(title="Garden Air Temperature",
       x=NULL, y="°C",
       subtitle = "In °C for today, 10 minute medians",
       caption="Source: observatory db",
       color=NULL) +
  # Themeing & fonts
  theme_light() +
  theme(legend.position="hidden",
        text=element_text(size=15, family="Fira Sans Extra Condensed"),
        plot.title=element_text(family="Fira Sans Extra Condensed Medium"),
        plot.caption=element_text(color="#666666"))

# Nicer plot of the hdb time series
ggplot(dfh[dfh$sym=='cputemp',]) +
    # Data series
    geom_line(aes(x=time,y=data,color=host), size=1) + # color=host
    # Axis scales and colour scales
    scale_y_continuous(label=numfmt) +
    scale_color_discrete(type=tolvibrant) +
    # Plot labels
    labs(title="CPU Temperature by host",
         x=NULL, y="°C",
         subtitle = "In °C for the last 7 days, 10 minute medians",
         caption="Source: observatory db",
         color=NULL) +
    # Themeing & fonts
    theme_light() +
    theme(legend.position="top",
          text=element_text(size=15, family="Fira Sans Extra Condensed"),
          plot.title=element_text(family="Fira Sans Extra Condensed Medium"),
          plot.caption=element_text(color="#666666"))