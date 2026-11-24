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
      helpText("The average plot currently shows all sentence conditions in the Before phase.")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Average pattern",
          p("Points show the mean number of full passive responses out of four trials at each testing occasion for the selected phase. Lines compare the sentence conditions."),
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
  # --- shared reactive preparation

  output$overview_plot <- renderPlot({
    ggplot(filter(d_workshop, phase == "Before"),
           aes(x = study_session, y = n_passive,
               colour = prime_condition, group = prime_condition)) +
      stat_summary(fun = mean, geom = "line") +
      stat_summary(fun = mean, geom = "point") +
      scale_x_continuous(breaks = 1:5) +
      scale_y_continuous(breaks = 0:4) +
      coord_cartesian(ylim = c(0, 4)) +
      labs(x = "Testing occasion", y = "Mean full passive responses (out of 4)",
           colour = "Sentence condition")
  })

  output$participant_plot <- renderPlot({
    NULL # --- individual plot
  })
}

shinyApp(ui, server)
