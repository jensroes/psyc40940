library(shiny)
library(psyntur)

ui <- fluidPage(
  sliderInput("bins", "Number of bins", min = 5, max = 50, value = 30),
  plotOutput("histPlot")
)

server <- function(input, output) {

  output$histPlot <- renderPlot({
    histogram(data = NULL, x = rnorm(500), bins = input$bins)
  })
}

shinyApp(ui, server)
