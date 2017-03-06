
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library("readr")
library("remake")
shinyServer(function(input, output) {
  a <- read_rds("model")

  
  output$prediction <- renderText({
    newdata <- data.frame(weekday = input$weekday, 
                          vehicle_type = input$vehicle_type, 
                          temp = input$temp, 
                          humidity = input$humidity,
                          windspeed_max = input$windspeed_max,
                          precipitation = input$precipitation) #input$weekday)
    
    prediction <- predict(a, newdata = newdata)
    paste("Your delay is", round(prediction), "seconds")
    })

})
