#Prerequisite file
rm(list=ls())

library(reticulate)
library(dplyr)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)
library(magrittr)

nltk <- import("nltk")

source("https://raw.githubusercontent.com/aadilsc/Text-Analytics/master/DTM_Builder.R")