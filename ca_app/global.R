library(shiny); library(shinydashboard); library(dplyr); library(rgdal); library(animation)

dat <- load("data/dat.Rdata")
cali <- readOGR(dsn = "data/CA_Counties", layer = "CA_Counties_TIGER2016")

# outcome plotting function
caplot <- function(yr, var, cutoffs = NULL) #year: numeric input, var: character input
{
  df <- dat %>% filter(year == yr) %>% select(county, var)
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
  
  plot(map, col = "grey77", border = NA, main = yr, cex.main = 2)
  plot(map, col = cols, add = T, border = NA)
}

# PM 2.5 plotting function
pmplot <- function(yr) # special function for PM 2.5 plots
{
  df <- dat %>% filter(year == yr) %>% select(county, pm25)
  map <- merge(cali, df, by.x = "NAME", by.y = "county", all.x = T)
  cols <- as.character(cut(map@data[ , "pm25"], breaks = c(0, 3, 6, 10, 20, 100), include.lowest = T, labels = c("darkseagreen1", "mediumspringgreen", "darkturquoise", "dodgerblue2", "navy")))
  
  plot(map, col = "grey77", border = NA, main = yr, cex.main = 2)
  plot(map, col = cols, add = T, border = NA)
  # legend(x = -12890659, y = 4927837, legend = levels(cut(map@data[ , "pm25"], breaks = c(0, 3, 6, 10, 20, 100), include.lowest = T)), fill = c("darkseagreen1", "mediumspringgreen", "darkturquoise", "dodgerblue2", "navy"), cex = 1)
}

# Arrange maps into 8
bigplot <- function(var, cut = NULL, omit = F)
{
  if (length(cut) == 0)
  {
    par(oma = c(4, 0, 0, 0), mar = c(0.5, 0.5, 1.5, 0.5), mfrow = c(2, 4))
    caplot(2010, var)
    caplot(2011, var)
    caplot(2012, var)
    caplot(2013, var)
    caplot(2014, var)
    caplot(2015, var)
    if (omit == F)
    {
      caplot(2016, var)
      caplot(2017, var)
    }
    par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
    plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
    legend("bottom", legend = c("[0-20th percentile]", "(20-40th percentile]", "(40-60th percentile]", "(60-80th percentile]", "(80-100th percentile]"), fill = c("rosybrown1", "palevioletred1", "deeppink1", "magenta3", "purple4"), xpd = TRUE, horiz = TRUE, inset = c(0, 0), bty = "n", cex = 2)
  } else {
    par(oma = c(4, 0, 0, 0), mar = c(0.5, 0.5, 1.5, 0.5), mfrow = c(2, 4))
    caplot(2010, var, cutoffs = cut)
    caplot(2011, var, cutoffs = cut)
    caplot(2012, var, cutoffs = cut)
    caplot(2013, var, cutoffs = cut)
    caplot(2014, var, cutoffs = cut)
    caplot(2015, var, cutoffs = cut)
    caplot(2016, var, cutoffs = cut)
    caplot(2017, var, cutoffs = cut)
    par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
    plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
    legend("bottom", legend = levels(cut(unlist(dat[ , var]), breaks = cut, include.lowest = T)), fill = c("cornsilk1", "goldenrod1", "darkorange", "firebrick2", "darkred"), xpd = TRUE, horiz = TRUE, inset = c(0, 0), bty = "n", cex = 2)
  }
}