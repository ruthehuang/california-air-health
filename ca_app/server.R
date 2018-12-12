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
    
    output$pmmap_big <- renderPlot({
      par(oma = c(4, 0, 0, 0), mar = c(0.5, 0.5, 1.5, 0.5), mfrow = c(2, 4))
      pmplot(2010, legend = F)
      pmplot(2011, legend = F)
      pmplot(2012, legend = F)
      pmplot(2013, legend = F)
      pmplot(2014, legend = F)
      pmplot(2015, legend = F)
      pmplot(2016, legend = F)
      pmplot(2017, legend = F)
      par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
      plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
      legend("bottom", legend = levels(cut(dat$pm25, breaks = c(0, 3, 6, 10, 20, 100), include.lowest = T)), fill = c("darkseagreen1", "mediumspringgreen", "darkturquoise", "dodgerblue2", "navy"), xpd = TRUE, horiz = TRUE, inset = c(0, 0), bty = "n", cex = 2)
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