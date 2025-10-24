library(shiny)

ui <- fluidPage(
  numericInput("max", "Maximum", 30),
  sliderInput("n", "n", min = 0, max = 100, value = 20)
)

server <- function(input, output) {
  observeEvent(input$max, {
    updateSliderInput(inputId = "n", max = input$max)
  })
}


shinyApp(ui, server)

