library(shiny)

# Define UI for application
ui <- fluidPage(
  titlePanel("Histogram of Normally Distributed Data"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sample_size", "Sample Size:", min = 10, max = 1000, value = 100),
      sliderInput("mean", "Mean:", min = -10, max = 10, value = 0),
      sliderInput("sd", "Standard Deviation:", min = 1, max = 10, value = 1)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$distPlot <- renderPlot({
    data <- rnorm(input$sample_size, mean = input$mean, sd = input$sd)
    hist(data, main = "Histogram", xlab = "Value", col = "skyblue", border = "white")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)