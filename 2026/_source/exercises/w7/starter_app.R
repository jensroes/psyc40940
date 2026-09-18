# Layout and observers: starter app
library(shiny)
library(tidyverse)

d_spellname <- read_csv("../../data/spellname.csv", show_col_types = FALSE) |>
  summarise(
    rt = mean(rt, na.rm = TRUE),
    dur = mean(dur, na.rm = TRUE),
    .by = c(ppt_id, name_familiarised, ppt_vocab, modality)
  )

ui <- fluidPage(
  titlePanel("Reaction time dashboard"),
  selectInput("modality", "Modality", choices = sort(unique(d_spellname$modality))),
  actionButton("update", "Update plot"),
  actionButton("reset", "Reset"),
  plotOutput("rt_plot")

  # Task 1: move the controls into sidebarPanel() and the plot into mainPanel().
  # Task 2: add a second tab containing tableOutput("summary").
)

server <- function(input, output, session) {
  selected_modality <- reactive({
    input$modality
  })

  filtered_data <- reactive({
    d_spellname |>
      filter(modality == selected_modality())
  })

  output$rt_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = name_familiarised, y = rt)) +
      geom_boxplot() +
      labs(x = "Name familiarised", y = "Mean reaction time") +
      theme_minimal()
  })

  # Task 3: use eventReactive() so the selected modality changes only after the update button.
  # Task 4: use observeEvent() and updateSelectInput() to reset the modality input.
}

shinyApp(ui, server)
