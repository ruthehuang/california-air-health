shinyUI(
  dashboardPage(
    skin = "purple",
    dashboardHeader(
      tags$li(class = "dropdown",
              tags$style(".main-header {max-height: 40px}"),
              tags$style(".main-header .logo {height: 46px;}"),
              tags$style(".sidebar-toggle {height: 40px; padding-top: 3px !important;}"),
              tags$style(".navbar {min-height:40px !important}")),
      title = HTML("<p style = 'font-size: 20pt'>What do California's wildfires mean for residents' health?</p>"),
      titleWidth = 800
      ),
    dashboardSidebar(
      tags$style(".left-side, .main-sidebar {padding-top: 32px}
               
                 .tab { margin-left: 15px; margin-right: 15px}"
      ),
      selectInput("outcome", label = h4(HTML("<p style = 'color:white; font-size: 20pt; font-family: Abril Fatface'>Select a health outcome:</p>")), choices = list("Asthma among young adults" = "asthma_young", "Asthma/COPD among older adults" = "asthma_older", "Short-term complications from diabetes" = "diabetes_st", "Heart failure" = "heart_fail", "Pneumonia" = "pneumonia"), selected = "heart_fail"),
      radioButtons("year", label = h4(HTML("<p style = 'color:white; font-size: 20pt; font-family: Abril Fatface'>Select a year to visualize:</p>")), choices = list("2010" = 2010, "2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014, "2015" = 2015, "2016" = 2016, "2017" = 2017), selected = 2010),
      checkboxInput("quintile", label = "Color maps by quintiles", value = F),
      sidebarMenu(
        menuItem(HTML("<p style = 'font-family: Cabin; color:white;'>Main Analysis</p>"), tabName = "single"),
        menuItem(HTML("<p style = 'font-family: Cabin; color:white;'>Visualization Over Time</p>"), tabName = "continuous"),
        menuItem(HTML("<p style = 'font-family: Cabin; color:white;'>About this Project</p>"), tabName = "about")
      )
    ),
    dashboardBody(
      tags$style(HTML("
                @import url('https://fonts.googleapis.com/css?family=Cabin|Abril Fatface');
                      
                .main-header .logo {
                font-family: 'Abril Fatface', cursive;
                font-size: 40px;,
                background:#F5FFFA;
                }
                      
                .content-wrapper,
                .right-side {
                background-color: #F5FFFA;
                }
                      
                .box.box-solid.box-primary>.box-header {
                color:#fff;
                background:#000080;
                font-family:'Abril Fatface';
                }
                      
                .box.box-solid.box-primary{
                color:#fff;
                border-bottom-color:#000080; 
                border-left-color:#000080;
                border-right-color:#000080;
                border-top-color:#000080;
                background:#000080
                }
                      
                .skin-purple .main-sidebar {
                background-color: #48D1CC;
                line-height:1.42857143;
                color:#ebebeb;
                }
                      
                      ")),
      tabItems(
        tabItem(tabName = "single",
                fluidRow(
                  column(width = 6,
                         box(title = h4("Health Outcomes by County", style = 'color:white; font-size: 20pt; font-family: Abril Fatface'), width = "100%", status = "primary", solidHeader = T, align = "center", height = 650, plotOutput("omap"))),
                  column(width = 6,
                         box(title = h4("PM 2.5 Levels", style = 'color:white; font-size: 20pt; font-family: Abril Fatface'), width = "100%", status = "primary", solidHeader = T, align = "center", height = 650, plotOutput("pmmap")))
                ),
                fluidRow(
                  box(title = h4("Analysis: Generalized Linear Mixed Model", style = 'color:white; font-size: 20pt; font-family: Abril Fatface'), width = "100%", status = "primary", solidHeader = T, align = "center", height = 650, column(width = 6, plotOutput("plotyear_eda")), column(width = 6, plotOutput("plotpm25_eda")))),
                fluidRow(
                  column(width = 6,
                         box(title = h4("Analysis: Bayes Conditional Autoregressive Model", style = 'color:white; font-size: 20pt; font-family: Abril Fatface'), width = "100%", status = "primary", solidHeader = T, align = "center", height = 350, tableOutput("outtable"))),
                  column(width = 6,
                         box(width = "100%", status = "primary", solidHeader = T, align = "center", height = 350, p("The exploratory data analysis showed that most of our health outcomes have higher hospitalization rates in the central valley region and the northern region. We also observe that the PM2.5 levels are often higher in the central valley region.", style = 'color: white; font-size: 11pt; font-family: Cabin', class = 'tab'),
                             p("Using a GLMM, we estimate a positive relationship between PM2.5 levels and hospitalization rates due to asthma in younger adults (18-39), COPD or asthma in older adults (40+), diabetes short-term complications, and pneumonia. The only statistically significant result is that for diabetes short-term complications. This significant result could be due to chance because we fit so many regression models to the dataset with different predictors.", style = 'color: white; font-size: 11pt; font-family: Cabin', class = 'tab'),
                             p("Using a Bayes CAR model, we detect a positive association between PM2.5 level and the preventable hospitalization rate resulting from asthma among young adults (age 18-39), asthma among older adults (age 40+), short-term diabetes complications, heart failure, and pneumonia. All of these results are significant.", style = 'color: white; font-size: 11pt; font-family: Cabin', class = 'tab'))))
                ),
        tabItem(tabName = "continuous",
                fluidRow(
                  column(width = 5,
                         box(title = h4("Health Outcomes by County", style = 'color:white; font-size: 20pt; font-family: Abril Fatface'), width = "100%", status = "primary", solidHeader = T, align = "center", height = 550, imageOutput("omap_cont"))),
                  column(width = 7,
                         box(title = h4("PM 2.5 Levels", style = 'color:white; font-size: 20pt; font-family: Abril Fatface'), width = "100%", status = "primary", solidHeader = T, align = "center", height = 550, plotOutput("pmmap_big")))
                )
        ),
        tabItem(tabName = "about",
                fluidRow(
                  column(width = 12,
                         uiOutput("video"))
                ),
                fluidRow(
                  column(width = 9,
                         box(title = h4("Why did we make this app?", style = 'color:white; font-size: 20pt; font-family: Abril Fatface'), width = "100%", status = "primary", solidHeader = T, align = "center", height = 400, p("Nearly 90 million Americans are breathing air that doesn't meet the World Health Oranizations safe PM2.5 limit. The UK Department for Environment, Food & Rural Affairs states that long-term PM2.5 exposure poses a variety of health risks; most commonly, health consequences due to long-term PM2.5 exposure take the form of cardiovascular or respiratory diseases. This poses a serious public health problem because such diseases reduce both quality and length of life.", style = 'color: white; font-size: 11pt; font-family: Cabin', class = 'tab'),
                             p("There are many sources of PM2.5, including vehicular emissions and ash. California's large traffic volume and increasingly frequent wildfires both contribute to the state's PM2.5 levels. While wildfires are natural, climate change is making them more common and more severe. According to the Environmental Protection Agency, the state of California is becoming warmer as a whole and southern California, in particular, is becoming drier. These unnaturally warm and dry conditions promote frequent and devastating wildfires.)", style = 'color: white; font-size: 11pt; font-family: Cabin', class = 'tab'),
                             p("We are interested in investigating California county-level hospitalization rates as a function of the annual number of days each county had PM2.5 levels over the national standard. Our full report can be found at the following Github repo:", style = 'color: white; font-size: 11pt; font-family: Cabin', class = 'tab'),
                             tags$a(href="https://github.com/ruthehuang/california-air-health", "California Air Health")))
                )
                )
      ))
))