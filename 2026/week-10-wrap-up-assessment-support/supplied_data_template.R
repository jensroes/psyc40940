library(shiny)
library(tidyverse)

d_workshop <- read_csv("data/participant_rates.csv", show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Explore average and individual patterns"),
  p("One row summarises four trials for one learner, testing occasion, sentence condition and phase. Passive use is not a correctness score."),
  sidebarLayout(
    sidebarPanel(
      # --- condition control
      # --- phase control
      helpText("Choose sentence conditions and one phase. Both plots use the same selected observations.")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Average pattern",
          p("---"),
          plotOutput("overview_plot")
        ),
        tabPanel("Individual patterns",
          p("---"),
          plotOutput("participant_plot")
        )
      ),
      helpText("Repeated observations come from the same learners. Descriptive plots do not isolate an intervention effect. Source: van Lieburg et al. (2023), DOI: 10.1007/s41809-023-00131-5; see data/README.md.")
    )
  )
)

server <- function(input, output) {
  selected_data <- reactive({
    NULL # --- shared preparation
  })

  output$overview_plot <- renderPlot({
    NULL # --- average plot
  })

  output$participant_plot <- renderPlot({
    NULL # --- individual plot
  })
}

shinyApp(ui, server)
