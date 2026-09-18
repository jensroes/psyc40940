library(shiny)

ui <- fluidPage(
  sliderInput("slider", "Choose a value", min = 1, max = 100, value = 50)
)

server <- function(input, output) {
  observe({
    print(paste("Slider value is:", input$slider))
  })
}

shinyApp(ui, server)
