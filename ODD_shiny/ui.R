
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Predict your delay"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

      sliderInput("temp", "temparature", min = -10, max = 40, value = 5),
      sliderInput("precipitation", label = "Percipitation", min = 0, max = 50, value = 5),
      selectInput("vehicle_type", 
                  label = "means of transport",
                  choices = c("Bus", "Tram", "Trolly")),
      selectInput("weekday", 
                  label = "day of week",
                  choices = 1:7)
      ),

    # Show a plot of the generated distribution
    mainPanel(
      textOutput("prediction")
      
    )
  )
))
