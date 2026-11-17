library(shiny)
library(tidyverse)
library(plotly)

d_workshop <- read_csv("data/participant_rates.csv", show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Explore average and individual patterns"),
  p("One row summarises four trials for one learner, testing occasion, sentence condition and phase. Passive use is not a correctness score."),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("prime_condition", "Sentence conditions",
                   choices = c("Baseline", "Active sentence", "Passive sentence"),
                   selected = c("Baseline", "Active sentence", "Passive sentence")),
      selectInput("phase", "Phase to display",
            choices = c("Before", "After"), selected = "Before"),
      helpText("Choose sentence conditions and one phase. Both plots use the same selected observations.")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Average pattern",
          p("Points show the mean number of full passive responses out of four trials at each testing occasion for the selected phase. Lines compare the sentence conditions."),
          plotlyOutput("overview_plot")
        ),
        tabPanel("Individual patterns",
          p("Each line follows one learner in one sentence condition. Compare individual variation with the mean pattern in the other tab."),
          plotlyOutput("participant_plot")
        )
      ),
      helpText("Repeated observations come from the same learners. Descriptive plots do not isolate an intervention effect. Source: van Lieburg et al. (2023), DOI: 10.1007/s41809-023-00131-5; see data/README.md.")
    )
  )
)

server <- function(input, output) {
  selected_data <- reactive({
    selected <- filter(
      d_workshop,
      prime_condition %in% input$prime_condition,
      phase == input$phase
    )
    validate(need(nrow(selected) > 0,
                  "No observations match. Select a sentence condition."))
    selected
  })

  output$overview_plot <- renderPlotly({
    p <- ggplot(selected_data(),
           aes(x = study_session, y = n_passive,
               colour = prime_condition, group = prime_condition)) +
      stat_summary(fun = mean, geom = "line") +
      stat_summary(fun = mean, geom = "point") +
      scale_x_continuous(breaks = 1:5) +
      scale_y_continuous(breaks = 0:4) +
      coord_cartesian(ylim = c(0, 4)) +
      labs(x = "Testing occasion", y = "Mean full passive responses (out of 4)",
           colour = "Sentence condition")
    ggplotly(p)
  })

  output$participant_plot <- renderPlotly({
    p <- ggplot(selected_data(),
           aes(x = study_session, y = n_passive,
               colour = prime_condition,
               group = interaction(participant, prime_condition))) +
      geom_line(alpha = 0.35) +
      geom_point(alpha = 0.35) +
      scale_x_continuous(breaks = 1:5) +
      scale_y_continuous(breaks = 0:4) +
      coord_cartesian(ylim = c(0, 4)) +
      labs(x = "Testing occasion", y = "Full passive responses (out of 4)",
           colour = "Sentence condition")
    ggplotly(p)
  })
}

shinyApp(ui, server)
