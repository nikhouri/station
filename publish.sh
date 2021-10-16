# Crontab entry:
# 1-59/5 * * * * timeout 1m /home/nik/station/publish.sh > /home/nik/station/publish.out 2>&1
cd ~/station/
Rscript -e "library(rmarkdown);rmarkdown::render('station.Rmd')"
scp -P 42024 station.html nik@nikhouri.com:/var/www/html/o.nikhouri.com/index.html