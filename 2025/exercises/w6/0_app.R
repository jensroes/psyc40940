# Load package
library(shiny)

# Create user interface (only print some text)
ui <- fluidPage(
  "I'm the user interface."
)

# Create server (backend); this will do absolutely nothing.
server <- function(input, output, session) {

}

# Run shiny app by providing user interface and server
shinyApp(ui, server)
