# Dashboard workshop: starter app
# This file is for students to edit during the Week 9 workshop.

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

ui <- navbarPage(
  "Behavioural data dashboard",
  tabPanel(
    "Overview",
    sidebarLayout(
      sidebarPanel(
        selectInput("modality", "Modality", choices = sort(unique(d_spellname$modality)))
      ),
      mainPanel(
        plotOutput("overview_plot")
      )
    )
  )

  # Task: add a second tab for exploration and a third tab for a summary table.
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    filter(d_spellname, modality == input$modality)
  })

  output$overview_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = name_familiarised, y = rt)) +
      geom_boxplot() +
      labs(x = "Name familiarised", y = "Mean reaction time") +
      theme_minimal()
  })

  # Task: add one more plot and one summary table.
}

shinyApp(ui, server)
