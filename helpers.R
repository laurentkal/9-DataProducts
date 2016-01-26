library(dplyr)
library(reshape2)
library(rCharts)
library(RCurl)
library(foreign)

#' Data processing file for Data products project
#' The file was downloaded from FiveThirtyEigyht github data repo. You can clone 
#' the comprehensive data repo using this URL: https://github.com/fivethirtyeight/data, 
#' it has tons of cool datasets. In this project I read the drinks dataset directly from Github.


#Load drinks data into R, from 538 github repo
url <- "https://raw.githubusercontent.com/fivethirtyeight/data/master/alcohol-consumption/drinks.csv"
drinks <- getURL(url)
drinks <- read.csv(textConnection(drinks))

drinks$Total <- rowSums(drinks[, -c(1,5)], na.rm = TRUE)
colnames(drinks) <- c("Country", "Beer", "Spirit", "Wine", "Pure", "Total") 
dim(drinks)
str(drinks)
colSums(is.na(drinks))

#Load a life expectancy dataset from World Health Organization
lifexp <- getURL("https://ckannet-storage.commondatastorage.googleapis.com/2013-09-27T16:41:35.836Z/life-expectancy-by-country-at-birth.csv")
lifexp <- read.csv(textConnection(lifexp))
lifexp <- lifexp[which(lifexp$Year == 2011 & lifexp$SEX == "BTSX" & lifexp$Indicator == "Life expectancy at birth (years)"), c(10, 8, 14)]
colnames(lifexp) <- c("Country", "Continent", "Expectancy")

#Harmonize and melt both datasets based on country name. 
unmatched <- which(!(lifexp$Country %in% drinks$Country))
drinks$Country <- as.character(drinks$Country)
lifexp$Country <- as.character(lifexp$Country)
lifexp[unmatched, ]$Country <- c("Antigua & Barbuda",
                                 "Bolivia",
                                 "Bosnia-Herzegovina",
                                 "Brunei",
                                 "Cabo Verde",
                                 "Cote d'Ivoire",
                                 "North Korea",
                                 "DR Congo",
                                 "Iran",
                                 "Laos",
                                 "Micronesia",
                                 "South Korea",
                                 "Moldova",
                                 "St. Kitts & Nevis",
                                 "St. Lucia",
                                 "St. Vincent & the Grenadines",
                                 "Sao Tome and Principe",
                                 "Sudan",
                                 "Syria",
                                 "Macedonia",
                                 "Trinidad and Tobago",
                                 "Tanzania",
                                 "United States", 
                                 "Venezuela",
                                 "Vietnam")
mydata <- merge(drinks, lifexp, by = "Country")
mydata <- mydata[c("Continent", "Country", "Expectancy", "Beer", "Spirit", "Wine", "Pure", "Total")]

#Create a data frame for the average drinking per continent and per alcohol type
beer <- summarize(group_by(mydata, Continent), mean(Beer))
spirit <- summarize(group_by(mydata, Continent), mean(Spirit))
wine <- summarize(group_by(mydata, Continent), mean(Wine))
pure <- summarize(group_by(mydata, Continent), mean(Pure))
total <-summarize(group_by(mydata, Continent), mean(Total))
avgContinent <- cbind(beer, spirit[, 2], wine[, 2], pure[, 2], total[, 2])
colnames(avgContinent) <- c("Continent", "Beer", "Spirit", "Wine", "Pure", "Total")