# Optional extension: choose the plot variable dynamically

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
      selectInput("filter_variable", "Filter variable", choices = c("name_familiarised", "ppt_vocab")),
      uiOutput("filter_control"),
      selectInput("y_var", "Outcome", choices = c("rt", "dur"))
    ),
    mainPanel(plotOutput("plot"))
  )
)

server <- function(input, output, session) {
  output$filter_control <- renderUI({
    values <- d_spellname[[input$filter_variable]]
    values <- sort(unique(values))

    selectInput("filter_value", "Value", choices = values)
  })

  filtered_data <- reactive({
    req(input$filter_value)

    filter(
      d_spellname,
      modality == input$modality,
      .data[[input$filter_variable]] == input$filter_value
    )
  })

  output$plot <- renderPlot({
    ggplot(filtered_data(), aes(x = ppt_vocab, y = .data[[input$y_var]])) +
      geom_point(alpha = 0.7) +
      labs(x = "Participant vocabulary", y = input$y_var) +
      theme_minimal()
  })
}

shinyApp(ui, server)
