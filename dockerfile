# start from the rocker/r-ver image
FROM rocker/r-ver:3.5.0

# install the Linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y \
	libssl-dev
#	libcurl14-gnutls-dev

# install packages
RUN R -e "install.packages('xml2', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('tm', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('quanteda', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('RJSONIO', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('plumber', repos = 'http://cran.us.r-project.org')"

# setup working directory
RUN mkdir -p /home/R
WORKDIR /home/R

# copy everything from the current directory into the container's working directory
COPY / /home/R

# open port 5762 to the web traffic
EXPOSE 5762

# when the container starts, start the "main.R" script
ENTRYPOINT ["Rscript", "caller.R"]
# CMD ["R", "-e source('caller.R')"]
