Rscript -e "library(rmarkdown);rmarkdown::render('obs.Rmd')"
scp -P 42024 obs.html nik@nikhouri.com:/var/www/html/o.nikhouri.com/index.html