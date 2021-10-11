# Crontab entry:
# 1/5 * * * * timeout 1m /home/nik/observatory/publish.sh > /home/nik/observatory/publish.out 2>&1
cd /home/nik/observatory/
Rscript -e "library(rmarkdown);rmarkdown::render('obs.Rmd')"
scp -P 42024 obs.html nik@nikhouri.com:/var/www/html/o.nikhouri.com/index.html