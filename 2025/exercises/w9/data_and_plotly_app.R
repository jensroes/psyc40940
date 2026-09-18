# Load packages
library(shiny)
library(tidyverse)
library(plotly)

# Load data
spellname <- read_csv("data/spellname.csv")

ui <- fluidPage(
  plotOutput("myplot")
)


server <- function(input, output) {

  output$myplot <- renderPlot({
    ggplot(spellname, aes(x = dur, y = rt)) +
      geom_point()
  })


}

shinyApp(ui, server)
