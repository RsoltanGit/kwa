#installing the text mining and snowball packages
install.packages("tm")
install.packages("Snowball")

install.packages("tidyverse")
library(tidyverse)

# loading the libraries
library(tm)
#library(snowball)

# setting the working directory
setwd("\\\\rmit.internal/USRHome/eh0/e16380/Configuration/Desktop/Jobs/RB/Homework/code")

# artists_tags = read.csv("\\\\rmit.internal\\USRHome\\eh0\\e16380\\Configuration\\Desktop\\Jobs\\RB\\Homework\\artist_tags.csv\\tag_sets.csv", header = FALSE)
# tags = read.csv("C:/tmp/code/tag_sets.csv", header = FALSE, stringsAsFactors = FALSE)
tags = read.csv("./datasets/tag_sets.csv", header = FALSE, stringsAsFactors = FALSE)



# create a simple corpus (only 100 tags for now)
crp = SimpleCorpus(VectorSource(tags$tags[1:100]))
cln_crp = crp
cln_crp[[1]]$content
# define a function "toSpace()"
#create the toSpace content transformer
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})
# now, apply that on the corpus
cln_crp = tm_map(cln_crp, toSpace, ",")
cln_crp = tm_map(cln_crp, content_transformer(tolower))
cln_crp = tm_map(cln_crp, removeNumbers)
cln_crp = tm_map(cln_crp, removePunctuation)
cln_crp = tm_map(cln_crp, removeWords, stopwords("english"))
cln_crp = tm_map(cln_crp, stripWhitespace)
cln_crp = tm_map(cln_crp, stemDocument)

dtm_2 = DocumentTermMatrix(cln_crp)
dtm_2
inspect(dtm_2[1:10, 1:10])
dtm_2_m = as.matrix(dtm_2)
# the frequency of occurrence of each word in the corpus
frq = colSums(dtm_2_m)
length(frq)
frq_ord = order(frq, decreasing = TRUE)
head(frq_ord)
