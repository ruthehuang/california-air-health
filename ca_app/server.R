shinyServer(
  function(input, output)
  {
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
    
    output$omap_cont <- renderImage({
      outfile <- tempfile(fileext = '.gif')

      saveGIF({
        ani.options(nmax = 7, interval = 2)
        if (input$quintile)
        {
          for (y in 2010:2017)
          {
            caplot(yr = y, var = input$outcome)
          }
        } else {
          for (y in 2010:2017)
          {
            caplot(yr = y, var = input$outcome, cutoffs = breaks())
          }
        }
      }, movie.name = outfile, ani.width = 800, ani.height = 500)

      list(src = outfile, contentType = 'image/gif', width = 800, height = 500)
    }, deleteFile = T)
    
    output$pmmap_cont <- renderImage({
      outfile <- tempfile(fileext = '.gif')
      
      saveGIF({
        ani.options(nmax = 7, interval = 2)
        for (y in 2010:2017)
        {
          pmplot(yr = y)
        }
      }, movie.name = outfile, ani.width = 800, ani.height = 500)
      
      list(src = outfile, contentType = 'image/gif', width = 800, height = 500)
    }, deleteFile = T)
    
  }
)