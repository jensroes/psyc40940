# Dynamic UI: starter app
# This file is for students to edit during the Week 8 exercise.

library(shiny)
library(tidyverse)

# Load and reduce the data.
d_spellname <- read_csv("data/spellname.csv", show_col_types = FALSE)
d_spellname <- summarise(
  d_spellname,
  rt = mean(rt, na.rm = TRUE),
  dur = mean(dur, na.rm = TRUE),
  .by = c(ppt_id, name_familiarised, ppt_vocab, modality)
)

ui <- fluidPage(
  titlePanel("Dynamic filters"),
  sidebarLayout(
    sidebarPanel(
      selectInput("modality", "Modality", choices = sort(unique(d_spellname$modality))),
      selectInput("participant", "Participant", choices = sort(unique(d_spellname$ppt_id))),
      selectInput("filter_variable", "Extra filter", choices = c("name_familiarised", "ppt_vocab"))

      # Task: add uiOutput("filter_control") here.
    ),
    mainPanel(
      plotOutput("rt_plot")
    )
  )
)

server <- function(input, output, session) {
  # Task 1: update participant choices when modality changes.
  # Task 2: create output$filter_control with renderUI().

  filtered_data <- reactive({
    filter(d_spellname, modality == input$modality, ppt_id == input$participant)
  })

  output$rt_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = name_familiarised, y = rt)) +
      geom_col() +
      labs(x = "Name familiarised", y = "Mean reaction time") +
      theme_minimal()
  })
}

shinyApp(ui, server)
