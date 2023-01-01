if(!require('timevis')) {
  install.packages('timevis')
  library(timevis)
}
if(!require('shinycssloaders')) {
  install.packages('shinycssloaders')
  library(shinycssloaders)
}
if(!require('shiny')) {
  install.packages('shiny')
  library(shiny)
}

if(!require('shinydashboard')) {
  install.packages('shinydashboard')
  library(shinydashboard)
}
if(!require('DT')) {
  install.packages('DT')
  library(DT)
}
if(!require('dplyr')) {
  install.packages('dplyr')
  library(dplyr)
}
if(!require('leaflet')) {
  install.packages('leaflet')
  library(leaflet)
}


poland_data = read.csv("dataset/occurence_poland.csv")
#Removed the following columns because they contain null or one value for the complete data of Poland.
# "basisOfRecord",
# "collectionCode",
# "previousIdentifications",
# "geodeticDatum",
# "dataGeneralizations",
# "continent",
# "country",
# "countryCode",
# "stateProvince",
# "behavior",
# "associatedTaxa",
# "rightsHolder",
# "license"

poland_data = select(poland_data, -c("basisOfRecord",
                                     "collectionCode",
                                     "previousIdentifications",
                                     "geodeticDatum",
                                     "dataGeneralizations",
                                     "continent",
                                     "country",
                                     "countryCode",
                                     "stateProvince",
                                     "behavior",
                                     "associatedTaxa",
                                     "rightsHolder",
                                     "license"))


source("ui.R")
source("server.R")