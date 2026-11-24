library(shiny)
library(tidyverse)

my_data <- read_csv("data/---", show_col_types = FALSE)

ui <- fluidPage(
  titlePanel("Explore your data"),
  p("---"),
  sidebarLayout(
    sidebarPanel(
      # --- first control
      # --- second control
      helpText("---")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("First view",
          p("---"),
          plotOutput("plot_one")
        ),
        tabPanel("Second view",
          p("---"),
          plotOutput("plot_two")
        )
      ),
      helpText("---")
    )
  )
)

server <- function(input, output) {
  selected_data <- reactive({
    NULL # --- shared preparation
  })

  output$plot_one <- renderPlot({
    NULL # --- first plot
  })

  output$plot_two <- renderPlot({
    NULL # --- second plot
  })
}

shinyApp(ui, server)
