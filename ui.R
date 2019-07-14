library(DT)
library(shiny)
library(shinycssloaders)
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
        "Anomaly Detection Settings",
        br(),
        sliderInput(
          "max_anoms",
          "Maximum number of anomalies as a percentage of the data",
          0,
          0.49,
          0.02
        ),
        selectInput(
          "direction",
          "Directionality of the anomalies to be detected",
          as.list(c("pos", "neg", "both"))
        ),
        selectInput("alpha",
                    "Level of statistical significance ",
                    as.list(c(0.01, 0.05, 0.1)))
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
               DT::dataTableOutput("dataTable")),
      tabPanel("STL Decomposition",
               br(),
               withSpinner(plotOutput("decomp", height = "500px"))),
      tabPanel(
        "Anomalies",
        br(),
        withSpinner(plotOutput("anomalies", height = "500px")),
        br(),
        h4("Anormal Points"),
        br(),
        DT::dataTableOutput("anomalyTable")
      )
    )
  ))
))
