# Load packages
library(shiny)
library(tidyverse)
library(ggthemes)

# Load data
spellname <- read_csv("data/spellname.csv") %>%
  mutate(across(name_familiarised, ~case_when(. ~ "familiarised",
                                              !. ~ "not familiarised")))

# Create user interface
ui <- fluidPage(
  selectInput("mod", "Response modality", choices = unique(spellname$modality)),
  selectInput("ppt", "Participants", choices = NULL),
  plotOutput("plot")
)

# Create server
server <- function(input, output, session) {
  sn_mod <- reactive({
    filter(spellname, modality == input$mod) %>%
      select(-modality)
  })

  observeEvent(sn_mod(), {
    choices <- unique(sn_mod()$ppt_id)
    updateSelectInput(inputId = "ppt", choices = choices)
  })

  ppt <- reactive({
    req(input$ppt)
    filter(sn_mod(), ppt_id == input$ppt)
  })


  output$plot <- renderPlot({
    ggplot(ppt(), aes(x = dur, y = rt, label = resp, colour = name_familiarised)) +
      geom_text(alpha = .65, size = 5) +
      theme_classic(base_size = 14) +
      scale_x_log10() +
      scale_y_log10() +
      coord_cartesian(xlim = c(min(sn_mod()$dur), max(sn_mod()$dur)),
                      ylim = c(min(sn_mod()$rt), max(sn_mod()$rt))) +
      scale_color_colorblind() +
      labs(colour = "Picture\nname:",
           x = "Response duration (in msecs)",
           y = "Response time (in msecs)") +
      theme(legend.position = "top",
            legend.justification = "right")


  })

}

# Run app
shinyApp(ui, server)
