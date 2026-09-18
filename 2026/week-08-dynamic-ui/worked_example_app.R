# Dynamic UI: worked example

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
      selectInput("filter_variable", "Extra filter", choices = c("name_familiarised", "ppt_vocab")),
      uiOutput("filter_control")
    ),
    mainPanel(
      plotOutput("rt_plot")
    )
  )
)

server <- function(input, output, session) {
  # Update participant choices whenever the selected modality changes.
  observeEvent(input$modality, {
    matching_rows <- filter(d_spellname, modality == input$modality)
    choices <- sort(unique(matching_rows$ppt_id))

    updateSelectInput(session, "participant", choices = choices, selected = choices[1])
  }, ignoreInit = FALSE)

  # Create an input control based on the selected filter variable.
  output$filter_control <- renderUI({
    req(input$filter_variable)

    values <- d_spellname[[input$filter_variable]]
    values <- sort(unique(values))

    selectInput("filter_value", "Value", choices = values)
  })

  filtered_data <- reactive({
    req(input$filter_value)

    filter(
      d_spellname,
      modality == input$modality,
      ppt_id == input$participant,
      .data[[input$filter_variable]] == input$filter_value
    )
  })

  output$rt_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = name_familiarised, y = rt)) +
      geom_col() +
      labs(x = "Name familiarised", y = "Mean reaction time") +
      theme_minimal()
  })
}

shinyApp(ui, server)
