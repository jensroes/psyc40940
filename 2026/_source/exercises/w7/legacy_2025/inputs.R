library(shiny)

# Just a few animals
animals <- c("dog", "cat", "mouse", "bird", "other")

ui <- fluidPage(
  numericInput("num", "Number one", value = 0, min = 0, max = 100),
  sliderInput("num2", "Number two", value = 50, min = 0, max = 100),
  sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100),
  selectInput("state", "What's your favourite state?", animals),
  radioButtons("animal", "What's your favourite animal?", animals), # one selection only
  checkboxGroupInput("animal", "What animals do you like?", animals), # multiple selections allowed
)

server <- function(input, output) {

}

shinyApp(ui, server)
