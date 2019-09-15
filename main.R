## cleaning stuff & setting up the workspace
if(!is.null(dev.list())) dev.off()
cat("\014") 
rm(list=ls())
# setting the working directory
setwd(Sys.getenv("R_USER"))


##### ====== Setting up the environment (installing packages and loading libraries) ====== #####
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

##### ====== user-defined functions ====== #####
keywordAssoc = function(query) {
  # create the toSpace content transformer to replace the passed "x" with a space
  toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})
  
  # tf.idf weight calculator
  w_tfidf = function(x) {
    weightTfIdf(x, normalize = T)
  }
  
  ##### ======  ====== #####
  ### In Vector Space Model: Rank by the similarity of each document to the query and you have a search engine.
  
  # reading the tags from an external data-set.
  tags = read.csv("./datasets/tag_sets.csv", header = FALSE, stringsAsFactors = FALSE)
  names(tags) = "tags"
  tgs = tags$tags
  # sample 30,000 tags
  tgs_1 = tgs[1:30000]
  number_of_tags <- length(tgs_1)
  names(tgs_1) <- paste0("tag", c(1:number_of_tags))
  # the query
  if (query == "") {
    q <- ""
  } else {
    q <- query
  }
  # q = query
  # q <- "game"
  # q <- "cute cat"
  # q = "baby"
  # vector source
  docs = VectorSource(c(tgs_1, q))
  docs$Names = c(names(tgs_1), "query")
  # a corpus is a collection of texts, often with extensive manual annotation.
  crps = Corpus(docs)
  crps
  # pre-processing & standardization
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
  # building vector space model
  tdm = TermDocumentMatrix(crps)
  inspect(tdm)
  tdm_matrix = as.matrix(tdm)
  # tf.idf weight of \( (1 + \log_2(tf)) \times \log_2(N/df) \) will be calculated...
  # Note that whenever a term does not occur in a specific document, or when it appears in every document, its weight is zero.
  # N.docs = the number of docs
  # tfidf_m <- t(apply(tdm_3_m, c(1), FUN = get.weights.per.term.vec))
  # colnames(tfidf_m) <- colnames(tdm_3_m)
  # tfidf_m[0:3, 1:5]
  # tdm_3.1 = TermDocumentMatrix(crps, control = list(weighting = weightTfIdf))
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
  # res = data.frame(tag = names(tgs_1), score = t(scores), text = tgs_1)
  res = data.frame(score = t(scores), text = tgs_1)
  # just taking into consideration those whose scores are not ZERO (match to some extent)!
  res = res[res$score > 0, ]
  # sorting the results in descending order.
  res = res[order(res$score, decreasing = TRUE), ]
  # printing out the results.
  options(width = 2000)
  print(res, right = FALSE, digits = 2, row.names = FALSE)
  
  
  ## furthermore normalize each column vector in our tfidf matrix so that its norm is one.
  # tfidf.matrix <- scale(tfidf.matrix, center = FALSE, scale = sqrt(colSums(tfidf.matrix^2)))
  # tfidf.matrix[0:3, ]
  
  
  ####### top score (max)
  top_scored_tags = res[res$score == max(res$score), ]
  # change the data type of the "text" col from factor to char (String)
  top_scored_tags$text = as.character(top_scored_tags$text)
  
  ###### generating the JSON output
  ## TODO: check to merge (concatenate) all TEXT columns (not the 1st top one) satisfying the MAX condition above...
  t1 = top_scored_tags$text
  # names(t1) = "related_topics"
  # t1_json = list(key = "related_topics", values = t1)
  # cat(toJSON(list(related_topics = t1)))
  # 
  t2 = c(unlist(strsplit(t1, split = ",")))
  #t3 = cat(toJSON(list(related_topics = t2)))  
  #list(related_topics = t2)
  return(t2)
}

#result = keywordAssoc("geek")
#result

