# Load packages
library(shiny)
library(tidyverse)

# set theme
theme_set(theme_classic())

# Prep tabsetPanel for user interface
parameter_tabs <- tabsetPanel(
  id = "params",
  type = "hidden",
  tabPanel("histogram",
           sliderInput("binwidth", "binwidth", value = .1, min = 0.01, max = 1, ) ),
  tabPanel("frerqpoly",
           sliderInput("binwidth", "binwidth", value = .1, min = 0.01, max = 1) ),
  tabPanel("density",
           sliderInput("bw", "bandwidth", value = .1, min = 0.01, max = 1),
  )
)

# Setup user interface
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("dist", "Distribution",
                  choices = c("histogram", "freqpoly", "density")
      ),
      parameter_tabs
    ),
    mainPanel(
      plotOutput("hist")
    )
  )
)

# Server function for distributions
server <- function(input, output, session) {

  observeEvent(input$dist, {
    updateTabsetPanel(inputId = "params", selected = input$dist)
  })

  geom_switch <- reactive({
    switch(input$dist,
           histogram = geom_histogram(binwidth = input$binwidth),
           freqpoly = geom_freqpoly(binwidth = input$binwidth),
           density = geom_density(bw = input$bw)
    )
  })

  output$hist <- renderPlot({
    ggplot(diamonds, aes(carat)) + geom_switch()
    })
}

# Run app
shinyApp(ui, server)
