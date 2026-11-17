library(shiny)
library(tidyverse)
library(plotly)

d_trials <- read_csv("data/trial_reaction_times.csv",
                           show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Explore participant reaction times"),
  p("Each point is one naming trial. Compare response duration with reaction time, both in milliseconds; colour identifies speech or writing. There are repeated trials from each participant, not thousands of independent participants."),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("groups", "Output groups",
                         choices = c("Spoken output" = "speech",
                                     "Written output" = "writing"),
                         selected = c("speech", "writing")),
      sliderInput("vocab_range", "Keep vocabulary scores within",
                  min = 0.80, max = 1.00, value = c(0.80, 1.00), step = 0.01),
      helpText("Groups and vocabulary-score range select participants and their trials for both tabs. Drag to zoom into the main cluster; double-click to reset. Zoom changes the visible region, not the selected participant or trial count.")
    ),
    mainPanel(
      textOutput("selection_note"),
      tabsetPanel(
        tabPanel("Trial timings",
          p("The slowest responses stretch the axes. Zoom into the main cluster to inspect nearby trials, then hover to identify the stimulus and timings. Reset to see the full range again. Legend clicks change group visibility without changing the shared selection."),
          ---("rt_plot")
        ),
        tabPanel("Trial distributions",
          p("Compare the distribution of trial reaction times within each selected group. These summaries pool repeated observations from participants."),
          plotOutput("values_plot")
        )
      ),
      helpText("Different participant groups; the plots alone do not show a causal effect.")
    )
  )
)

server <- function(input, output) {
  selected_data <- reactive({
    req(input$vocab_range)
    selected <- filter(
      d_trials,
      modality %in% input$groups,
      vocabulary_score >= input$vocab_range[1],
      vocabulary_score <= input$vocab_range[2]
    )
    validate(need(
      nrow(selected) > 0,
      "No participants match. Select a group or widen the vocabulary-score range."
    ))
    selected
  })

  output$selection_note <- renderText({
    paste("Participants:", n_distinct(selected_data()$ppt_id),
          "| Trials:", nrow(selected_data()))
  })

  output$rt_plot <- ---({
    p <- ggplot(selected_data(),
                aes(x = dur, y = rt, colour = modality, group = modality,
                    text = paste("Stimulus:", stimulus,
                                 "<br>Participant:", ppt_id,
                                 "<br>Trial:", trial_id,
                                 "<br>Group:", modality,
                                 "<br>Duration (ms):", round(dur, 1),
                                 "<br>Reaction time (ms):", round(rt, 1)))) +
      geom_point(alpha = 0.2) +
      labs(x = "Response duration (ms)",
           y = "Reaction time (ms)", colour = "Output group")
    ---(p, tooltip = "text")
  })

  output$values_plot <- renderPlot({
    ggplot(selected_data(), aes(x = modality, y = rt)) +
      geom_boxplot() +
      labs(x = "Output group", y = "Trial reaction time (ms)")
  })
}

shinyApp(ui, server)
