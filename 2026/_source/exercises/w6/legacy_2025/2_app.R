# Load packages
library(shiny)
library(psyntur)
library(reactlog)

# Visualise reactivity
reactlog_enable()

# User interface
ui <- fluidPage(
  sliderInput("bins", "Number of bins:", min = 1, max = 50, value = 30),
  plotOutput("hist")
)

# Server backend
server <- function(input, output) {
  hist_data <- reactive({
    histogram(data = NULL, x = rnorm(500), bins = input$bins) +
      coord_cartesian(xlim = c(-2.5, 2.5),
                      ylim = c(0, 50))
  })

  output$hist <- renderPlot({
    plot(hist_data())
  })
}

# Run app
shinyApp(ui, server)

# Task:
#- Enable reactlog and inspect the graph.
#- Run the app and then try ctrl + F3 to check the reactivity log
