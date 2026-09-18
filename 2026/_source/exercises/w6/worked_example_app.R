# Shiny basics and reactivity: worked example
library(shiny)
library(tidyverse)

d_spellname <- read_csv("../../data/spellname.csv", show_col_types = FALSE) |>
  summarise(
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
  filtered_data <- reactive({
    d_spellname |>
      filter(modality == input$modality)
  })

  output$rt_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = name_familiarised, y = rt)) +
      geom_boxplot() +
      labs(x = "Name familiarised", y = "Mean reaction time") +
      theme_minimal()
  })

  output$summary <- renderTable({
    filtered_data() |>
      summarise(
        mean_rt = round(mean(rt, na.rm = TRUE), 1),
        mean_duration = round(mean(dur, na.rm = TRUE), 1),
        rows = n()
      )
  })
}

shinyApp(ui, server)
