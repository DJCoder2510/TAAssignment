# TA Group Assignment - Question 3
# Team: 1. Dhananjay Rane (11915051) 2. Ravi Sastry (11915069) 3. Veeresh Kumar (11915087)
# Server Side code


library(shiny)

# Defining a server
shinyServer(function(input, output) {
    
    ## Readinf the file
    dataset <- reactive({
        if (is.null(input$file)) {return(NULL)}
        else {
            
            dataset = readLines(input$file$datapath)
            return(dataset)}
        
    })
    
    ## Annotation of sentences
    annotated_sentences <- reactive({
     
      # Load english model for annotation from working dir
      english_model = udpipe_load_model("./udmodel/english-ewt-ud-2.4-190531.udpipe")  # file_model only needed
      
      # Annotate text dataset using ud_model above
      corpus <- udpipe_annotate(english_model, x = dataset()) #%>% as.data.frame() %>% head()
      
      annotated_sentences <- as.data.frame(corpus)
      
      if (!("NOUN" %in% input$checkGroupUPOS))  annotated_sentences <- annotated_sentences %>% filter(upos != "NOUN")
      if (!("ADJ" %in% input$checkGroupUPOS))  annotated_sentences <- annotated_sentences %>% filter(upos != "ADJ")
      if (!("PROPN" %in% input$checkGroupUPOS))  annotated_sentences <- annotated_sentences %>% filter(upos != "PROPN")
      if (!("ADV" %in% input$checkGroupUPOS))  annotated_sentences <- annotated_sentences %>% filter(upos != "ADV")
      if (!("VERB" %in% input$checkGroupUPOS))  annotated_sentences <- annotated_sentences %>% filter(upos != "VERB")
      
      # Removing the unwnted upos
      annotated_sentences <- annotated_sentences %>% filter(upos != "PRON")
      annotated_sentences <- annotated_sentences %>% filter(upos != "AUX")
      annotated_sentences <- annotated_sentences %>% filter(upos != "ADP")
      annotated_sentences <- annotated_sentences %>% filter(upos != "DET")
      annotated_sentences <- annotated_sentences %>% filter(upos != "PUNCT")
      annotated_sentences <- annotated_sentences %>% filter(upos != "CCONJ")
      annotated_sentences <- annotated_sentences %>% filter(upos != "PART")
      annotated_sentences <- annotated_sentences %>% filter(upos != "NUM")
      annotated_sentences <- annotated_sentences %>% filter(upos != "SYM")
      annotated_sentences <- annotated_sentences %>% filter(upos != "SCONJ")
      
      return(annotated_sentences)
       
    })
    
    output$annotated_sentences <- renderDataTable({ 
        annotated_sentences() %>%
        select(doc_id,paragraph_id,sentence_id,token_id,token,lemma,upos,xpos,feats) %>% 
        head(100) 
      })
    
    output$annotated_sentences_csv <- downloadHandler(
      filename = function(){paste('data', '.csv', sep='')}, 
      content = function(file){
        write.csv(annotated_sentences(), file)
      }
     )
    
    output$cooccurplot <- renderPlot({
      
      # Sentence Co-occurrences for nouns or adj only
      text_cooc <- cooccurrence(   	# try `?cooccurrence` for parm options
        x = subset(annotated_sentences(), upos %in% c("NOUN", "ADJ")), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
      
      
      # Visualising top-30 co-occurrences using a network plot
      library(igraph)
      library(ggraph)
      library(ggplot2)
      
      wordnetwork <- head(text_cooc, 50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")
      
      
    })
    
    output$wordcloudsplot <- renderPlot({
      
      library(wordcloud)
      
      if(input$radioWordCloud == 1){
        all_nouns = annotated_sentences() %>% subset(., upos %in% "NOUN"); all_nouns$token[1:20]
        top_nouns = txt_freq(all_nouns$lemma)
        
        wordcloud(words = top_nouns$key, 
        freq = top_nouns$freq, 
        min.freq = 2, 
        max.words = 100,
        random.order = FALSE, 
        colors = brewer.pal(6, "Dark2"))
      }else if(input$radioWordCloud == 2){
        all_verbs = annotated_sentences() %>% subset(., upos %in% "VERB") 
        top_verbs = txt_freq(all_verbs$lemma)
        
        wordcloud(words = top_verbs$key, 
                  freq = top_verbs$freq, 
                  min.freq = 2, 
                  max.words = 100,
                  random.order = FALSE, 
                  colors = brewer.pal(6, "Dark2"))
        
      }
    })
    
}) # shinyServer func ends
