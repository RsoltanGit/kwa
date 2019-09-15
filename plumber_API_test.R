#install.packages("plumber")
library(plumber)

#* @apiTitle Simple API

#* Echo provided text
#* @param text The text to be echoed in the response
#* @get /echo1
function(text = "") {
  list(
    message_echo = paste("The text is:", text)
  )
}

## setwd(Sys.getenv("R_USER"))
## Assuming the file is saved as "plumber_API_test.R", the following code would start a local web server hosting the API. You can run it using the R command prompt as well (after installing and loading the "plumber" package/library of course!)
## plumber::plumb("plumber_API_test.R")$run(port = 5762)


################# 
# 2nd example

library(plumber)

#* @apiTitle Simple API

#* Echo provided text
#* @param text The text to be echoed in the response
#* @param number A number to be echoed in the response
#* @get /echo2
#* @post /echo2
function(req, text = "", number = 0) {
  list(
    message_echo = paste("The text is:", text),
    number_echo = paste("The number is:", number),
    raw_body = req$postBody
  )
}

