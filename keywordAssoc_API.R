# get connected to the main.R file
source("main.R")

#* @apiTitle Keyword Association API - Version 01

#* Gets the provided query as input and produces a list of related topics as output
#* @param query The query to be processed to generate the list of related topics in the response
#* @get /kwa
function(query) {
  list(related_topics = keywordAssoc(query))
}

