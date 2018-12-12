shinyUI(
  dashboardPage(
    skin = "purple",
    dashboardHeader(
      tags$li(class = "dropdown",
              tags$style(".main-header {max-height: 40px}"),
              tags$style(".main-header .logo {height: 46px;}"),
              tags$style(".sidebar-toggle {height: 40px; padding-top: 3px !important;}"),
              tags$style(".navbar {min-height:40px !important}")),
      title = "What do California's wildfires mean for health?",
      titleWidth = 1000
      ),
    dashboardSidebar(
      tags$style(".left-side, .main-sidebar {padding-top: 40px}
               
                 .tab { margin-left: 15px; margin-right: 15px}"
      ),
      selectInput("outcome", label = h4(HTML("<p style = 'color:white; font-size: 20pt; font-family: Lobster'>Select a health outcome:</p>")), choices = list("Angina" = "angina", "Asthma among young adults" = "asthma_young", "Asthma/COPD among older adults" = "asthma_older", "Pneumonia" = "pneumonia", "Heart failure" = "heart_fail", "Hypertension" = "hypertension", "Dehydration" = "dehydration", "Diabetes, short-term complications" = "diabetes_st", "Diabetes, long-term complications" = "diabetes_lt", "Diabetes, uncontrolled" = "diabetes_uc", "Amputation due to diabetes" = "amputation_diab", "Perforated Appendix" = "perf_appendix", "Urinary tract infection" = "uti"), selected = "hypertension"),
      radioButtons("year", label = h4(HTML("<p style = 'color:white; font-size: 20pt; font-family: Lobster'>Select a year to visualize:</p>")), choices = list("2010" = 2010, "2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014, "2015" = 2015, "2016" = 2016, "2017" = 2017), selected = 2010),
      checkboxInput("quintile", label = "Color maps by quintiles", value = F)
    ),
    dashboardBody(
      tags$style(HTML("
                @import url('//fonts.googleapis.com/css?family=Lobster');
                @import url('//fonts.googleapis.com/css?family=Cabin');
                      
                .main-header .logo {
                font-family: 'Lobster';
                font-size: 40px;
                background:#F5FFFA;
                }
                      
                .content-wrapper,
                .right-side {
                background-color: #F5FFFA;
                }
                      
                .box.box-solid.box-primary>.box-header {
                color:#fff;
                background:#000080;
                font-family:'Lobster';
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
      fluidRow(
        column(width = 6,
               box(title = h4("Health Outcomes by County", style = 'color:white; font-size: 20pt; font-family: Lobster'), width = "100%", status = "primary", solidHeader = T, height = 650, plotOutput("omap"))),
        column(width = 6,
               box(title = h4("Annual Days Over National PM 2.5 Levels by County", style = 'color:white; font-size: 20pt; font-family: Lobster'), width = "100%", status = "primary", solidHeader = T, height = 650, plotOutput("pmmap")))
      )
      )
))