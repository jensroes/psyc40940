# Load packages
library(shiny)
library(tidyverse)
library(ggthemes)

# Load data and create nicer labels for "familiarisation"
spellname <- read_csv("data/spellname.csv") %>%
  mutate(across(name_familiarised, ~case_when(. ~ "familiarised",
                                              !. ~ "not familiarised")))

# Extract modality labels
mods <- unique(spellname$modality)

# Create user interface
ui <- fluidPage(
  selectInput("mod", "Response modality", choices = mods),
  selectInput("ppt", "Participants", choices = NULL),
  plotOutput("plot")
)

# Create server
server <- function(input, output, session) {
  # Filter data for "modality"
  sn_mod <- reactive({
    filter(spellname, modality == input$mod)
  })

  # Update the select input for "participant" after selecting modality.
  observeEvent(sn_mod(), {
    choices <- unique(sn_mod()$ppt_id)
    updateSelectInput(inputId = "ppt", choices = choices)
  })

  # Once a ppt was selected filter data for "participant".
  ppt <- reactive({
    req(input$ppt)
    filter(sn_mod(), ppt_id == input$ppt)
  })

  # Create a plot depending on input
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
