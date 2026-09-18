# Shiny basics and reactivity: worked example
# This version shows one complete solution to the Week 6 exercise.

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
  plotOutput("rt_plot"),
  tableOutput("summary")
)

server <- function(input, output, session) {
  # reactive() stores code that should update when input$modality changes.
  filtered_data <- reactive({
    filter(d_spellname, modality == input$modality)
  })

  output$rt_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = name_familiarised, y = rt)) +
      geom_boxplot() +
      labs(x = "Name familiarised", y = "Mean reaction time") +
      theme_minimal()
  })

  output$summary <- renderTable({
    summarise(
      filtered_data(),
      mean_rt = round(mean(rt, na.rm = TRUE), 1),
      mean_duration = round(mean(dur, na.rm = TRUE), 1),
      rows = n()
    )
  })
}

shinyApp(ui, server)
