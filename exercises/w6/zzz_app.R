library(shiny)
library(tidyverse)
library(psyntur)

ui <- fluidPage(
  titlePanel("Reactive Data Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose dataset", choices = c("blomkvist", "spellname")),
      uiOutput("varSelect"),
      actionButton("go", "Generate Plot")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {

  # Load data
  blomkvist <- read_csv("../../data/blomkvist.csv") %>% select(-id) %>% select(where(is.numeric))
  spellname <- read_csv("../../data/spellname.csv") %>% select(image_id:semcat) %>% unique() %>% select(where(is.numeric))

  # Reactive expression to get selected dataset
  data <- reactive({
    switch(input$dataset,
           "blomkvist" = blomkvist,
           "spellname" = spellname)
  })

  # Dynamically generate variable selector based on dataset
  output$varSelect <- renderUI({
    selectInput("var", "Choose variable", choices = names(data()))
  })

  # Reactive expression triggered by button
  selectedVar <- eventReactive(input$go, {
    input$var
  })

  # Plot output
  output$plot <- renderPlot({
    req(selectedVar())
    histogram(data = NULL, x = data()[[selectedVar()]]) +
      labs(x = selectedVar())
  })


}

shinyApp(ui, server)
