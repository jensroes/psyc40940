library(shiny)
library(tidyverse)

d_participants <- read_csv("data/participant_reaction_times.csv",
                           show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Participant reaction times"),
  p("Each value is one participant's mean reaction time across familiarisation conditions, in milliseconds."),
  sidebarLayout(
    sidebarPanel(
      selectInput("modality", "Output group",
                  choices = c("Spoken output" = "speech",
                              "Written output" = "writing")),
      sliderInput("binwidth", "Histogram bin width (ms)",
                  min = 25, max = 300, value = 100, step = 25),
      helpText("The group selector changes both tabs. Bin width changes only the histogram.")
    ),
    mainPanel(
      textOutput("selection_note"),
      ---(
        ---("Distribution",
          p("---"),
          plotOutput("rt_plot")
        ),
        ---("Individual values",
          p("---"),
          plotOutput("values_plot")
        )
      ),
      helpText("The groups contain different participants; these plots do not establish a causal effect of output group.")
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
      labs(x = "Participant mean reaction time (ms)",
           y = "Participants")
  })
  
  output$values_plot <- renderPlot({
    ggplot(selected_data(), aes(x = "Selected group", y = mean_rt)) +
      geom_boxplot(width = 0.25, outlier.shape = NA) +
      geom_point(position = position_jitter(width = 0.08,
                                           height = 0, seed = 7),
                 alpha = 0.6) +
      labs(x = NULL, y = "Participant mean reaction time (ms)")
  })
}

shinyApp(ui, server)
