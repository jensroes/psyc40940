library(shiny)
library(tidyverse)

d_participants <- read_csv("data/participant_reaction_times.csv",
                           show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Reaction times by output group"),
  p("Participant mean reaction times in a name-production task, in milliseconds."),
  selectInput("modality", "Output group",
              choices = c("Spoken output" = "speech",
                          "Written output" = "writing")),
  sliderInput("binwidth", "Bin width (ms)",
              min = 25, max = 300, value = 100, step = 25),
  plotOutput("rt_plot"),
  helpText("The selector changes which participants are shown; bin width changes how the same values are grouped."),
  helpText("Means are across familiarisation conditions. The groups contain different participants; this is not a causal comparison.")
)

server <- function(input, output) {
  output$rt_plot <- renderPlot({
    selected_data <- filter(d_participants, modality == input$modality)
    ggplot(selected_data, aes(x = mean_rt)) +
      geom_histogram(binwidth = input$binwidth) +
      labs(x = "Participant mean reaction time (ms)",
           y = "Number of participants")
  })
}

shinyApp(ui, server)
