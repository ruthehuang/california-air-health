library(shiny); library(shinydashboard); library(dplyr); library(rgdal)

dat <- load("data/dat.Rdata")
cali <- readOGR(dsn = "data/CA_Counties", layer = "CA_Counties_TIGER2016")