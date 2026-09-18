library(shiny)

# Define UI
ui <- fluidPage(

  # Sidebar layout
  sidebarLayout(
    sidebarPanel(

    ),

    mainPanel(
      # Tabs go inside the main panel
      tabsetPanel(

        tabPanel("Histogram",

                 ),

        tabPanel("Scatterplot",

                 )
      )
    )
  )
)

# Define server logic
server <- function(input, output) {


}

# Run the app
shinyApp(ui = ui, server = server)
