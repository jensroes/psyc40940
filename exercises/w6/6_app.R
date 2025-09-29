library(shiny)
library(psyntur)

# Notice:
# How to control when outputs update.
# Using reactiveVal() to store state.
# Separating input changes from output updates.

# reactiveVal() creates a reactive container for a single value. You can think of it like a variable that:
# - Stores a value.
# - Automatically updates anything that depends on it when the value changes.
# It’s useful when you want to control when a value updates, rather than having it update every time an input changes.

ui <- fluidPage(
  sliderInput("bins", "Number of bins", min = 5, max = 50, value = 30),
  actionButton("updatePlot", "Update Plot"),
  plotOutput("histPlot")
)

server <- function(input, output) {
  bins <- reactiveVal(30) # needs a starting value

  observeEvent(input$updatePlot, {
    bins(input$bins)
  })

  output$histPlot <- renderPlot({
    histogram(data = NULL, x = rnorm(500), bins = bins())
  })
}

shinyApp(ui, server)
