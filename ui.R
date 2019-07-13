library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet",
              href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css")
  ),
  titlePanel("Anomaly Detection"),
  hr(),
  tags$a(
    href = "https://github.com/mrtkp9993",
    target = "_blank",
    class = "fa fa-2x fa-github"
  ),
  HTML("&nbsp;"),
  tags$a(
    href = "https://www.linkedin.com/in/muratkoptur/",
    target = "_blank",
    class = "fa fa-2x fa-linkedin"
  ),
  hr(),
  sidebarLayout(sidebarPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel(
        "Upload File",
        br(),
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
        selectInput("freq", "Frequency", as.list(c(1, 4, 12, 52, 365))),
        selectInput("dateCol", "Date Column", ""),
        selectInput("dataCol", "Data Column", "")
      ),
      tabPanel(
        "Usage",
        br(),
        a(href = "https://github.com/mrtkp9993/AnomalyDetectionShiny",
          "For usage info, please click here.")
      )
    )
  ),
  mainPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel("Data",
               br(),
               tableOutput("dataTable")),
      tabPanel(
        "STL Decomposition",
        br(),
        plotOutput("decomp", height = "500px")
      ),
      tabPanel(
        "Anomalies",
        br(),
        plotOutput("anomalies", height = "500px"),
        br(),
        tableOutput("anomalyTable")
      )
    )
  ))
))
