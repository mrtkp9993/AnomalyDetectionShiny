library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Anomaly Detection"),
  hr(),
  tags$a(href = "https://github.com/mrtkp9993/AnomalyDetectionShiny", 
         "For usage info, please click here."),
  sidebarLayout(
    sidebarPanel(
      fileInput(
        "inputFile",
        "Choose CSV file",
        multiple = FALSE,
        accept = c("text/csv",
                   "text/comma-separated-values,text/plain",
                   ".csv"),
        width = NULL
      ),
      checkboxInput("headers", "Headers?"),
      dateInput("startDate", "Start Date"),
      selectInput("freq", "Frequency", as.list(c(1, 4, 12, 52))),
      selectInput("dateCol", "Date Column", ""),
      selectInput("dataCol", "Data Column", "")
      
    ),
    mainPanel(
      h3("Data"),
      tableOutput("table"),
      h3("STL Decomposition"),
      plotOutput("decomp"),
      h3("Anomalies"),
      plotOutput("anomalies")
    )
  )
))
