library(shiny)

ui <- fluidPage(
  sliderInput("x1", "x1", 0, min = -10, max = 10),
  actionButton("reset", "Reset")
)

server <- function(input, output, session) {
  observeEvent(input$reset, {
    updateSliderInput(inputId = "x1", value = 0)
  })
}

shinyApp(ui, server)
