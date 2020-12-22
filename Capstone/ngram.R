# Load packages

library(tm)
library(dplyr)
library(stringi)
library(stringr)
library(quanteda)
library(data.table)
library(RWeka)

# Get data
enBlogs <- readLines("en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE, warn = TRUE)
enTweet <- readLines("en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE, warn = TRUE)
enNews <- readLines("en_US.news.txt", encoding = "UTF-8", skipNul = TRUE, warn = TRUE)

# Take sample data

set.seed(12345)
samp_size = 10000

newsSample <- sample(enNews, samp_size, replace = FALSE)
tweetSample <- sample(enTweet, samp_size, replace = FALSE)
blogSample <- sample(enBlogs, samp_size, replace = FALSE)

# Merge data into one dataset

df <- c(newsSample, tweetSample, blogSample)
writeLines(df, "./Word_Prediction/sample_df.txt")

# Remove punctuation, special characters, usernames, and email addresses
corpus <- Corpus(VectorSource(df))

corpus <- tm_map(corpus, content_transformer(function(x) iconv(x, to="UTF-8", sub="byte")))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english")) 
corpus <- tm_map(corpus, stripWhitespace)

urlDel <- function(x) gsub("http[[:alnum:]]*", "", x)
corpus <- tm_map(corpus, urlDel)

# Save resulting df into a text file (for future reference)

saveRDS(corpus, file = "./Word_Prediction/corpus.RData")
rm(list = ls())

# Read corpus data and convert it to data.frame

corpus <- readRDS("./Word_Prediction/corpus.RData")
head(corpus, 10)

# Create function using NGramTokenizer to split strings into n-grams given bounds

unigram <- NGramTokenizer(corpus, Weka_control(min = 1, max = 1,delimiters = " \\r\\n\\t.,;:\"()?!"))
unigram <- data.frame(table(unigram))
unigram <- unigram[order(unigram$Freq,decreasing = TRUE),]
names(unigram) <- c("word", "freq")
unigram$word <- as.character(unigram$word)
write.csv(unigram[unigram$freq > 1,],"unigram.csv",row.names=F)
unigram <- read.csv("unigram.csv",stringsAsFactors = F)
saveRDS(unigram, file = "./Word_Prediction/unigram.rdata")


bigram <- NGramTokenizer(corpus, Weka_control(min = 2, max = 2,delimiters = " \\r\\n\\t.,;:\"()?!"))
bigram <- data.frame(table(bigram))
bigram <- bigram[order(bigram$Freq,decreasing = TRUE),]
names(bigram) <- c("words","freq")
bigram$words <- as.character(bigram$words)
str2 <- strsplit(bigram$words,split=" ")
bigram <- transform(bigram, 
                    one = sapply(str2,"[[",1),   
                    two = sapply(str2,"[[",2))
bigram <- data.frame(word1 = bigram$one,word2 = bigram$two,freq = bigram$freq,stringsAsFactors=FALSE)

names(bigram)[names(bigram) == 'word1'] <- 'w1'
names(bigram)[names(bigram) == 'word2'] <- 'w2'

write.csv(bigram[bigram$freq > 1,],"bigram.csv",row.names=F)
bigram <- read.csv("bigram.csv",stringsAsFactors = F)
saveRDS(bigram,"./Word_Prediction/bigram.rdata")

trigram <- NGramTokenizer(corpus, Weka_control(min = 3, max = 3,delimiters = " \\r\\n\\t.,;:\"()?!"))
trigram <- data.frame(table(trigram))
trigram <- trigram[order(trigram$Freq,decreasing = TRUE),]
names(trigram) <- c("words","freq")
trigram$words <- as.character(trigram$words)
str3 <- strsplit(trigram$words,split=" ")
trigram <- transform(trigram,
                     one = sapply(str3,"[[",1),
                     two = sapply(str3,"[[",2),
                     three = sapply(str3,"[[",3))

trigram <- data.frame(word1 = trigram$one,word2 = trigram$two, 
                      word3 = trigram$three, freq = trigram$freq,stringsAsFactors=FALSE)

names(trigram)[names(trigram) == 'word1'] <- 'w1'
names(trigram)[names(trigram) == 'word2'] <- 'w2'
names(trigram)[names(trigram) == 'word3'] <- 'w3'

write.csv(trigram[trigram$freq > 1,],"trigram.csv",row.names=F)
trigram <- read.csv("trigram.csv",stringsAsFactors = F)
saveRDS(trigram,"./Word_Prediction/trigram.rdata")


quadgram <- NGramTokenizer(corpus, Weka_control(min = 4, max = 4,delimiters = " \\r\\n\\t.,;:\"()?!"))
quadgram <- data.frame(table(quadgram))
quadgram <- quadgram[order(quadgram$Freq,decreasing = TRUE),]

names(quadgram) <- c("words","freq")
quadgram$words <- as.character(quadgram$words)

str4 <- strsplit(quadgram$words,split=" ")
quadgram <- transform(quadgram,
                      one = sapply(str4,"[[",1),
                      two = sapply(str4,"[[",2),
                      three = sapply(str4,"[[",3), 
                      four = sapply(str4,"[[",4))

quadgram <- data.frame(word1 = quadgram$one,
                       word2 = quadgram$two, 
                       word3 = quadgram$three, 
                       word4 = quadgram$four, 
                       freq = quadgram$freq, stringsAsFactors=FALSE)

names(quadgram)[names(quadgram) == 'word1'] <- 'w1'
names(quadgram)[names(quadgram) == 'word2'] <- 'w2'
names(quadgram)[names(quadgram) == 'word3'] <- 'w3'
names(quadgram)[names(quadgram) == 'word4'] <- 'w4'

write.csv(quadgram[quadgram$freq > 1,],"quadgram.csv",row.names=F)
quadgram <- read.csv("quadgram.csv",stringsAsFactors = F)
saveRDS(quadgram,"./Word_Prediction/quadgram.rdata")

rm(list = ls())