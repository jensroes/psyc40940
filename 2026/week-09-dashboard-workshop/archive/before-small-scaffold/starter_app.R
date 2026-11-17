library(shiny)
library(tidyverse)

d_workshop <- read_csv("data/---",
                       show_col_types = FALSE)
# Keep the within-session phases in their temporal order.
d_workshop$phase <- factor(d_workshop$phase,
                           levels = c("Before", "After"))

ui <- fluidPage(
  titlePanel("How does passive sentence use change?"),
  p("---"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("prime_condition", "Sentence prompt conditions",
                  choices = c("Baseline", "Active sentence", "Passive sentence"),
                  selected = c("Baseline", "Active sentence", "Passive sentence")),
      checkboxGroupInput("phases", "Phase within each testing occasion",
                         choices = c("Before intervention" = "Before",
                                     "After intervention" = "After"),
                         selected = c("Before", "After")),
      sliderInput("lextale_range", "Learner vocabulary score (LexTALE)",
                  min = 0, max = 1, value = c(0, 1), step = 0.0125),
      helpText("LexTALE was measured once, at testing occasion 4. This range selects learners; their observations from all five occasions remain eligible."),
      radioButtons("average_layout", "Average view: which comparison?",
                   choices = c("Sentence colours; phase panels" = "sentences",
                               "Phase colours; sentence panels" = "phases"),
                   selected = "sentences"),
      helpText("---")
    ),
    mainPanel(
      textOutput("selection_note"),
      tabsetPanel(
        tabPanel("Average pattern",
          p("Points show mean learner percentages; bars show mean plus or minus one standard error across learners. Sentence colours within phase panels favour sentence comparisons; phase colours within sentence panels favour before/after comparisons. Bars are not confidence intervals or a test of the paired phase difference. An SE bar is omitted where fewer than two learners contribute; points and individual observations remain visible."),
          plotOutput("overview_plot", height = "360px")
        ),
        tabPanel("Individual patterns",
          p("---"),
          plotOutput("participant_plot", height = "520px")
        )
      ),
      helpText("Percentages use all four recorded target trials in each row, including other responses or no response. Each learner appears in several rows. Descriptive changes do not isolate an intervention effect from practice or other changes."),
      helpText("Source: van Lieburg et al. (2023), longitudinal experiment. DOI: 10.1007/s41809-023-00131-5. Prepared teaching extract; see data/README.md.")
    )
  )
)

server <- function(input, output) {
  selected_data <- reactive({
    req(input$lextale_range)
    selected <- filter(
      d_workshop,
      prime_condition %in% input$prime_condition,
      phase %in% input$phases,
      vocabulary_score >= input$lextale_range[1],
      vocabulary_score <= input$lextale_range[2]
    )
    validate(need(
      nrow(selected) > 0,
      "No summaries match. Select a sentence condition and select a phase, or widen the LexTALE range."
    ))
    selected
  })

  output$selection_note <- renderText({
    paste("Learners:", n_distinct(selected_data()$participant),
          "| Summary rows:", nrow(selected_data()))
  })

  output$overview_plot <- renderPlot({
    req(input$average_layout)
    p <- ggplot(selected_data(),
                aes(x = ---, y = ---))
    if (input$average_layout == "sentences") {
      p <- p +
        aes(colour = ---, group = prime_condition) +
        facet_wrap(~phase, nrow = 1) +
        scale_colour_manual(values = c("Baseline" = "#009E73",
                                      "Active sentence" = "#0072B2",
                                      "Passive sentence" = "#D55E00")) +
        labs(colour = "Sentence condition")
    } else {
      p <- p +
        aes(colour = phase, group = phase) +
        facet_wrap(~prime_condition, nrow = 1) +
        scale_colour_manual(values = c("Before" = "#0072B2",
                                        "After" = "#D55E00")) +
        labs(colour = "Phase")
    }
    p <- p +
      stat_summary(fun = mean, geom = "line") +
      stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.12, na.rm = TRUE) +
      stat_summary(fun = mean, geom = "point") +
      scale_x_continuous(breaks = 1:5, limits = c(1, 5)) +
      scale_y_continuous(breaks = seq(0, 100, 25)) +
      coord_cartesian(ylim = c(0, 100)) +
      labs(x = "---", y = "---")
    p
  })

  output$participant_plot <- renderPlot({
    # Option A: lines connect each learner's observed sessions.
    ggplot(selected_data(),
           aes(x = study_session, y = passive_percent,
               colour = prime_condition,
               group = interaction(participant, prime_condition))) +
      geom_line(alpha = 0.45) +
      geom_point(alpha = 0.45) +
      facet_wrap(~phase, nrow = 1) +
      scale_colour_manual(values = c("Baseline" = "#009E73",
                                      "Active sentence" = "#0072B2",
                                      "Passive sentence" = "#D55E00")) +
      scale_x_continuous(breaks = 1:5, limits = c(1, 5)) +
      scale_y_continuous(limits = c(0, 100)) +
      labs(x = "Testing occasion",
           y = "Passive responses (% of recorded target trials)",
           colour = "Sentence condition")
    # Option B: tiles give each learner a row; colour shows passive percentage.
    # ggplot(selected_data(),
    #        aes(x = study_session, y = participant, fill = passive_percent)) +
    #   geom_tile(colour = "white") +
    #   facet_grid(phase ~ prime_condition) +
    #   scale_x_continuous(breaks = 1:5, limits = c(0.5, 5.5)) +
    #   scale_fill_viridis_c(limits = c(0, 100)) +
    #   labs(x = "Testing occasion", y = "Learner", fill = "Passive (%)")

  })
}

shinyApp(ui, server)
