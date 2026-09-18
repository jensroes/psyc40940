# Load library
library(shiny)

# Create choices
choices <-  c("panel1", "panel2")

# User interface
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("controller", "Show",
                  choices = choices)
    ),
    mainPanel(
      # Create the different tabs
      tabsetPanel(
        id = "switcher",
        type = "pills",
        tabPanelBody("panel1",
                     "Panel 1 content"),
        tabPanelBody("panel2",
                     "Panel 2 content")
      )
    )
  )
)

# Server backend
server <- function(input, output) {
  # Update the tabs that should show
  observeEvent(input$controller, {
    updateTabsetPanel(inputId = "switcher",
                      selected = input$controller)
  })

}

shinyApp(ui, server)
