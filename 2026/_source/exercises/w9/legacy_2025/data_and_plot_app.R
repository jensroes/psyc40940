# Load packages
library(shiny)
library(tidyverse)

# Load data and create nicer labels for "familiarisation"
spellname <- read_csv("data/spellname.csv") %>%
  mutate(across(name_familiarised, ~case_when(. ~ "familiarised",
                                              !. ~ "not familiarised")))

ui <- fluidPage(
  plotOutput("myplot")
)


server <- function(input, output) {

  output$myplot <- renderPlot({
    ggplot(spellname, aes(x = dur, y = rt, colour = name_familiarised)) +
      geom_point()
  })


}

shinyApp(ui, server)
