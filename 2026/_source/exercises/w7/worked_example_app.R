# Layout and observers: worked example
library(shiny)
library(tidyverse)

d_spellname <- read_csv("../../data/spellname.csv", show_col_types = FALSE) |>
  summarise(
    rt = mean(rt, na.rm = TRUE),
    dur = mean(dur, na.rm = TRUE),
    .by = c(ppt_id, name_familiarised, ppt_vocab, modality)
  )

modality_choices <- sort(unique(d_spellname$modality))

ui <- fluidPage(
  titlePanel("Reaction time dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("modality", "Modality", choices = modality_choices),
      actionButton("update", "Update outputs"),
      actionButton("reset", "Reset")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("rt_plot")),
        tabPanel("Summary", tableOutput("summary"))
      )
    )
  )
)

server <- function(input, output, session) {
  selected_modality <- eventReactive(input$update, {
    input$modality
  }, ignoreNULL = FALSE)

  filtered_data <- reactive({
    d_spellname |>
      filter(modality == selected_modality())
  })

  observeEvent(input$reset, {
    updateSelectInput(session, "modality", selected = modality_choices[1])
  })

  output$rt_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = name_familiarised, y = rt)) +
      geom_boxplot() +
      labs(x = "Name familiarised", y = "Mean reaction time") +
      theme_minimal()
  })

  output$summary <- renderTable({
    filtered_data() |>
      summarise(mean_rt = round(mean(rt, na.rm = TRUE), 1), rows = n(), .by = name_familiarised)
  })
}

shinyApp(ui, server)
