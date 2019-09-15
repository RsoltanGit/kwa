[200~#installing the text mining and snowball packages
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


  #freq_terms()
glimpse(tags)

# Make a vector source
tgs = tags$tags

## sample 100 tags
tgs_1 = tgs[1:100]


  # BM25 from https://www.rdocumentation.org/packages/superml/versions/0.4.0/topics/bm25
get_bm = bm25$new(tgs_1, use_parallel = FALSE)
qry = c("game of thrones")
res = get_bm$most_similar(document = qry, topn = 5)
