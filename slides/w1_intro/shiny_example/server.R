server <- function(input, output) {
  output$raincloudPlot <- renderPlot({
    set.seed(123)
    N <- input$n
    center <- 6
    meanA <- center + (input$dist/2)
    meanB <- center - (input$dist/2)
    sdA <- 1
    sdB <- 1.2

    df <- data.frame(
      group = rep(c("A", "B"), each = N),
      value = c(
        rnorm(N, mean = meanA, sd = sdA),
        rnorm(N, mean = meanB, sd = sdB)
      )
    )

    ggplot(df, aes(x = group, y = value, fill = group)) +
      ggdist::stat_halfeye(
        adjust = 0.45,
        justification = -0.2,
        .width = 0,
        point_colour = NA
      ) +
      geom_boxplot(
        width = 0.15,
        outlier.shape = NA,
        alpha = 0.5
      ) +
      geom_jitter(
        width = 0.1,
        alpha = 0.5,
        size = 1
      ) +
      coord_flip(ylim = c(2, 10)) +
      theme_bw(base_size = 14) +
      theme(legend.position = "none") +
      scale_fill_colorblind()
  })
}
