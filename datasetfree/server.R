
library(shiny)
library(plotly)
library(dplyr)
library(magrittr)
library(RColorBrewer)

hrdata <- read.csv("./Data/HRdata.csv")

hrdata <- filter(.data = hrdata, hrdata$time >= 1900)


function(input, output) {
  
  dataset <- reactive({
    filter(.data = hrdata, hrdata$time == input$time)
  })
  
  f = list(family = "Moderat, Droid Sans, sans-serif",
           color = "#2c7fb8")
  
  m <- list(
    l = 50,
    r = 50,
    b = 50,
    t = 80,
    pad = 4
  )
  
  output$plot <- renderPlotly({
    
    colors = c('#7fc97f','#386cb0','#ffff99','#fdc086', '#beaed4')
    
    p <- plot_ly(dataset(), x = ~gdp_per_capita_cppp, y = ~life_expectancy, color = ~continent, size = ~population, colors = colors, 
                 type = 'scatter', mode = 'markers',
                 marker = list(symbol = 'circle', sizemode = 'diameter', line = list(width = 1, color = '#002266')),
                 text = ~paste('Country:', country, '<br>Life Expectancy:', life_expectancy, '<br>GDP:', gdp_per_capita_cppp,
                               '<br>Population:', population)) %>%
      layout(title = 'Life Expectancy v. Per Capita GDP',
             xaxis = list(title = 'GDP per capita cPPP $',
                          gridcolor = 'rgb(243, 243, 243)',
                          range = c(2.003297660701705, 5.191505530708712),
                          type = 'log',
                          zerolinewidth = 1,
                          ticklen = 3,
                          tickcolor = "#2c7fb8",
                          gridwidth = 2),
             yaxis = list(title = 'Life Expectancy (years)',
                          gridcolor = 'rgb(243, 243, 243)',
                          range = c(10, 100),
                          zerolinewidth = 1,
                          ticklen = 3,
                          tickcolor = "#2c7fb8",
                          gridwith = 2),
             paper_bgcolor = '#ffffff',
             plot_bgcolor = '#ffffff',
             margin = m, font = f)
                   

    print(p)
    
  })
  
  output$map <- renderPlotly({
    
    # light grey boundaries
    l <- list(color = '#000000', width = 0.5)
    
    # specify map projection/options
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      #showocean = TRUE,
      #oceancolor = '#000000',
      #showland = TRUE,
      #landcolor = '#000000',
      projection = list(type = 'Mercator')
    )
    
    p <- plot_geo(dataset()) %>%
      add_trace(
        z = ~life_expectancy, color = ~life_expectancy, colors = brewer.pal(11,"RdBu"),
        text = ~country, locations = ~geo, marker = list(line = l)
      ) %>%
      colorbar(title = 'Years', limits = c(0,90), thickness = 15, len = 0.75,
               y = 0.6) %>%
      layout(
        geo = g, font = f, margin = list(t = 80),title = "Life Expectancy (diverging colour scale)"
      ) # autosize = TRUE
    print(p)
    
  })
  
}
