# loading the R Plumber library
library(plumber)

# creating a plumber instance by getting connected to the API defined in the "keywordAssoc_API.R" file.
plumber_instance = plumb("keywordAssoc_API.R")
# starting the plumber on certain port and host
plumber_instance$run(port = 5762, host = "0.0.0.0")
