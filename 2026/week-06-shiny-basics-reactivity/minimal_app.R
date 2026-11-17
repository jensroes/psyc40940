library(shiny)

ui <- fluidPage(
  numericInput("number", "Choose a number", value = 5),
  textOutput("double")
)

server <- function(input, output) {
  output$double <- renderText({
    input$number * 2
  })
}

shinyApp(ui, server)
