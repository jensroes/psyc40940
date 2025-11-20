library(shiny)
library(plotly)
library(tidyverse)

# Load data
spellname <- read_csv("data/spellname.csv") %>%
  mutate(across(c(rt, dur), log))

# UI
ui <- fluidPage(
  plotlyOutput("scatter3D")
)

# Server
server <- function(input, output) {
  output$scatter3D <- renderPlotly({
    plot_ly(
      data = spellname,
      x = ~freq,
      y = ~rt,
      z = ~dur,
      color = ~modality,
      type = "scatter3d",
      mode = "markers",
      marker = list(size = 3)
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)
