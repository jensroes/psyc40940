# Optional extension: switch tabs after updating outputs

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
        id = "view",
        tabPanel("Plot", value = "plot", plotOutput("rt_plot")),
        tabPanel("Summary", value = "summary", tableOutput("summary"))
      )
    )
  )
)

server <- function(input, output, session) {
  selected_modality <- eventReactive(input$update, input$modality, ignoreNULL = FALSE)

  filtered_data <- reactive({
    filter(d_spellname, modality == selected_modality())
  })

  observeEvent(input$update, {
    updateTabsetPanel(session, "view", selected = "plot")
  })

  observeEvent(input$reset, {
    updateSelectInput(session, "modality", selected = modality_choices[1])
  })

  output$rt_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = ppt_vocab, y = rt, colour = name_familiarised)) +
      geom_point(alpha = 0.7) +
      labs(x = "Participant vocabulary", y = "Mean reaction time", colour = "Name familiarised") +
      theme_minimal()
  })

  output$summary <- renderTable({
    summarise(
      filtered_data(),
      mean_rt = round(mean(rt, na.rm = TRUE), 1),
      rows = n(),
      .by = name_familiarised
    )
  })
}

shinyApp(ui, server)
