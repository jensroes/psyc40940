# Load packages
library(shiny)
library(tidyverse)
library(plotly)

# Load data
spellname <- read_csv("data/spellname.csv")

choices <- select(spellname, where(is.numeric)) %>% names()

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("xvar", label = "Select a x-variable", selected = choices[2], choices = choices),
      selectInput("yvar", label = "Select a y-variable", selected = choices[4], choices = choices)),
    mainPanel(
      fluidRow(
        column(5,
        plotOutput("myplot", brush = brushOpts(id = "selected_region"))),
        column(5,
        plotlyOutput("mysubplot")))

    )
  )
)


server <- function(input, output) {
  xyrange <- reactiveValues(x = NA, y = NA)

  output$myplot <- renderPlot({
    ggplot(spellname, aes(x = .data[[input$xvar]], y = .data[[input$yvar]])) +
      geom_point()
  })

  observe({
    sel_reg <- input$selected_region
    xyrange$x <- c(sel_reg$xmin, sel_reg$xmax)
    xyrange$y <- c(sel_reg$ymin, sel_reg$ymax)
  })

  output$mysubplot <- renderPlotly({
    p <- ggplot(spellname, aes(x = .data[[input$xvar]], y = .data[[input$yvar]])) +
      geom_point() +
      coord_cartesian(xlim = xyrange$x, ylim = xyrange$y)

    ggplotly(p)
  })


}

shinyApp(ui, server)
