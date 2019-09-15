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
# queries = read.table(file = '\\\\rmit.internal\\USRHome\\eh0\\e16380\\Configuration\\Desktop\\Jobs\\RB\\Homework\\user_search_keywords.tsv', sep = '\t', header = FALSE)
# srchQ = read.table(file = "C:/tmp/code/user_keywords.tsv", sep = "\t", header = TRUE, quote = "\"")
# srchQ1 = read.delim(file = "C:/tmp/code/user_keywords.tsv", sep = "\t", header = TRUE, quote = "")
srchQ1 = read.delim(file = "./datasets/user_keywords.tsv", sep = "\t", header = TRUE, quote = "")
# "read_tsv" is very fast!!
srchQ11 = read_tsv(file = "./datasets/user_keywords.tsv", col_names = TRUE, quote = "")
