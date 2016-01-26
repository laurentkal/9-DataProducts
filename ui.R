library(shiny)
library(ggvis)
library(googleVis)
library(rCharts)

shinyUI(navbarPage("Alcohol World cup",

        # Main tabpanel page
        tabPanel("Alcohol statistics",
                
                # Sidebar with a checkbox and action button
                sidebarPanel(
                        radioButtons("id1", "Select a type of alcohol:", 
                                           c("Beer" = "Beer", 
                                             "Spirit" = "Spirit", 
                                             "Wine" = "Wine", 
                                             "Total" = "Total",
                                             "Total liters of pure alcohol" = "Pure"
                                        )),
                        actionButton("goButton", "Who drink the most?")
                ),
        
                # Show plots 
                mainPanel(
                  
                        # CSS Code to hide initial error message when no input is selected 
                        tags$style(type="text/css",
                                ".shiny-output-error { visibility: hidden; }",
                                ".shiny-output-error:before { visibility: hidden; }"
                        ),
        
                        # Returns the selected type of alcohol
                        p("The biggest drinkers of"),
                        verbatimTextOutput("oalcohol"),
                          
                        # Returns the heaviest drinkers
                        p("... are: "),
                        verbatimTextOutput("ochampion"),
                            
                        # Map of the consumption per country
                        p(paste("Average consumption per country (Servings per person and per year)")),
                        htmlOutput("omap"),
                          
                        #Pie chart of the average consumption per continent
                        p(paste("Average consumption breakdown per continent (servings per person and per year)")),
                        showOutput("opiechart", "nvd3"),
                
                        #Scatterplot of average alcohol consumption vs life expectancy
                        p("Average alcohol Consumption vs life expectancy: "),
                          showOutput("olm", "nvd3")
                )
        ),
        
        # Tabpanel for the dataset
        tabPanel("Dataset",
                dataTableOutput("DT")),
        
        # Tabpanel for some documentation
        tabPanel("Documentation",
                 mainPanel(
                         p("This shiny app performs analyses on the average alcohol consumption per person 
                           and per country in the world."),
                         p("You need to select one type of alcohol and click on the button. The app reactively calculates the following: "),
                         p("1. The country with the highest average consumption per person for that type of alcohol."),
                         p("2. A map of the average consumption per person and country for that type of alcohol."),
                         p("3. A pie chart with the average consumption per person broken by continent."),
                         p("4. A scatterplot showing the average consumption per person and per country vs the life expectancy at birth."),
                         p("The alcohol statistics come from the World Health Organization, Global Information System on Alcohol and Health (GISAH), 2010. The dataset was downloaded at the ", 
                           a("Five Thirty Eight github repo.", href="https://github.com/fivethirtyeight/data")),
                         p("The ", a("life expectancy at birth statistics", href="https://ckannet-storage.commondatastorage.googleapis.com/2013-09-27T16:41:35.836Z/life-expectancy-by-country-at-birth.csv)"), 
                                     " come from the World Health Organization."),
                         p("You can access to the archived 538 article ", a("there.", href = "http://fivethirtyeight.com/datalab/dear-mona-followup-where-do-people-drink-the-most-beer-wine-and-spirits/"))
                )
        )
))

