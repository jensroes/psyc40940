# Load packages
library(shiny)
library(tidyverse)
library(ggthemes)

# Load data and create nicer labels for "familiarisation"
spellname <- read_csv("data/spellname.csv") %>%
  mutate(across(name_familiarised, ~case_when(. ~ "familiarised",
                                              !. ~ "not familiarised")))

# Setup user interface
ui <- fluidPage(
  selectInput("var", "Variables", choices = names(spellname)),
  uiOutput("out")
)

# Setup server function
server <- function(input, output) {

  data <- reactive({
    spellname[[input$var]]
  })

  output$out <- renderUI({
    data <- data()[!is.na(data())]
    if (is.numeric(data)) {
      rng <- range(data)
      sliderInput("dynamic", input$var,
                  value = mean(data),
                  min = floor(rng[1]),
                  max = ceiling(rng[2]))
    } else {
      selectInput("dynamic", input$var, choice = unique(data))
    }
  })
}

# Run app
shinyApp(ui, server)

