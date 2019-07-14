library(AnomalyDetection)
library(DT)
library(readr)
library(shiny)
library(tibbletime)
library(tidyverse)

shinyServer(function(input, output, session) {
  dataInput <- reactive({
    req(input$inputFile)
    ts_data <-
      read_csv(input$inputFile$datapath, col_names = input$headers)
    return(ts_data)
  })
  
  getDateFromInput <- reactive({
    data <- dataInput()
    dateCol <- input$dateCol
    date <- pull(data, dateCol)
    return(date)
  })
  
  getDataFromInput <- reactive({
    data <- dataInput()
    dataCol <- input$dataCol
    data <- pull(data, dataCol)
    return(data)
  })
  
  output$dataTable <- DT::renderDataTable({
    date <- getDateFromInput()
    data <- getDataFromInput()
    return(data.frame(date, data))
  })
  
  observeEvent(dataInput(), {
    updateSelectInput(session, "dataCol", choices = names(dataInput()))
  })
  
  observeEvent(dataInput(), {
    updateSelectInput(session, "dateCol", choices = names(dataInput()))
  })
  
  make_ts <- reactive({
    data <- getDataFromInput()
    startDate <- input$startDate
    freq <- input$freq
    ts_data <- ts(data,
                  start = startDate,
                  frequency = as.integer(freq))
    return(ts_data)
  })
  
  output$decomp <- renderPlot({
    ts_data <- make_ts()
    return(plot(stl(ts_data, "periodic")))
  })
  
  findAnomalies <- reactive({
    ts_data <- make_ts()
    anom_data <- AnomalyDetectionVec(
      x = as.vector(ts_data),
      max_anoms = 0.02,
      direction = 'both',
      alpha = 0.01,
      period = as.integer(input$freq),
      e_value = T,
      plot = T
    )
    return(anom_data)
  })
  
  output$anomalies <- renderPlot({
    anomalies <- findAnomalies()
    return(anomalies$plot)
  })
  
  output$anomalyTable <- DT::renderDataTable({
    anomalies <- findAnomalies()
    return(anomalies$anoms)
  })
})
