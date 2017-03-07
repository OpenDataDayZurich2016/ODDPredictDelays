## Synopsis

In this project, we fit a simple linear model to predict delays in arrival times of VBZ public transportation vessels using data of 4 weeks. The accompanying shiny app can be found [here](https://lorenzwalthert.shinyapps.io/odd_predict_delays/).

To fit the model, we use the predictors 'weekday', 'vehicle type', 'temperature' and 'precipitation'. 'weekday' and 'vehicle type' are categorical predictors. 'temperature' and 'precipitation' are continuous predictors. 

We obtain data for the predictors 'weekday' and 'vehicle type' from Open Data Zurich (https://www.stadt-zuerich.ch/opendata) and data for the predictors 'temperature' and 'precipitation' from http://www.tecson-data.ch/zurich/mythenquai/.

The delay in arrival times, which is the quantity we want to predict, we obtain from Open Data Zurich as well.

The data set we use for fitting the model contains ca. 6 mio data points. 

To run our model:

 - Clone the project
 - Make directory 'raw' in project root directory
 - Move data into dir 'raw'. If you have the data on a USB stick 'Stadt Zurich Open Data' move    data from USB into directory 'raw'.  
 - Open the RProject in RStudio. 
 - Hit Ctrl+Shift+B to start the Makefile-based project build.
 - Enter remake::create_bindings() in R console to bind to the data object from within R.
