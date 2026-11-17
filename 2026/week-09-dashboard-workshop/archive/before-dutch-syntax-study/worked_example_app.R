library(shiny)
library(tidyverse)

d_workshop <- read_csv("data/participant_behaviour.csv",
                       show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Reaction time and response duration"),
  p("Each point represents a participant mean across familiarisation conditions; both time measures are in milliseconds."),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("groups", "Output groups",
                         choices = c("Spoken output" = "speech",
                                     "Written output" = "writing"),
                         selected = c("speech", "writing")),
      helpText("The selected groups appear in both views. Compare patterns within groups before interpreting the pooled relationship.")
    ),
    mainPanel(
      textOutput("selection_note"),
      tabsetPanel(
        tabPanel("Relationship", plotOutput("relationship_plot")),
        tabPanel("Group differences", plotOutput("group_plot"))
      ),
      helpText("These are different participant groups. Associations and group differences do not establish causation.")
    )
  )
)

server <- function(input, output) {
  selected_data <- reactive({
    selected <- filter(d_workshop, modality %in% input$groups)
    validate(need(nrow(selected) > 0, "Select at least one output group."))
    selected
  })

  output$selection_note <- renderText({
    paste("Participants shown:", nrow(selected_data()))
  })

  output$relationship_plot <- renderPlot({
    ggplot(selected_data(),
           aes(x = mean_duration, y = mean_rt, colour = modality)) +
      geom_point() +
      labs(x = "Participant mean response duration (ms)",
           y = "Participant mean reaction time (ms)",
           colour = "Output group")
  })

  output$group_plot <- renderPlot({
    ggplot(selected_data(), aes(x = modality, y = mean_rt)) +
      geom_boxplot(outlier.shape = NA) +
      geom_point(position = position_jitter(width = 0.08,
                                           height = 0, seed = 7)) +
      labs(x = "Output group", y = "Participant mean reaction time (ms)")
  })
}

shinyApp(ui, server)
