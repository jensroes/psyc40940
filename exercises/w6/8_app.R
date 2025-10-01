library(shiny)
library(tidyverse)
library(psyntur)

# Load data
spellname <- read_csv("../../data/spellname.csv") %>%
  select(image_id:semcat) %>%
  unique() %>%
  select(where(is.numeric))

ui <- fluidPage(
  titlePanel("Reactive Data Explorer for spellname data"),
  sidebarLayout(
    sidebarPanel(
      selectInput("var", "Choose variable", choices = names(spellname)),
      actionButton("go", "Generate Plot")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  # Reactive expression triggered by button
  selectedVar <- eventReactive(input$go, {
    input$var
  }) # without this, the plot would update each time a new variable is selected

  # Plot output
  output$plot <- renderPlot({
    req(selectedVar()) # check if value is available
    histogram(data = NULL, x = spellname[[selectedVar()]]) +
      labs(x = selectedVar())
  })


}

shinyApp(ui, server)
