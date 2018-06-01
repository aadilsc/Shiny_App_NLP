library("shiny")

shinyUI(
  
  fluidPage(
    
    titlePanel("NLP Processor"),
    
    sidebarLayout(
      
      sidebarPanel(
        
        fileInput("file1", "Upload data (.txt file)"),
        
        downloadButton("downloadData", "Download Data"),
        
        checkboxGroupInput("POS", 
                           h4("Parts Of Speech"), 
                           choices = list("ADJ" = "ADJ", 
                                          "NOUN" = "NOUN", 
                                          "PROPN" = "PROPN",
                                          "ADV" = "ADV",
                                          "VERB" = "VERB"),
                           selected = c("ADJ","NOUN","PROPN")),
        
        sliderInput("slider1", h4("COG Nodes"),min = 2, max = 10, value = 4),
        
        numericInput("num", h4("Data Rows"), value = 100,max = 1000,min = 1)
        ),  
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    tabPanel("Overview",
                             h4(p("Data input")),
                             p("This app supports only (.txt) data file. The dataset should only be in the form of text corpus",align="justify"),
                             p("Please refer to the link below for sample txt file."),
                             a(href="https://drive.google.com/file/d/19gOaeCud27CVa8bUjO4-caSfbz4XLdnN/view?usp=sharing"
                               ,"Sample data input file"),   
                             br(),
                             h4('How to use this App'),
                             p('To use this app, click on', 
                               span(strong("Upload data (txt file) and upload a file")),
                                br(),'1.Wordcloud will be created based on the POS selected',
                               br(),'2.Data tab consists of Parts Of Speech and their description',
                               br(),'3.The COG plot consist of Coourences of words',
                               br(),br(),'Options',
                               br(),'1.Slider will help u select the number of centre nodes in COG',
                               br(),'2.POS to select the POS for data and wordcloud',
                               br(),'3.Data rows to select the number of rows max 1000',
                               br(),'4.Download data to download the data as csv file'
                               )),
                    tabPanel("WordCloud", 
                             plotOutput('plot1')),
                    
                    tabPanel("Data",
                            dataTableOutput('clust_data')),
                    
                    tabPanel("COG Plot", 
                             plotOutput('plot2'))
                    
        ) 
      )
    ) 
  ) 
)



