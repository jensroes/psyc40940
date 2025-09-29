# Load packages
library(shiny)

# User input
ui <- fluidPage(
  sliderInput("num", "Choose a number", 1, 100, 50),
  textOutput("result")
)

# Server backend
server <- function(input, output) {
  output$result <- renderText({
    paste("You chose", input$num)
  })
}

# Run app
shinyApp(ui, server)

# Tasks
#- Add a second input: `textInput()`
#- Display both inputs in the output
