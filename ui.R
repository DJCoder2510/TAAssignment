#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(textrank)
library(DT)


# Define UI for application that will manage the NLP operations
shinyUI(fluidPage(

    # Application title
    titlePanel("NLP workflow Shiny App"),

    # Sidebar with a slider input for number of bins
    sidebarPanel(
            
            fileInput("file", "Upload text file"),
            
            checkboxGroupInput("checkGroupUPOS", label = "Select UPOS Tags", 
                               choices = c("Adjective" = "ADJ", "Noun" = "NOUN", "proper noun" = "PROPN",
                               "adverb" = "ADV","verb" = "VERB"),
                               selected = c("ADJ","NOUN","PROPN"))
            
        ),
    
    mainPanel(
            
            tabsetPanel(type = "tabs",
                        
                    tabPanel("Overview",h4(p("NLP workflow app using udpipe")),
                       p("This application will help you to perform operations around Part-Of-Speech functionality of NLP. 
                          You need to upload your text file which you want to analyze. The first tab - Annotations will help you 
                         to analyze POS tags like , Noun, Adjective, Propoer Noun , Verb and Adverb. The next tabs will help you 
                         to see a wordcloud of Nouns or Verbs. Tab for cooccurence will help you to analyze the cooccurrences 
                         between the different words.", align = "justify")),
        
            
                    tabPanel("Annotations",
                             h4(p("Annotated Sentences")),
                             dataTableOutput ("annotated_sentences"),
                             hr(),
                             downloadButton('annotated_sentences_csv',"Export to CSV")),
                    
                    tabPanel("WordClouds", 
                             h4(p("Wordclouds for Nouns and Verbs")),
                             radioButtons("radioWordCloud", label = h3("Select Choice:"),
                                          choices = list("Noun" = 1, "Verb" = 2), 
                                          selected = 1),
                             hr(),
                             plotOutput("wordcloudsplot")),
            
                    tabPanel("Co-occurrences Plot",
                             h4(p("Co-occurrence plot at document level")),
                             plotOutput("cooccurplot"))
            
                    )  # tabSetPanel closes
        
        )  # mainPanel closes
    
)
)  # fluidPage() & ShinyUI() close