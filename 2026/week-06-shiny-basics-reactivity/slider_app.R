library(shiny)
library(tidyverse)

d_participants <- read_csv("data/participant_reaction_times.csv",
                           show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Reaction times by output group"),
  p("---"),
  selectInput("modality", "Output group",
              choices = c("Spoken output" = "speech",
                          "Written output" = "writing")),
  sliderInput("binwidth", "---",
              min = 25, max = 300, value = ---, step = 25),
  helpText("---"),
  plotOutput("rt_plot")
)

server <- function(input, output) {
  output$rt_plot <- renderPlot({
    selected_data <- filter(d_participants, modality == input$modality)
    ggplot(selected_data, aes(x = mean_rt)) +
      geom_histogram(binwidth = input$---) +
      labs(x = "Participant mean reaction time (ms)",
           y = "Number of participants")
  })
}

shinyApp(ui, server)
