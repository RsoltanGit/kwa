# start from the rocker/r-ver image
FROM rocker/r-ver:3.5.0

# install packages
RUN R -e "install.packages('tm', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('quanteda', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('RJSONIO', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('plumber', repos = 'http://cran.us.r-project.org')"

# copy everything from the current directory into the container
COPY / /

# open port 5762 to the web traffic
EXPOSE 5762

# when the container starts, start the "main.R" script
ENTRYPOINT ["Rscript", "caller.R"]
