
library(shiny)
library(plotly)

hrdata <- read.csv("./Data/HRdata.csv")

hrdata <- filter(.data = hrdata, hrdata$time >= 1900)


fluidPage(
  
  titlePanel(title = '', windowTitle = 'Culture of Insight'),
  
  sidebarLayout(position = 'left',
    sidebarPanel(
      style = "background-color: #ffffff; border-color: #ffffff; 
                 font-family: Moderat, Droid Sans, sans-serif",
      img(src="Cofi_logo.png", height = '100', width = '167', align = 'left'),
      br(),
      br(),
      br(),
      br(),
      br(),
      sliderInput('time', 'Year', min = min(hrdata$time), max = max(hrdata$time),
                  value = min(hrdata$time), step=1, round=0, 
                  animate=animationOptions(interval = 300, loop=F, 
                                           playButton = list(br(), strong("Click to Animate!")),
                                           pauseButton = list(br(), strong("Pause"))),
                  sep = "", width = 'auto'),
      wellPanel(align = 'left', style = "font-size: 12px",
        p("Here at Culture of Insight, we're true believers in the powers of interactive data visualisation
          to deliver the underlying insight behind the numbers."),
        p("There's no better example of this than Hans Rosling's legendary animated bubble charts. Never have so 
          many variables been represented so elegantly."),
        p("So we decided to build our own version as a tribute to the great man! 
          (and threw in a choropleth map for good measure)"),
        p("Animate the slider to witness change over time. Pause the slider at any time and dig deeper into the data by using all the interactive capabilities
           on offer, including a high quaility download image of the plot/map."),
        p("Have fun!"),
        a("Culture of Insight.", href = "http://cultureofinsight.com")
      )
    ),
    
    mainPanel(style = "font-family: Moderat, Droid Sans, sans-serif",
      h1(style = "color: #2c7fb8; font-family: Moderat, Droid Sans, sans-serif",
                 strong("Set Your Data Free")
              ), 
      h4(style = "color: #41b6c4; font-family: Moderat, Droid Sans, sans-serif", 
                 em("the Hans Rosling way")
              ),
      br(),
      br(),
      tabsetPanel(
        tabPanel("Plot",
                 plotlyOutput('plot', height = "450px"),
                 verbatimTextOutput("event"),
                 p("Data Source: Gapminder", align = "right", style = "font-size: 10px")
        ),
        tabPanel(
          "Map",
          plotlyOutput('map', height = "600px"),
          p("Data Source: Gapminder", align = "right", style = "font-size: 10px")
        )
      )
    )
  
  )
  
)