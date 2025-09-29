library(shiny)

ui <- fluidPage(
  actionButton("goButton", "Click Me")
)

server <- function(input, output) {
  observeEvent(input$goButton, {
    showNotification("Button clicked!")
  })
}

shinyApp(ui, server)
