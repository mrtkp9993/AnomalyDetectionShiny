library(AnomalyDetection)
library(readr)
library(shiny)
library(tibbletime)
library(tidyverse)

shinyServer(function(input, output, session) {
  
  dataInput <- reactive(
    {
      req(input$inputFile)
      ts_data <- read_csv(input$inputFile$datapath, col_names = input$headers)
      return(ts_data)
    }
  )
  
  output$table <- renderTable({
    data_raw <- dataInput()
    dataCol <- input$dataCol
    dateCol <- input$dateCol
    data <- pull(data_raw, dataCol)
    date <- pull(data_raw, dateCol)
    return(head(data.frame(date, data)))
  })
  
  observeEvent(dataInput(), {
    updateSelectInput(session, "dataCol", choices = names(dataInput()))
  })
  
  observeEvent(dataInput(), {
    updateSelectInput(session, "dateCol", choices = names(dataInput()))
  })
    
  make_ts <- reactive(
    {
      data_raw <- dataInput()
      dataCol <- input$dataCol
      dateCol <- input$dateCol
      startDate <- input$startDate
      freq <- input$freq
      data <- pull(data_raw, dataCol)
      date <- pull(data_raw, dateCol)
      ts_data <- ts(data, 
                    start = startDate,
                    frequency = as.integer(freq))
      return(ts_data)
    }
  )
  
  output$decomp <- renderPlot(
    {
      ts_data <- make_ts()
      return(plot(stl(ts_data, "periodic")))
    }
  )
  
  
  output$anomalies <- renderPlot(
  {
      ts_data <- make_ts()
      print(as.vector(ts_data))
      anom_data <<- AnomalyDetectionVec(x = as.vector(ts_data),
                                        max_anoms = 0.02,
                                        period = as.integer(input$freq),
                                        direction = 'both', 
                                        plot = T)
      return(anom_data$plot)
  }
  )
})
