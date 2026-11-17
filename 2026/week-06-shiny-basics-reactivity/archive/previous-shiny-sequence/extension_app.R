# Optional extension: add a second filter
# Try this only after the starter app works.

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
  titlePanel("Reaction times"),
  selectInput("modality", "Modality", choices = sort(unique(d_spellname$modality))),
  selectInput("familiarised", "Name familiarised", choices = sort(unique(d_spellname$name_familiarised))),
  plotOutput("rt_plot"),
  tableOutput("summary")
)

server <- function(input, output, session) {
  # Filter by both inputs.
  filtered_data <- reactive({
    filter(
      d_spellname,
      modality == input$modality,
      name_familiarised == input$familiarised
    )
  })

  output$rt_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = ppt_vocab, y = rt)) +
      geom_point(alpha = 0.7) +
      geom_smooth(method = "lm", se = FALSE) +
      labs(x = "Participant vocabulary", y = "Mean reaction time") +
      theme_minimal()
  })

  output$summary <- renderTable({
    summarise(filtered_data(), mean_rt = round(mean(rt, na.rm = TRUE), 1), rows = n())
  })
}

shinyApp(ui, server)
