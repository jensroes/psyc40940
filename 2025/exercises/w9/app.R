# Load packages
library(shiny)
library(tidyverse)
library(ggthemes)

# Load data
spellname <- read_csv("data/spellname.csv") %>%
  mutate(across(name_familiarised, ~case_when(. ~ "familiarised",
                                              !. ~ "not familiarised")))

all_vars <- names(spellname)
all_num_vars <- names(select(spellname, where(is.numeric), -ends_with("id")))
all_cat_vars <- names(select(spellname, where(is.character), -ends_with("id"), -resp))

ui <- navbarPage("Dynamic Plot App",
                 tabPanel("Scatter Plot",
                        sidebarPanel(
                            selectInput("xvar", "X-axis:", choices = all_num_vars),
                            selectInput("yvar", "Y-axis:", choices = all_num_vars, selected = all_num_vars[2]),
                            selectInput("col", "Colour:", choices = all_cat_vars),
                            sliderInput("size", "Size of dots", min = 0, max = 5, value = 1),
                            uiOutput("varout"),
                            checkboxInput("leg", "Legend", value = TRUE)),
                         mainPanel(
                            plotOutput("scatterPlot")
                          )),
                 tabPanel("Histogram"),
                 tabPanel("Boxplot")
)


server <- function(input, output) {

  datavar <- reactive({
    spellname[[input$xvar]]
  })


  output$varout <- renderUI({
    # get the min and max values
    rng <- range(datavar(), na.rm = TRUE)

    # create a slider for the
    sliderInput("dynamicVar",
                str_c("X-axis variable: ", input$xvar),
                value = rng,
                min = floor(rng[1]),
                max = ceiling(rng[2]))
  })

  output$scatterPlot <- renderPlot({
    ggplot(spellname, aes(x = .data[[input$xvar]], y = .data[[input$yvar]], colour = .data[[input$col]])) +
      geom_point(show.legend = input$leg, size = input$size) +
      coord_cartesian(xlim = input$dynamicVar)

  })

}

shinyApp(ui, server)
