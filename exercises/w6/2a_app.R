# Load packages
library(shiny)
library(psyntur)

# User interface
ui <- fluidPage(
  plotOutput("hist")
)

# Server backend
server <- function(input, output) {
  output$hist <- renderPlot({
    histogram(data = NULL, x = rnorm(500))
  })
}

# Run app
shinyApp(ui, server)

