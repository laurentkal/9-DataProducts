#' Checklist:
#' Input ((widget: textbox, radio button, checkbox, ...))
#' Some operation on the ui input in sever.R
#' Some reactive output displayed as a result of server calculations
#' documentation should be at the Shiny website itself. Do not post to an external link
#' CHECK DATASET (TOTAL <)
#' GVISCHART: ne marche qu'avec Internet

library(shiny)
library(googleVis)
library(rCharts)
library(dplyr)

source("helpers.R")


shinyServer(function(input, output) { 
        # Returns the type of alcohol
        # Add a conditional : 1 seule valeur peut être choisie
        
        
        output$oalcohol <- renderText({
                if (input$goButton == 0)
                        return()
                input$goButton
                isolate(input$id1)
        })
        
        # Returns the best drinkers
        output$ochampion <- renderText({
                if (input$goButton == 0)
                        return()
                input$goButton
                isolate(id1 <- input$id1) 
                mydata[which.max(mydata[, id1]), ]$Country
        })
        
        # Returns a map of the alcohol consumption per country
        output$omap <- renderGvis({
                if (input$goButton == 0)
                        return()
                input$goButton
                isolate(id1 <- input$id1)
                gvisGeoChart(mydata, locationvar = "Country", colorvar = id1) 
        }) 
        
        # Returns a pie chart of the alcohol consumption per continent
        output$opiechart <- renderChart2({
                if (input$goButton == 0)
                        return()
                Continent <- colnames(avgContinent)[1]
                input$goButton
                isolate(id1 <- input$id1)
                p <- nPlot(y = id1, x = Continent, data = avgContinent, type = "pieChart")
                p$chart(donut = TRUE)
                p
        })
        
        # Returns a scatterplot of the alcohol consumption per country vs life expectancy
        output$olm <- renderChart2({
                if (input$goButton == 0)
                        return()
                input$goButton
                isolate(id1 <- input$id1)
                nPlot(y = id1, x = "Expectancy",
                      data = mydata,      
                      color = "Continent", 
                      group = "Continent", 
                      type = "scatterChart")
        })
        
        # Returns a datatable with the dataset
        output$DT <- renderDataTable({
                mydata
        })
        
})
        
 