# Dashboard workshop: worked example

library(shiny)
library(tidyverse)

# Load and reduce the data.
d_spellname <- read_csv("data/spellname.csv", show_col_types = FALSE)
d_spellname <- summarise(
  d_spellname,
  rt = mean(rt, na.rm = TRUE),
  dur = mean(dur, na.rm = TRUE),
  .by = c(ppt_id, name_familiarised, ppt_vocab, modality)
)

ui <- navbarPage(
  "Behavioural data dashboard",
  tabPanel(
    "Overview",
    sidebarLayout(
      sidebarPanel(selectInput("modality", "Modality", choices = sort(unique(d_spellname$modality)))),
      mainPanel(plotOutput("overview_plot"))
    )
  ),
  tabPanel(
    "Explore",
    sidebarLayout(
      sidebarPanel(
        selectInput("familiarised", "Name familiarised", choices = sort(unique(d_spellname$name_familiarised)))
      ),
      mainPanel(plotOutput("explore_plot"))
    )
  ),
  tabPanel("Summary", tableOutput("summary"))
)

server <- function(input, output, session) {
  modality_data <- reactive({
    filter(d_spellname, modality == input$modality)
  })

  familiarised_data <- reactive({
    filter(d_spellname, name_familiarised == input$familiarised)
  })

  output$overview_plot <- renderPlot({
    ggplot(modality_data(), aes(x = name_familiarised, y = rt)) +
      geom_boxplot() +
      labs(x = "Name familiarised", y = "Mean reaction time") +
      theme_minimal()
  })

  output$explore_plot <- renderPlot({
    ggplot(familiarised_data(), aes(x = ppt_vocab, y = rt, colour = modality)) +
      geom_point(alpha = 0.7) +
      geom_smooth(method = "lm", se = FALSE) +
      labs(x = "Participant vocabulary", y = "Mean reaction time", colour = "Modality") +
      theme_minimal()
  })

  output$summary <- renderTable({
    summarise(
      d_spellname,
      mean_rt = round(mean(rt, na.rm = TRUE), 1),
      mean_duration = round(mean(dur, na.rm = TRUE), 1),
      rows = n(),
      .by = c(modality, name_familiarised)
    )
  })
}

shinyApp(ui, server)
