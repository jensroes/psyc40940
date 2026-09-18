# Load packages
library(shiny)
library(tidyverse)
library(psyntur)

# Set sample size
n <- 1000

# Prep tabsetPanel for user interface
parameter_tabs <- tabsetPanel(
  id = "params",
  type = "hidden",
  tabPanel("normal",
           numericInput("mean", "Mean", value = 1),
           numericInput("sd", "Standard deviation", min = 0, value = 1)
  ),
  tabPanel("exponential",
           numericInput("rate", "Rate", value = 1, min = 0),
  )
)

# Setup user interface
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("dist", "Distribution",
                  choices = c("normal", "exponential")
      ),
      parameter_tabs # this is defined above
    ),
    mainPanel(
      plotOutput("hist")
    )
  )
)

# Server function for distributions
server <- function(input, output) {

  observeEvent(input$dist, {
    updateTabsetPanel(inputId = "params", selected = input$dist)
  })

  sample <- reactive({
    switch(input$dist,
           normal = rnorm(n, input$mean, input$sd),
           exponential = rexp(n, input$rate)
    )
  })

  output$hist <- renderPlot({
    histogram(data = NULL, x = sample())
    })
}

# Run app
shinyApp(ui, server)
