library(shiny)

ui <- navbarPage(title = "App with tabs",
                 tabPanel(title = "Histogram",
                    # Create a sidebar layout within tab panel
                    sidebarLayout(
                      sidebarPanel(

                      ),
                      mainPanel (

                      )
                    )

                 ),
                 tabPanel(title = "Scatterplot"

                 ),
)

server <- function(input, output) {


}

shinyApp(ui, server)
