library(shiny)
library(psyntur)

ui <- fluidPage(
  sliderInput("bins", "Number of bins", min = 5, max = 50, value = 30),
  actionButton("updatePlot", "Update Plot"),
  plotOutput("histPlot")
)

# Conditional Plot Update with eventReactive()

server <- function(input, output) {
  bins <- eventReactive(input$updatePlot, {
    input$bins
  })

  output$histPlot <- renderPlot({
    histogram(data = NULL, x = rnorm(500), bins = bins())
  })
}

shinyApp(ui, server)

# What’s happening here?
#- eventReactive(input$updatePlot, { input$bins }) creates a reactive expression that only updates when the button is clicked.
#- bins() holds the value of input$bins at the time of the button click.
#- The plot uses bins() to determine how many bins to show.
