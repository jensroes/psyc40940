library(shiny)
library(tidyverse)

d_participants <- read_csv("data/participant_reaction_times.csv",
                           show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Reaction times by output group"),
  selectInput("modality", "Output group",
              choices = c("Spoken output" = "speech",
                          "Written output" = "writing")),
  plotOutput("---")
)

server <- function(input, output) {
  output$rt_plot <- renderPlot({
    selected_data <- filter(d_participants, modality == input$---)
    ggplot(---, aes(x = mean_rt)) +
      geom_histogram(binwidth = 100) +
      labs(x = "Participant mean reaction time (ms)",
           y = "Number of participants")
  })
}

shinyApp(ui, server)
