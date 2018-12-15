library(shiny); library(shinydashboard); library(dplyr); library(rgdal); library(animation); library(rlist); library(memisc); library("splines"); library("lme4"); library("SpatioTemporal"); library("sp"); library("mgcv"); library("knitr"); library("ape"); library("spdep"); library("CARBayesST"); library(ggplot2)

load("data/dat.R")
# load("data/dat_car.RData")
# load("data/W.R")
load("data/car_pneumonia.R")
load("data/car_asthma_older.R")
load("data/car_asthma_young.R")
load("data/car_heart_fail.R")
load("data/car_diabetes_st.R")
cali <- readOGR(dsn = "data/CA_Counties", layer = "CA_Counties_TIGER2016")



######## Ruthe's functions #########

# outcome plotting function
caplot <- function(yr, var, cutoffs = NULL, double = F) #year: numeric input, var: character input
{
  if (!double)
  {
    par(oma = c(4, 0, 0, 0), mar = c(2.5, 0.5, 1.5, 0.5))
  } else {
    par(oma = c(4, 0, 0, 0), mar = c(3.5, 0.5, 1.5, 0.5))
  }
  df <- dat %>% filter(year == yr) %>% dplyr::select_("county", var)
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
  if (!double)
  {
    legend("bottom", legend = levels(cut(unlist(df[ , var]), breaks = brks, include.lowest = T)), title = "Rate (per 100,000 people at risk)", fill = mycols, horiz = TRUE, bty = "n", cex = 1, xpd = T, inset = c(0, -0.1))
  } else {
    legend("bottom", legend = levels(cut(unlist(df[ , var]), breaks = brks, include.lowest = T)), title = "Rate (per 100,000 people at risk)", fill = mycols, ncol = 3, bty = "n", cex = 1, xpd = T, inset = c(0, -0.2))
  }
}

