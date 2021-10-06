# Example of pulling data from kdb via HTTP (instead of using Fusion)
library(ggplot2)

# RDB query
url <- 'http://localhost:5011/.csv?'
query <- 'select med data by 10 xbar time.minute,host,sym from obs'
uquery <- URLencode(query)
df <- read.csv(paste0(url,uquery),stringsAsFactors=FALSE)
df$time = as.POSIXct(df$minute,format='%H:%M',tz='UTC')

# HDB query
url <- 'http://localhost:5012/.csv?'
query <- 'select med data by date,10 xbar time.minute,host,sym from obs where date>.z.d-7,sym=`cputemp'
uquery <- URLencode(query)
df <- read.csv(paste0(url,uquery),stringsAsFactors=FALSE)
df$time = as.POSIXct(paste0(df$date,"T",df$minute),format='%FT%H:%M',tz='UTC')

# Quick plot of the time series
qplot(data=df[df$sym=='temperature'],x=time,y=data,color=sym,geom="line")

# Tol Vibrant colour map
tolvibrant <- c("#0077BB", "#33BBEE", "#009988", "#EE7733", "#CC3311", "#EE3377", "#BBBBBB")

# Number format function
numfmt <- function(x) format(x, big.mark=" ", decimal.mark=".", scientific=FALSE)

# Nicer plot of the time series
ggplot(df) +
    # Data series
    geom_line(aes(x=time,y=data,color=host), size=1) + # color=host
    # Axis scales and colour scales
    scale_y_continuous(label=numfmt) +
    scale_color_discrete(type=tolvibrant) +
    # Plot labels
    labs(title="CPU Temperature by host",
         x=NULL, y="°C",
         subtitle = "Last 7 days, 10 minute medians",
         caption="Source: observatory db",
         color=NULL) +
    # Themeing & fonts
    theme_light() +
    theme(legend.position="top",
          text=element_text(size=15, family="Fira Sans Extra Condensed"),
          plot.title=element_text(family="Fira Sans Extra Condensed Medium"),
          plot.caption=element_text(color="#666666"))