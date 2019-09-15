install.packages("qdap")
library(qdap)

#freq_terms()
glimpse(tags)

# Make a vector source
tgs = tags$tags

## sample 100 tags
tgs_1 = tgs[1:100]
src_1 = VectorSource(tgs_1)
vcorps_1 = VCorpus(src_1)
# sample DTM
dtm_1 = DocumentTermMatrix(vcorps_1)
dtm_1_m = as.matrix(dtm_1)
dim(dtm_1_m)
dtm_1_m[1:10, 1:10]
# sample TDM
tdm_1 = TermDocumentMatrix(vcorps_1)
tdm_1_m = as.matrix(tdm_1)
dim(tdm_1_m)
tdm_1_m[1:10, 1:10]
# word assoc network
word_associate(tgs_1, match.string = "cat", stopwords = tm::stopwords("en"), network.plot = T, cloud.colors = c("gray85", "darkred"))
# tf.idf tdm
tfidf_tdm_1 = TermDocumentMatrix(vcorps_1, control = list(weighting = weightTfIdf))
tfidf_tdm_1_m = as.matrix(tfidf_tdm_1)
dim(tfidf_tdm_1_m)
tfidf_tdm_1_m[1:10, 1:10]

head(tgs)
src = VectorSource(tgs)
# Make a volatile corpus
vcorps = VCorpus(src)
# Print out vcorps
vcorps
# Print data on the 10th tweet in vcorps
vcorps[[10]]
# Print the content of the 10th tag in vcorps
vcorps[[10]]$content # is equal to calling "vcorps[[10]][1]

## DTM & TDM creation
# (1) DTM
# creating the dtm from the corpus
dtm = DocumentTermMatrix(vcorps)
# Print out dtm
dtm
# Convert dtm to a matrix
dtm_matrix = as.matrix(dtm) ## ERROR! Error: cannot allocate vector of size 206.2 Gb
dim(dtm) # 99451 278234
# Review a portion of the dtm
dtm[10:15, 100:105]

# (2) TDM
# creating the tdm from the corpus
tdm = TermDocumentMatrix(vcorps)
# print out tdm
tdm
# convert the tdm to a matrix
tdm_matrix = as.matrix(tdm) ## ERROR! Error: cannot allocate vector of size 206.2 Gb
dim(tdm) # 278234  99451

# (2.1) TDM with the tf.idf (of BM25) weighting
tdm_tfIdf = TermDocumentMatrix(vcorps, control = list(weighting = weightTfIdf))

## Word clouds
# === not working because of the mem err! - START
# Frequent terms with tm
term_freq = rowSums(tdm_matrix)
# sort it in descending order
term_freq = sort(term_freq, decreasing = T)
# the top 10 most frequent terms
term_freq[1:10]
# === not working because of the mem err! - END
# the top 10 frequent terms in tags$tags
plot(freq_terms(tags$tags, top = 10, at.least = 3))
# the top 10 frequent terms in tags$tags, after removing the stopwords
plot(freq_terms(tags$tags, top = 10, at.least = 3, stopwords = c(tm::stopwords("en"))))
# visualize word network
word_associate(tags$tags, match.string = "cat", stopwords = tm::stopwords("en"), 
               network.plot = T, cloud.colors = c("gray85", "darkred"))
# add title
title(main = "cat tag associations")
