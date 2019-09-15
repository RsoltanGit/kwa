## cleaning stuff & setting up the workspace
if(!is.null(dev.list())) dev.off()
cat("\014") 
rm(list=ls())
# setting the working directory
# setwd(Sys.getenv("R_USER"))

## Setting up the environment (installing packages and loading libraries) ##
## list of packages needed
# listOfPackages_needed <- c("tm", "tidyverse", "quanteda", "qdap", "superml", "RJSONIO", "plumber")
## checking whether or not the required packages have already been installed.
# newPackages_toBeInstalled <- listOfPackages_needed[!(listOfPackages_needed %in% installed.packages()[, "Package"])]
# install them if not installed yet.
# if(length(newPackages_toBeInstalled)) {
#   install.packages(newPackages_toBeInstalled)
# }

# install.packages("plumber")
# install.packages("tm") # for text mining
# install.packages("tidyverse")
# install.packages("quanteda")
# install.packages("qdap")
# install.packages("superml") # for BM25
# install.packages("RJSONIO")

#install.packages("text2vec")

## loading the needed libraries
#library(text2vec)
#library(data.table)
#library(magrittr)

# library(plumber)
library(tm)
#library(tidyverse)
library(quanteda)
# library(qdap)
#library(superml)
library(RJSONIO)

# the main function which gets the query from the API and generates the JSON list of matched topics.
keywordAssoc = function(query) {
  # create the toSpace content transformer to replace the passed "x" with a space
  toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})
  
  # tf.idf weight calculator
  w_tfidf = function(x) {
    weightTfIdf(x, normalize = T)
  }
  
  ## In Vector Space Model: Rank by the similarity of each document to the query and you have a search engine.
  # reading the tags from an external data-set.
  tags = read.csv("./datasets/tag_sets.csv", header = FALSE, stringsAsFactors = FALSE)
  names(tags) = "tags"
  tgs = tags$tags
  # the following code snippet samples 10k tags out of 90k (it works with 30k as well).
  # the reason is efficiency matters, I will find a way to address the whole dataset (it works with 30k as well, but for the sake of efficiency, I limited that to 10k).
  # sample 10,000 tags
  tgs_1 = tgs[1:10000]
  number_of_tags <- length(tgs_1)
  # just giving each tag a name (tag + an auto generated number)
  names(tgs_1) <- paste0("tag", c(1:number_of_tags))
  # the query read from the API
  if (query == "") {
    q <- ""
  } else {
    q <- query
  }
  # vector source creation (given the tags at hand and the query read from the API request)
  docs = VectorSource(c(tgs_1, q))
  # adding the query's name
  docs$Names = c(names(tgs_1), "query")
  # a corpus is a collection of texts, often with extensive manual annotation.
  crps = Corpus(docs)
  crps
  ## pre-processing & standardization
  # replacing commas with space
  crps = tm_map(crps, toSpace, ",")
  # remove punctuations, numbers and any extra white space & make the words lower-case
  crps = tm_map(crps, removePunctuation)
  crps = tm_map(crps, removeNumbers)
  crps = tm_map(crps, tolower)
  crps = tm_map(crps, stripWhitespace)
  # stemming
  crps = tm_map(crps, stemDocument)
  crps[[1]]$content
  ## building vector space model
  tdm = TermDocumentMatrix(crps)
  inspect(tdm)
  # creating the matrix out of the tdm. This process encounters efficiency issue when passing 90k tags!
  tdm_matrix = as.matrix(tdm)
  # tf.idf weight of \( (1 + \log_2(tf)) \times \log_2(N/df) \) will be calculated...
  # the term doc matrix with the tf.idf weights calculated for each cell
  tdm_w_tfidf = TermDocumentMatrix(crps, control = list(weighting = w_tfidf))
  # inspecting the content of the created term-doc-matrix
  inspect(tdm_w_tfidf)
  # converting it into a matrix
  tdm_w_tfidf_m = as.matrix(tdm_w_tfidf)
  # printing out a sample range of the matrix
  tdm_w_tfidf_m[0:3, 1:5]
  
  # Keeping the query alongside the other documents let us avoid repeating the same steps. But now it's time to pretend it was never there.
  # Separating the query vector from the actual tags data frame.
  q_vec = tdm_w_tfidf_m[, (number_of_tags + 1)]
  tdm_w_tfidf_m = tdm_w_tfidf_m[ , 1:number_of_tags]
  # calculating the cosine similarities between the query vector and each one of the tags.
  # This will return values of "cos(Theta)" for each document vector and the query vector.
  scores = t(q_vec) %*% tdm_w_tfidf_m
  # With scores in hand, we can rank the documents by their cosine similarities with the query vector.
  res = data.frame(score = t(scores), text = tgs_1)
  # just taking into consideration those whose scores are not ZERO (match to some extent)!
  res = res[res$score > 0, ]
  # sorting the results in descending order.
  res = res[order(res$score, decreasing = TRUE), ]
  # printing out the results.
  options(width = 2000)
  print(res, right = FALSE, digits = 2, row.names = FALSE)
  
  ## top score(s) (max) calculation
  top_scored_tags = res[res$score == max(res$score), ]
  # change the data type of the "text" col from factor to char (String)
  top_scored_tags$text = as.character(top_scored_tags$text)
  
  ## generating the JSON output
  ## TODO: check to merge (concatenate) all TEXT columns (not the 1st top one) satisfying the MAX condition above...
  t1 = top_scored_tags$text
  # splitting the output text based on commas they have to form the JSON list of values.
  t2 = c(unlist(strsplit(t1, split = ",")))
  # returning the result list (later will be illustrated as JSON list as the RESTful API's response).
  return(t2)
}
