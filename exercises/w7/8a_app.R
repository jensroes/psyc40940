# Load packages
library(shiny)

# Setup user interface
ui <- fluidPage(
  selectInput("type", "type", c("slider", "numeric")),
  uiOutput("numeric")
)

# Setup server function
server <- function(input, output) {
  output$numeric <- renderUI({
    if (input$type == "slider") {
      sliderInput("dynamic", "Your choice", value = 0, min = 0, max = 10)
    } else {
      numericInput("dynamic", "Your choice", value = 0, min = 0, max = 10)
    }
  })
}

# Run app
shinyApp(ui, server)

