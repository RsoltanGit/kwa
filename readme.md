# Keyword Association Application
This is a sample app created for the keyword association task given by Redbubble.
The package will contain the following.

## R codes
The following R codes are defined in this project:

### main.R
This is the main file responsible for getting the dataset and performing text analysis and extracting the association between the submitted query and the documents (tags) within the dataset. 
Please note: if running the application locally (not using the docker), then the following packages should be installed:
```
install.packages("tm", repos = "http://cran.us.r-project.org") # for text mining
install.packages("tidyverse")
install.packages("quanteda")
install.packages("RJSONIO")
install.packages("plumber")
```

### keywordAssoc_API.R
This is the API written to send requests and receive responses to and from the `main.R` file. The content of the API file is as follows:
```
# get connected to the main.R file
source("main.R")

#* @apiTitle Keyword Association API - Version 01

#* Gets the provided query as input and produces a list of related topics as output
#* @param query The query to be processed to generate the list of related topics in the response
#* @get /kwa
function(query) {
  list(related_topics = keywordAssoc(query))
}
```

### caller.R
This is the Plumber file which will run the plumber library in getting access to the API defined in the `keywordAssoc_API.R` file. The caller.R code is listed below:
```
# loading the R Plumber library
library(plumber)

# creating a plumber instance by getting connected to the API defined in the "keywordAssoc_API.R" file.
plumber_instance = plumb("keywordAssoc_API.R")
# starting the plumber on certain port and host
plumber_instance$run(port = 5762, host = "0.0.0.0")
```

## R tests
These are files defined under the `tests` folder to perform the Unit Testing over the implemented functions. They will use the `testthat` R Package for this purpose. Sample Unit Testing over the `main.R` file can be found in the `test_main.R` file:
```
# including the main.R file to be tested
source("../main.R", chdir = TRUE)

# loading the "testthat" library for Unit Testing
library(testthat)

# testing the proper query
test_that("correct query", {
  expect_equal(keywordAssoc("game"), 
               list("league", "league of legends", "lol", "logo", "game", "video game", "computer game"))
})

# testing a query with no results
test_that("query with no result", {
  expect_equal(keywordAssoc("blahbluebleh!"),
               NULL)
})

# testing an empty query.
test_that("empty query", {
  expect_equal(keywordAssoc(""), 
               NULL)
})

# please note with running the following script in the command line, we can see a report on tests pass/failure
# testthat::test_dir("tests")
```

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

