# Optional extension: add plotly interactivity to the exploration tab

library(shiny)
library(tidyverse)
library(plotly)

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
    "Interactive explore",
    sidebarLayout(
      sidebarPanel(selectInput("familiarised", "Name familiarised", choices = sort(unique(d_spellname$name_familiarised)))),
      mainPanel(plotlyOutput("explore_plot"))
    )
  )
)

server <- function(input, output, session) {
  familiarised_data <- reactive({
    filter(d_spellname, name_familiarised == input$familiarised)
  })

  output$explore_plot <- renderPlotly({
    plot <- ggplot(familiarised_data(), aes(x = ppt_vocab, y = rt, colour = modality)) +
      geom_point(alpha = 0.7) +
      labs(x = "Participant vocabulary", y = "Mean reaction time", colour = "Modality") +
      theme_minimal()

    ggplotly(plot)
  })
}

shinyApp(ui, server)