# PM 2.5 plotting function
pmplot <- function(yr, legend = T) # special function for PM 2.5 plots
{
  df <- dat %>% filter(year == yr) %>% dplyr::select(county, pm25)
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


####### Xinye's functions ############

car.model <- function(y){
  obj <- ifelse(y == "asthma_young", car_asthma_young,
                ifelse(y == "asthma_older", car_asthma_older,
                       ifelse(y == "diabetes_st", car_diabetes_st,
                              ifelse(y == "heart_fail", car_heart_fail, car_pneumonia))))
  point_estimate <- unname(round(obj[[1]][c(2:5),1],2))
  lb <- round(obj[[1]][c(2:5),2],2)
  ub <- round(obj[[1]][c(2:5),3],2)
  CI <- noquote(paste("(",lb,",",ub,")",sep = ""))
  var_name <- c("pm25","Age>60 (%)", "Black (%)", ">Bachelor (%)")
  model_summary <- cbind(var_name, point_estimate, CI)
  colnames(model_summary) <- c("","Estimate","95% Credible Interval")
  tb <- kable(model_summary)
  return(tb)
}

##### Emily's functions #######
# Gaussian distribution
glm_fx <- function(health_outcome)
{
  i.col <- which(colnames(dat) == health_outcome)
  
  dat$year_center <- scale(dat$year, scale = FALSE)
  q.year <- quantile(dat$year_center, c(0.25, 0.50, 0.75))
  
  fit <- lmer(unlist(dat[,i.col]) ~ pm25 + ns(year_center, knots = q.year) + age60_perc + est.black.percent + (1|region/county), 
              data = dat)
  
  return(fit)
}

interpret_fx <- function(fit)
{
  # Identify outcome variable from fit
  health_outcome <- as.character(names(fit@frame$`unlist(dat[, i.col])`)[1])
  health_outcome <- substr(health_outcome, 1, nchar(health_outcome)-1)
  
  # Redefine health outcome
  health_outcome <- ifelse(health_outcome == "amputation_diab", "amputation due to diabetes",
                           ifelse(health_outcome == "angina", "angina",
                                  ifelse(health_outcome == "asthma_older", "COPD or asthma in older adults (age 40+)",
                                         ifelse(health_outcome == "asthma_young", "asthma in younger adults (age 18-39)",
                                                ifelse(health_outcome == "dehydration", "dehydration",
                                                       ifelse(health_outcome == "diabetes_lt", "diabetes long-term complications",
                                                              ifelse(health_outcome == "diabetes_st", "diabetes short-term complications",
                                                                     ifelse(health_outcome == "diabetes_uc", "uncontrolled diabetes complications",
                                                                            ifelse(health_outcome == "heart_fail", "heart failure", 
                                                                                   ifelse(health_outcome == "hypertension", "hypertension",
                                                                                          ifelse(health_outcome == "pneumonia", "pneumonia",
                                                                                                 ifelse(health_outcome == "uti", "UTI",
                                                                                                        health_outcome))))))))))))
  
  # Identify relevant coefficients
  i.int <- which(rownames(summary(fit)$coefficients) == "(Intercept)")
  i.pm25 <- which(rownames(summary(fit)$coefficients) == "pm25")
  
  # Save coefficient values
  int <- round(summary(fit)$coefficients[i.int,1],2)
  int.se <- round(summary(fit)$coefficients[i.int,2],2)
  pm25 <- round(summary(fit)$coefficients[i.pm25,1],2)
  pm25.se <- round(summary(fit)$coefficients[i.pm25,2],2)
  
  # Interpretation
  interpretation <- paste("The expected hospitalization rate for ", health_outcome, " is ", int, " hospitalizations per 100,000 people at risk when there are zero days over the pm2.5 national standard (95% CI: (", round(int - 1.96*int.se, 2), ", ", round(int + 1.96*int.se,2), ")). For every additional day over the national pm2.5 standard, we expect a ", pm25, " change in this hospitalization rate (95% CI: (", round(pm25 - 1.96*pm25.se, 2), ", ", round(pm25 + 1.96*pm25.se, 2), ")).", sep = "")
  
  return(interpretation)
}

plot_fx <- function(health_outcome, x_axis)
{
  # Create centered year variable; calculate quartiles; store unique values in vector
  dat$year_center <- scale(dat$year, scale = FALSE)
  q.year <- quantile(dat$year_center, c(0.25, 0.50, 0.75))
  year_vector <- as.vector(unique(dat$year_center))
  
  # Calculate average value for percent black
  dat <- group_by(dat, county) %>%
    mutate(mean_black_percent = mean(est.black.percent))
  
  # Calculate spline basis expansion
  m <- model.matrix(~ns(year_vector, knots = q.year))
  m <- as.data.frame(m)
  m$year_center <- year_vector
  
  # Create dataframe for plotting
  plot_df <- expand.grid(year_center = unique(dat$year_center),
                         pm25 = as.numeric(min(dat$pm25, na.rm = TRUE):max(dat$pm25, na.rm = TRUE)),
                         vars = unique(paste(dat$county, dat$region, 
                                             dat$age60_perc, dat$mean_black_percent, sep = "-"))) 
  
  plot_df <- tidyr::separate(plot_df, vars, 
                      into = c("county","region","age60_perc","est.black.percent"), 
                      sep = "[-]")
  
  plot_df$age60_perc <- as.numeric(plot_df$age60_perc)
  plot_df$est.black.percent <- as.numeric(plot_df$est.black.percent)
  
  plot_df <- left_join(plot_df, m, by = "year_center") %>%
    mutate(interaction = paste(county, ":", region, sep = "")) %>%
    filter(interaction %in% rownames(head(ranef(glm_fx(health_outcome)))$`county:region`))
  
  plot_df$Estimate <- predict(glm_fx(health_outcome), plot_df)
  plot_df$Estimate <- ifelse(plot_df$Estimate < 0, 0, plot_df$Estimate)
  plot_df$year <- plot_df$year_center + mean(dat$year)
  
  # Create labeller 
  region_labels <- c("Coastal", "Farm", "Imperial",
                     "Northern", "San Francisco")
  names(region_labels) <- c("coastal", "farm", "imperial", 
                            "northern", "sanfrancisco")
  
  # Redefine health outcome
  health_outcome <- ifelse(health_outcome == "amputation_diab", "amputation due to diabetes",
                           ifelse(health_outcome == "angina", "angina",
                                  ifelse(health_outcome == "asthma_older", "COPD or asthma in older adults (age 40+)",
                                         ifelse(health_outcome == "asthma_young", "asthma in younger adults (age 18-39)",
                                                ifelse(health_outcome == "dehydration", "dehydration",
                                                       ifelse(health_outcome == "diabetes_lt", "diabetes long-term complications",
                                                              ifelse(health_outcome == "diabetes_st", "diabetes short-term complications",
                                                                     ifelse(health_outcome == "diabetes_uc", "uncontrolled diabetes complications",
                                                                            ifelse(health_outcome == "heart_fail", "heart failure", 
                                                                                   ifelse(health_outcome == "hypertension", "hypertension",
                                                                                          ifelse(health_outcome == "pneumonia", "pneumonia",
                                                                                                 ifelse(health_outcome == "uti", "UTI",
                                                                                                        health_outcome))))))))))))
  
  if (x_axis == "Year" | x_axis == "year")
  {
    plot <- filter(plot_df, pm25 == 0) %>%
      ggplot(aes(x = year, y = Estimate)) +   
      geom_line(aes(color = county)) + 
      facet_grid(~ region, labeller = labeller(region = region_labels)) + 
      ggtitle(paste("Estimated ", health_outcome, " hospitalization rate", sep = "")) +
      xlab("\nYear") +
      ylab("Hospitalizations per 100,000 at risk\n") +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 90), 
            plot.title = element_text(hjust = 0.5),
            legend.position = "bottom",
            legend.title = element_blank())
  }
  
  if (x_axis == "pm25")
  {
    plot <- filter(plot_df, year == 2012) %>%
      ggplot(aes(x = pm25, y = Estimate)) +
      geom_line(aes(color = county)) + 
      facet_grid(~region, labeller = labeller(region = region_labels)) +
      ggtitle(paste("Estimated ", health_outcome, " hospitalization rate", sep = "")) +
      xlab("\nAnnual number of days over pm2.5 national standard") +
      ylab("Hospitalizations per 100,000 at risk\n") +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 90), 
            plot.title = element_text(hjust = 0.5),
            legend.position = "bottom",
            legend.title = element_blank())
  }
  return(plot)
}
