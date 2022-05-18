
library(shiny)
library(shinythemes)


path <- "https://raw.githubusercontent.com/GourabNath/Annual-Report-Analysis/main/bank_merge_imputed.csv"
banks <- read.csv(url(path))
View(banks)

path <- "https://raw.githubusercontent.com/GourabNath/Annual-Report-Analysis/main/banks_senti_imputed.csv"
banks_senti <- read.csv(url(path))
View(banks_senti)




ui <- fluidPage(title = "Annual Report Analysis", theme = shinytheme("cerulean"),
                
                titlePanel(title=h1("ANNUAL REPORT ANALYSIS", align="center", 
                                    style = "font-weight: 500; color: black; 
                                    background-color: #6BC1D1;padding: 20px")),
                
                sidebarLayout(
                  sidebarPanel(width = 3,
                               selectInput("bank", "BANK", choices = banks$Bank, selected="Dhanalakshmi Bank"),
                               br(),
                               radioButtons("report", "Choose Report", 
                                            choices = c("Director"="Director Report", "Auditor"="Auditor Report"), selected="Director Report"),
                               br(),
                               textOutput("text1"),
                               checkboxInput("r1", "Flesch-Kincaid Grade", TRUE),
                               checkboxInput("r2", "Gunning fog index", FALSE),
                               checkboxInput("r3", "SMOG", FALSE),
                               checkboxInput("r4", "Automated readability index", FALSE),
                               checkboxInput("r5", "Coleman-Liau Index", FALSE),
                               checkboxInput("r6", "Linsear Write", FALSE),
                               checkboxInput("r7", "Dale–Chall readability", FALSE),
                               br(),
                               textOutput("text2"),
                               radioButtons("senti", "Choose Dictionary", 
                                            choices = c("Harvard IV"="Harvard-IV", "LM"="Loughran & McDonald"), selected="Harvard-IV"),
                               br(),
                               textOutput("text3"),
                               checkboxInput("s1", "Proportion Positive", TRUE),
                               checkboxInput("s2", "Proportion Negative", FALSE),
                               checkboxInput("s3", "Subjectivity", FALSE),
                               br(),
                               downloadButton("downloadData", label="Download Readibility Data"),
                               br(),
                               downloadButton("downloadData2", label="Download Sentiment Data"),
                               
                  ),
                  
                  mainPanel(tabsetPanel(type="tab",
                                        tabPanel("Data-Readibility", tableOutput("data")),
                                        tabPanel("Readibility", plotOutput("plot1")),
                                        tabPanel("Data-Sentiment",  tableOutput("data2")),
                                        tabPanel("Sentiment", plotOutput("plot2"))
                                        
                                        
                  ))
                  
                )
)


server <- shinyServer(function(input,output)
{
  output$data <- renderTable({
    
    subset(banks, banks$Bank==input$bank & banks$Report==input$report)
    
  })
  
  output$data2 <- renderTable({
    
    subset(banks_senti, banks_senti$Bank==input$bank & banks_senti$Report==input$report & banks_senti$Dictionary==input$senti)
    
  })
  
  
  output$text1 <- renderText("READIBILITY SCORES")
  output$text2 <- renderText("SENTIMENT SCORES")
  output$text3 <- renderText("SENTI-WORDS DICTIONARIES")

  
  output$downloadData <- downloadHandler(
    filename = function() {
      "banks_readibility.csv"
    },
    content = function(file){
      write.csv(banks, file, row.names = FALSE)
    })
  
  output$downloadData2 <- downloadHandler(
    filename = function() {
      "banks_sentiment.csv"
    },
    content = function(file){
      write.csv(banks_senti, file, row.names = FALSE)
    })
  
  output$plot1 <- renderPlot(height = 600, {
    data = subset(banks, banks$Bank==input$bank & banks$Report==input$report)
    
    
    #print("Empty plot:")
    plot.new()
    #print("Empty plot specify the axes limits of the graphic:")
    plot(1, type="n", xlim=c(2010, 2021), ylim=c(0, 40),xlab="Year", ylab="Readibility Score")
    
    if(input$r1)
      lines(data$Year, data$Flesch.Kincaid, type="b", col=1, lty=1, lwd=3)
    
    if(input$r2)
      lines(data$Year, data$Gunning, type="b", col=3, lty=2, lwd=3)
    
    if(input$r3)
      lines(data$Year, data$SMOG, type="b", col=4, lty=2, lwd=3)
    
    if(input$r4)
      lines(data$Year, data$ARI, type="b", col=5, lty=2, lwd=3)
    
    if(input$r5)
      lines(data$Year, data$CLI, type="b", col=6, lty=2, lwd=3)
    
    if(input$r6)
      lines(data$Year, data$Linsear, type="b", col=7, lty=2, lwd=3)
    
    if(input$r7)
      lines(data$Year, data$DC, type="b", col=8, lty=2, lwd=3)
  })
  
  
  output$plot2 <- renderPlot(height = 600, {
    data = subset(banks_senti, banks_senti$Bank==input$bank & banks_senti$Report==input$report & banks_senti$Dictionary==input$senti)
    
    
    #print("Empty plot:")
    plot.new()
    #print("Empty plot specify the axes limits of the graphic:")
    plot(1, type="n", xlim=c(2010, 2021), ylim=c(0, 0.5),xlab="Year", ylab="Opinion Score")
    
    if(input$s1)
      lines(data$Year, data$PPositive, type="b", col="green", lty=1, lwd=3)
    
    if(input$s2)
      lines(data$Year, data$PNegative, type="b", col="red", lty=2, lwd=3)
    
    if(input$s3)
      lines(data$Year, data$Subjectivity, type="b", col="blue", lty=2, lwd=3)
    
  })
  
  
  
})



shinyApp(ui, server)


