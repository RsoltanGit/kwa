# Keyword Association Application
This is a sample app created for the keyword association task given by Redbubble.
The package will contain the following.

## R codes
The following R codes are defined in this project:

### main.R
This is the main file responsible for getting the dataset and performing text analysis and extracting the association between the submitted query and the documents (tags) within the dataset.

### keywordAssoc\_API.R
This is the API written to send requests and receive responses to and from the `main.R` file. 

### caller.R
This is the Plumber file which will run the plumber library in getting access to the API defined in the `keywordAssoc_API.R` file.

## R tests
These are files defined under the `tests` folder to perform the Unit Testing over the implemented functions. They will use the `testthat` R Package for this purpose.

## Docker File
The `dockerfile` in the root directory accounts for the link to Docker (for building and running the application). After creating the docker image, its container will be run and listen to port `5762`. The content of the docker file can be listed as follows:
```
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
```

## Datasets
The datasets are not uploaded as they exceed the file size limit of GitHub. They will be accessible through RB's website.

