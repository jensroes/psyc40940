ui <- fluidPage(
  titlePanel(""),

  fluidRow(
    column(5,
           sliderInput("dist", "Difference in means:",
                       min = -3, max = 3, value = 2, step = 0.25)),
    column(4,
           numericInput("n", "Sample size per group:",
                        value = 100, min = 10, max = 1000, step = 10)
    )),
  fluidRow(
    column(9,
           plotOutput("raincloudPlot", height = "250px", width = "850px")
    )),
)
