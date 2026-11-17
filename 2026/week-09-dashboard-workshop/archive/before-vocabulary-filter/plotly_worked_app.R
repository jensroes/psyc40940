library(shiny)
library(tidyverse)
library(plotly)

d_participants <- read_csv("data/participant_reaction_times.csv",
                           show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Explore participant reaction times"),
  p("Each row is one participant's mean across familiarisation conditions, in milliseconds."),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("groups", "Output groups",
                         choices = c("Spoken output" = "speech",
                                     "Written output" = "writing"),
                         selected = c("speech", "writing")),
      sliderInput("rt_range", "Keep participant means within (ms)",
                  min = 700, max = 2400, value = c(700, 2400), step = 50),
      sliderInput("binwidth", "Histogram bin width (ms)",
                  min = 25, max = 300, value = 100, step = 25),
      helpText("Groups and reaction-time range affect both tabs. Bin width affects the histogram only.")
    ),
    mainPanel(
      textOutput("selection_note"),
      tabsetPanel(
        tabPanel("Distribution",
          p("Compare distributions; the width slider changes these histograms."),
          plotlyOutput("rt_plot")
        ),
        tabPanel("Individual values",
          p("Compare group summaries with the individual participant means."),
          plotOutput("values_plot")
        )
      ),
      helpText("Different participant groups; the plots alone do not show a causal effect.")
    )
  )
)

server <- function(input, output) {
  selected_data <- reactive({
    req(input$rt_range)
    selected <- filter(
      d_participants,
      modality %in% input$groups,
      mean_rt >= input$rt_range[1],
      mean_rt <= input$rt_range[2]
    )
    validate(need(
      nrow(selected) > 0,
      "No participants match. Select a group or widen the reaction-time range."
    ))
    selected
  })

  output$selection_note <- renderText({
    paste("Participants shown:", nrow(selected_data()))
  })

  output$rt_plot <- renderPlotly({
    p <- ggplot(selected_data(), aes(x = mean_rt)) +
      geom_histogram(binwidth = input$binwidth) +
      facet_wrap(~modality) +
      labs(x = "Participant mean reaction time (ms)", y = "Participants")
    ggplotly(p)
  })

  output$values_plot <- renderPlot({
    ggplot(selected_data(), aes(x = modality, y = mean_rt)) +
      geom_boxplot(outlier.shape = NA) +
      geom_point(position = position_jitter(width = 0.08,
                                           height = 0, seed = 7),
                 alpha = 0.6) +
      labs(x = "Output group", y = "Participant mean reaction time (ms)")
  })
}

shinyApp(ui, server)
