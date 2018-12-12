shinyServer(
  function(input, output)
  {
    cutoffs <- list(angina = c(0, 10, 20, 30, 45, 65), asthma_young = c(0, 10, 20, 30, 45, 125), asthma_older = c(100, 250, 400, 600, 800, 1000), pneumonia = c(50, 100, 200, 300, 400, 550), dehydration = c(30, 80, 100, 150, 200, 320), diabetes_st = c(15, 45, 75, 100, 120, 150), diabetes_lt = c(20, 50, 80, 100, 150, 230), diabetes_uc = c(0, 5, 15, 30, 60, 100), amputation_diab = c(0, 10, 20, 30, 45, 65), heart_fail = c(120, 200, 300, 400, 500, 600), hypertension = c(0, 10, 25, 40, 60, 120), perf_appendix = c(15, 35, 50, 100, 500, 700), uti = c(35, 100, 125, 150, 200, 270))
    
    breaks <- reactive({
        unlist(list.match(cutoffs, input$outcome))
    })
    
    output$otitle <- renderText({
      paste("Outcome:", input$outcome)
    })
    
    output$omap <- renderPlot({
      if (input$quintile)
      {
        caplot(yr = input$year, var = input$outcome)
      } else {
        caplot(yr = input$year, var = input$outcome, cutoffs = breaks())
      }
    }, height = 500)
    
    output$pmmap <- renderPlot({
      pmplot(yr = input$year)
    }, height = 500)
    
  }
)