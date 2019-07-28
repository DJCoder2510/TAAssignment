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
                        
                    tabPanel("Overview",h4(p("How to use this App")),
                             
                       p("To use this app you need a document (e.g., newspaper article etc.) in txt file format.\n\n 
                       To upload the article text, click on Browse in left-sidebar panel and upload the txt file from your local machine. \n\n
                       Once the file is uploaded, the shinyapp will compute a text summary in the back-end with default inputs and accordingly results will be displayed in various tabs.", align = "justify")),
        
            
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