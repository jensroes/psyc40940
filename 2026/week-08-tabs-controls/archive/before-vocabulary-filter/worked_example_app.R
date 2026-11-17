library(shiny)
library(tidyverse)

d_participants <- read_csv("data/participant_reaction_times.csv",
                           show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Participant reaction times"),
  p("Each value is one participant's mean reaction time across familiarisation conditions, in milliseconds."),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("groups", "Output groups",
                         choices = c("Spoken output" = "speech",
                                     "Written output" = "writing"),
                         selected = c("speech", "writing")),
      sliderInput("rt_range", "Keep participant means within (ms)",
                  min = 700, max = 2400,
                  value = c(700, 2400), step = 50),
      sliderInput("binwidth", "Histogram bin width (ms)",
                  min = 25, max = 300, value = 100, step = 25),
      helpText("Groups and reaction-time range change both tabs. Bin width changes only the histogram.")
    ),
    mainPanel(
      textOutput("selection_note"),
      tabsetPanel(
        tabPanel("Distribution",
          p("The histogram pools the selected groups. Use the other tab to compare groups separately."),
          plotOutput("rt_plot")
        ),
        tabPanel("Individual values",
          p("Compare the median, spread and individual participant means for each selected group."),
          plotOutput("values_plot")
        )
      ),
      helpText("The groups contain different participants; these plots do not establish a causal effect of output group.")
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
  
  output$rt_plot <- renderPlot({
    ggplot(selected_data(), aes(x = mean_rt)) +
      geom_histogram(binwidth = input$binwidth) +
      # facet_wrap(~modality) +
      labs(x = "Participant mean reaction time (ms)",
           y = "Participants")
  })
  
  output$values_plot <- renderPlot({
    ggplot(selected_data(), aes(x = modality, y = mean_rt)) +
      geom_boxplot(width = 0.25, outlier.shape = NA) +
      geom_point(position = position_jitter(width = 0.08,
                                           height = 0, seed = 7),
                 alpha = 0.6) +
      labs(x = "Output group", y = "Participant mean reaction time (ms)")
  })
}

shinyApp(ui, server)
