
library(tm)
library(dplyr)
library(stringi)
library(stringr)
library(quanteda)
library(data.table)
library(RWeka)
library(rsconnect)

# Load data files created from ngram.R

unigramlist <- readRDS("./unigram.rdata")
bigramlist <- readRDS("./bigram.rdata")
trigramlist <- readRDS("./trigram.rdata")
quadgramlist <- readRDS("./quadgram.rdata")

# Use the unigramlist to create the default values shoud there be no input

default <- unigramlist[1:3,]$word

# Function that will clean the input the same way we cleaned the training set

cleanInput <- function(userText){
  userText <- tolower(userText)
  userText <- removePunctuation(userText)
  userText <- removeNumbers(userText)
  userText <- removePunctuation(userText)
  sen <- unlist(strsplit(userText,' '))
  if(length(sen) >= 3){
    sen <- sen[(length(sen) - 2):length(sen)]
  }
  else if(length(sen)==2){
    sen <- sen[length(sen)-1:length(sen)]
  } 
  else if(length(sen)==1){ 
    sen <-sen[length(sen)]
      }
  return(sen)
}

# Function that will check the lists for matches


predictProc <- function(sentence){
  x <- cleanInput(sentence)
  prediction <- c()
  if(length(x) == 3){
    prediction4 <- quadgramlist[quadgramlist$w1 == x[1]&
                                  quadgramlist$w2 == x[2]&
                                  quadgramlist$w3 == x[3],]$w4
    if(length(prediction4)>=3){
      prediction <-prediction4[1:3]
      return(prediction)
    }
    else {
      x <- x[2:3]
    }
  }
  
  if (length(x)==2){
    prediction3 <- trigramlist[trigramlist$w1 == x[1]&
                                 trigramlist$w2 == x[2],]$w3
    
    if(length(prediction3)>=(3-length(prediction))){
      prediction <-c(prediction, prediction3)
      prediction <- prediction[1:3]
      return(prediction)
    }
    else {
      x <- x[2]
    }
  }
  
  if (length(x)==1){                              
    prediction2 <- bigramlist[bigramlist$w1 == x[1],]$w2
    
    if(length(prediction2)>=(3-length(prediction))){
      prediction <-c(prediction, prediction2)
      prediction <- prediction[1:3]
      return(prediction)
    }
    else {
      x <- x[0]
    }
  }
  
  if(length(x)==0){
  prediction <- c(prediction,unigramlist[1:3,]$word)
  prediction <- prediction[1:3]
  return(prediction)
    }
    
}  
