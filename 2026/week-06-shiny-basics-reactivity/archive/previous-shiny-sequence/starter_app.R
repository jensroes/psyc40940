# Shiny basics and reactivity: starter app
# This file is for students to edit during the Week 6 exercise.

library(shiny)
library(tidyverse)

# Load the data once when the app starts.
d_spellname <- read_csv("data/spellname.csv", show_col_types = FALSE)

# Create one row per participant/condition so the app works with a smaller dataset.
d_spellname <- summarise(
  d_spellname,
  rt = mean(rt, na.rm = TRUE),
  dur = mean(dur, na.rm = TRUE),
  .by = c(ppt_id, name_familiarised, ppt_vocab, modality)
)

ui <- fluidPage(
  titlePanel("Reaction times"),
  selectInput(
    inputId = "modality",
    label = "Modality",
    choices = sort(unique(d_spellname$modality))
  ),
  plotOutput("rt_plot")

  # Task: add tableOutput("summary") below the plot.
)

server <- function(input, output, session) {
  # Task: move this filtering logic into a reactive expression called filtered_data.
  output$rt_plot <- renderPlot({
    filtered <- filter(d_spellname, modality == input$modality)

    ggplot(filtered, aes(x = name_familiarised, y = rt)) +
      geom_boxplot() +
      labs(x = "Name familiarised", y = "Mean reaction time") +
      theme_minimal()
  })

  # Task: add a renderTable output that reports mean rt and number of rows.
}

shinyApp(ui, server)
