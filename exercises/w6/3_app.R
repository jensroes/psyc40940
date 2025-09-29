# Load packages
library(shiny)
library(psyntur)
library(reactlog)

# Visualise reactivity
reactlog_enable()

# User interface
ui <- fluidPage(
  # Add input device slider
  sliderInput("---", label = "---", min = ---, max = ---, step = ---, value = ---),
  sliderInput("sd", label = "Choose a value for the SD", min = 1, max = 2, step = .1, value = 1),
  #
  plotOutput("my_hist")
)

# Server backend
server <- function(input, output) {
  hist_data <- reactive({
    histogram(data = NULL,
              x = rnorm(500,
                        mean = ---,
                        sd = input$sd),
              bins = 20) +
      coord_cartesian(xlim = c(-4, 4),
                      ylim = c(0, 70))
  })

  output$my_hist <- renderPlot({
    plot(hist_data())
  })
}

# Run app
shinyApp(ui, server)

# Task:
#- Enable reactlog and inspect the graph.
#- Change the code so the user can change both, the mean and the SD of the histogram.
# (replace the "---")
#- Run the app and then try ctrl + F3 to check the reactivity log
