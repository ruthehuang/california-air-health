library(shiny); library(shinydashboard); library(dplyr); library(rgdal); library(animation); library(rlist)

load("data/dat.R")
cali <- readOGR(dsn = "data/CA_Counties", layer = "CA_Counties_TIGER2016")

# outcome plotting function
caplot <- function(yr, var, cutoffs = NULL) #year: numeric input, var: character input
{
  par(oma = c(4, 0, 0, 0), mar = c(2.5, 0.5, 1.5, 0.5))
  df <- dat %>% filter(year == yr) %>% select_("county", var)
  map <- merge(cali, df, by.x = "NAME", by.y = "county", all.x = T)
  if (length(cutoffs) == 0)
  {
    brks <- quantile(map@data[ , var], seq(0, 1, by = 0.2), na.rm = T)
    mycols <- c("rosybrown1", "palevioletred1", "deeppink1", "magenta3", "purple4")
  } else {
    brks <- cutoffs
    mycols <- c("cornsilk1", "goldenrod1", "darkorange", "firebrick2", "darkred")
  }
  cols <- as.character(cut(map@data[ , var], breaks = brks, labels = mycols))
  
  plot(map, col = "grey77", border = NA, main = yr, cex.main = 1.5)
  plot(map, col = cols, add = T, border = NA)
  legend("bottom", legend = levels(cut(unlist(df[ , var]), breaks = brks, include.lowest = T)), title = "Rate (per 100,000 people at risk)", fill = mycols, horiz = TRUE, bty = "n", cex = 1, xpd = T, inset = c(0, -0.1))
}

# PM 2.5 plotting function
pmplot <- function(yr, legend = T) # special function for PM 2.5 plots
{
  df <- dat %>% filter(year == yr) %>% select(county, pm25)
  map <- merge(cali, df, by.x = "NAME", by.y = "county", all.x = T)
  cols <- as.character(cut(map@data[ , "pm25"], breaks = c(0, 3, 6, 10, 20, 100), include.lowest = T, labels = c("darkseagreen1", "mediumspringgreen", "darkturquoise", "dodgerblue2", "navy")))

  plot(map, col = "grey77", border = NA, main = yr, cex.main = 1.5)
  plot(map, col = cols, add = T, border = NA)
  if (legend)
  {
    legend("bottom", legend = levels(cut(unlist(df[ , "pm25"]), breaks = c(0, 3, 6, 10, 20, 100), include.lowest = T)), fill = c("darkseagreen1", "mediumspringgreen", "darkturquoise", "dodgerblue2", "navy"), title = "Annual Days over National PM 2.5 Level", horiz = TRUE, bty = "n", cex = 1, xpd = T, inset = c(0, -0.1)) 
  }
}

# dictionary of cutoffs for color-coding
cutoffs <- list(angina = c(0, 10, 20, 30, 45, 65), asthma_young = c(0, 10, 20, 30, 45, 125), asthma_older = c(100, 250, 400, 600, 800, 1000), pneumonia = c(50, 100, 200, 300, 400, 550), dehydration = c(30, 80, 100, 150, 200, 320), diabetes_st = c(15, 45, 75, 100, 120, 150), diabetes_lt = c(20, 50, 80, 100, 150, 230), diabetes_uc = c(0, 5, 15, 30, 60, 100), amputation_diab = c(0, 10, 20, 30, 45, 65), heart_fail = c(120, 200, 300, 400, 500, 600), hypertension = c(0, 10, 25, 40, 60, 120), perf_appendix = c(15, 35, 50, 100, 500, 700), uti = c(35, 100, 125, 150, 200, 270))



