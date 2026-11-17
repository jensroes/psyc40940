library(shiny)
library(tidyverse)

d_participants <- read_csv("data/participant_reaction_times.csv",
                           show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Explore participant reaction times"),
  p("Each row is one participant's mean across familiarisation conditions, in milliseconds."),
  sidebarLayout(
    sidebarPanel(
      selectInput("modality", "Output group",
                  choices = c("Spoken output" = "speech",
                              "Written output" = "writing")),
      sliderInput("binwidth", "Histogram bin width (ms)",
                  min = 25, max = 300, value = 100, step = 25),
      helpText("Group selection affects both tabs. Bin width affects the histogram only.")
    ),
    mainPanel(
      textOutput("selection_note"),
      h4("Distribution"),
      plotOutput("rt_plot", height = "250px"),
      h4("Individual values"),
      plotOutput("values_plot", height = "250px"),
      helpText("Different participant groups; the plots alone do not show a causal effect.")
    )
  )
)

server <- function(input, output) {
  selected_data <- reactive({
    filter(d_participants, modality == input$modality)
  })

  output$selection_note <- renderText({
    paste("Participants shown:", nrow(selected_data()))
  })

  output$rt_plot <- renderPlot({
    ggplot(selected_data(), aes(x = mean_rt)) +
      geom_histogram(binwidth = input$binwidth) +
      facet_wrap(~modality) +
      labs(x = "Participant mean reaction time (ms)", y = "Participants")
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
