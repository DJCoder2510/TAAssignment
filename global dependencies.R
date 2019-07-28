# TA Group Assignment - Question 3
# Team: 1. Dhananjay Rane (11915051) 2. Ravi Sastry (11915069) 3. Veeresh Kumar (11915087)
# Dependencies

if (!require(shiny)) {install.packages("shiny")}
if (!require(dplyr)) {install.packages("dplyr")}
if (!require(textrank)) {install.packages("textrank")}
if (!require(ggplot2)) {install.packages("ggplot2")}
if (!require(udpipe)){install.packages("udpipe")}
if (!require(DT)){install.packages("DT")}
if (!require(wordcloud)){install.packages("wordcloud")}


library(shiny)
library(dplyr)
library(textrank)
library(ggplot2)
library(udpipe)
library(DT)
library(wordcloud)

