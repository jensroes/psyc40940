# Dynamic UI: worked example
library(shiny)
library(tidyverse)

d_spellname <- read_csv("../../data/spellname.csv", show_col_types = FALSE) |>
  summarise(
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
  observeEvent(input$modality, {
    choices <- d_spellname |>
      filter(modality == input$modality) |>
      pull(ppt_id) |>
      unique() |>
      sort()

    updateSelectInput(session, "participant", choices = choices, selected = choices[1])
  }, ignoreInit = FALSE)

  output$filter_control <- renderUI({
    req(input$filter_variable)

    values <- d_spellname |>
      pull(input$filter_variable) |>
      unique() |>
      sort()

    selectInput("filter_value", "Value", choices = values)
  })

  filtered_data <- reactive({
    req(input$filter_value)

    d_spellname |>
      filter(
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
