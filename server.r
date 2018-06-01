shinyServer(function(input, output) {
  Dataset <- reactive({
    if (is.null(input$file1)) { 
      return(NULL) } else{
        fileName <- input$file1$datapath
        FD <- readChar(fileName, file.info(fileName)$size)
        return(FD)
      }
  })

  calc_DTM <-function(file_Data,type=1){
    src <- DataframeSource(data.frame(doc_id =row_number(file_Data),text=file_Data))
    clean_corpus<-text_Cleaner(VCorpus(src))
    dtm_ngram_1<-dtm_Builer(clean_corpus,min_tok = 1,max_tok = 2,min_bound=3,TFIDF = F)
    
    dtm.matrix_1 <- as.matrix(dtm_ngram_1)
    wordcount_1 <- colSums(dtm.matrix_1)
    wc_df<-data.frame(wordcount_1)
    bd_firms <-nltk$pos_tag(names(wordcount_1)) 
    bd_firms_df <- data.frame(slnum = 1:length(bd_firms),
                              token = sapply(bd_firms, `[[`, 1),
                              pos_tag = sapply(bd_firms, `[[`, 2),
                              score = wc_df$wordcount_1)
    if(type == 2){
      return(names(sort(wordcount_1,decreasing = T))) }
    else{
      return(bd_firms_df)
    }
  }
  
  output$plot1 = renderPlot({
    bd_firms_df<-calc_DTM(Dataset())
    bd_firms_pos_tag<-calc_DataTable()
    final_df<- merge(bd_firms_df, bd_firms_pos_tag, by="token")
    bd_firms_df_subset<-subset(final_df, final_df$upos %in% input$POS)
    bd_firms_df_subset<- bd_firms_df_subset[,c('token','score')]
    bd_firms_df_grouped<- group_by(bd_firms_df_subset,token)
    bf_summary<- summarise(bd_firms_df_grouped, score = sum(score))
    wordcloud(words = bf_summary$token,bf_summary$score, random.order=F, 
              colors=brewer.pal(8, "Dark2"),scale = c(15,.6))
  
  },height = 500)
  
  output$plot2 = renderPlot({
    src <- DataframeSource(data.frame(doc_id =row_number(Dataset()),text=Dataset()))
    clean_corpus<-text_Cleaner(VCorpus(src))
    dtm_ngram_1<-dtm_Builer(clean_corpus,min_tok = 1,max_tok = 2,min_bound=3,TFIDF = F)
    COG(dtm_ngram_1,central.nodes = input$slider1)
  },height= 500)
  
  calc_DataTable<-function(){
    english_model = udpipe_load_model("./english-ud-2.0-170801.udpipe")
    x <- udpipe_annotate(english_model, x = calc_DTM(file_Data = Dataset(),type=2)) #%>% as.data.frame() %>% head()
    x <- as.data.frame(x)
    x <- x %>% subset(., upos %in% input$POS) 
    return(head(x[,c(1:3,5:14)],input$num))
  }
  
  output$clust_data = renderDataTable({
    calc_DataTable()
  })
 
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(calc_DataTable(), row.names = TRUE,file)
    }
  )
})