shinyUI(
  dashboardPage(
    skin = "purple",
    dashboardHeader(
      tags$li(class = "dropdown",
              tags$style(".main-header {max-height: 40px}"),
              tags$style(".main-header .logo {height: 40px;}"),
              tags$style(".sidebar-toggle {height: 40px; padding-top: 1px !important;}"),
              tags$style(".navbar {min-height:40px !important}")),
      title = "What do California's wildfires mean for health?",
      titleWidth = 1000
      ),
    dashboardSidebar(
      tags$style(".left-side, .main-sidebar {padding-top: 40px}
               
                 .tab { margin-left: 15px; margin-right: 15px}"
      )
    ),
    dashboardBody(
      tags$style(HTML("
                @import url('//fonts.googleapis.com/css?family=Bitter|Cabin:400,700');
                @import url('//fonts.googleapis.com/css?family=Raleway|Cabin:400,700');
                      
                .main-header .logo {
                font-family: 'Bitter';
                font-size: 40px;
                background:#FFF8DC;
                }
                      
                .content-wrapper,
                .right-side {
                background-color: #FFF8DC;
                }
                      
                .box.box-solid.box-primary>.box-header {
                color:#fff;
                background:#EE5C42;
                font-family:'Bitter';
                }
                      
                .box.box-solid.box-primary{
                color:#fff;
                border-bottom-color:#EE5C42; 
                border-left-color:#EE5C42;
                border-right-color:#EE5C42;
                border-top-color:#EE5C42;
                background:#EE5C42
                }
                      
                .skin-purple .main-sidebar {
                background-color: #f4b943;
                line-height:1.42857143;
                color:#ebebeb;
                }
                      
                      ")),
      fluidRow("Hello")
      )
))