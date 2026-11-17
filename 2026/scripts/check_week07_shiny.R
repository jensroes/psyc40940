root <- normalizePath("2026/week-07-reactivity-layouts")
setwd(root)
library(shiny)
d <- readr::read_csv("data/participant_reaction_times.csv", show_col_types = FALSE)
previous <- readr::read_csv("../week-06-shiny-basics-reactivity/data/participant_reaction_times.csv", show_col_types = FALSE)
stopifnot(isTRUE(all.equal(d, previous)), nrow(d) == 72L, dplyr::n_distinct(d$ppt_id) == 72L)

complete_scaffold <- function(file) {
  code <- paste(readLines(file), collapse = "\n")
  if (file == "starter_app.R") {
    stopifnot(length(gregexpr("---", code, fixed = TRUE)[[1]]) == 6L)
    code <- gsub('textOutput("---")', 'textOutput("selection_note")', code, fixed = TRUE)
    code <- gsub('plotOutput("---",', 'plotOutput("values_plot",', code, fixed = TRUE)
    code <- gsub("selected_data <- ---({", "selected_data <- reactive({", code, fixed = TRUE)
    code <- gsub("nrow(---)", "nrow(selected_data())", code, fixed = TRUE)
    code <- gsub("ggplot(---,", "ggplot(selected_data(),", code, fixed = TRUE)
  }
  if (file == "layout_app.R") {
    stopifnot(length(gregexpr("---", code, fixed = TRUE)[[1]]) == 5L)
    for (name in c("sidebarLayout", "sidebarPanel", "mainPanel")) code <- sub("---(", paste0(name, "("), code, fixed = TRUE)
    code <- sub('p("---")', 'p("Participant mean reaction times, in milliseconds.")', code, fixed = TRUE)
    code <- sub('helpText("---")', 'helpText("The group changes all views; bin width changes only the histogram.")', code, fixed = TRUE)
  }
  if (file == "optional_groups_app.R") {
    stopifnot(length(gregexpr("---", code, fixed = TRUE)[[1]]) == 4L)
    code <- sub('---("modality"', 'checkboxGroupInput("modality"', code, fixed = TRUE)
    code <- sub('helpText("---")', 'helpText("The histogram pools both groups; boxplots separate them. Bin width changes only the histogram.")', code, fixed = TRUE)
    code <- sub("modality --- input$modality", "modality %in% input$modality", code, fixed = TRUE)
    code <- sub("aes(x = ---,", "aes(x = modality,", code, fixed = TRUE)
  }
  if (file == "extension_app.R") {
    stopifnot(length(gregexpr("---", code, fixed = TRUE)[[1]]) == 5L)
    code <- sub('p("---")', 'p("Count, median and interquartile range describe the selected participant means.")', code, fixed = TRUE)
    code <- sub('---("summary_table")', 'tableOutput("summary_table")', code, fixed = TRUE)
    code <- sub("output$--- <- ---({", "output$summary_table <- renderTable({", code, fixed = TRUE)
    code <- sub("      ---,", "      selected_data(),", code, fixed = TRUE)
  }
  stopifnot(!grepl("---", code, fixed = TRUE),
            !grepl("observeEvent|eventReactive|actionButton|updateSelectInput", code))
  path <- file.path(tempdir(), file)
  writeLines(code, path)
  path
}

intro_env <- new.env(parent = globalenv())
intro <- source("intro_app.R", local = intro_env)$value
intro_server <- intro$serverFuncSource()
formals(intro_server) <- as.pairlist(c(as.list(formals(intro_server)), alist(session = )))
stopifnot(!grepl("selection_note|values_plot", as.character(intro_env$ui)))
testServer(intro_server, {
  session$setInputs(modality = "speech", binwidth = 100)
  hist <- output$rt_plot$src
  session$setInputs(binwidth = 250)
  stopifnot(nzchar(output$rt_plot$src), !identical(output$rt_plot$src, hist))
  session$setInputs(modality = "writing")
  stopifnot(nzchar(output$rt_plot$src))
})
cat("Checked: familiar one-histogram intro_app.R\n")

for (file in c("comparison_app.R", "starter_app.R", "layout_app.R", "worked_example_app.R", "extension_app.R", "optional_groups_app.R")) {
  env <- new.env(parent = globalenv())
  app <- source(complete_scaffold(file), local = env)$value
  stopifnot(inherits(app, "shiny.appobj"))
  server <- app$serverFuncSource()
  stopifnot(identical(names(formals(server)), c("input", "output")))
  ui <- as.character(env$ui)
  stopifnot(all(vapply(c('id="modality"', 'id="binwidth"', 'id="rt_plot"', 'id="values_plot"', 'id="selection_note"'),
                       function(x) grepl(x, ui, fixed = TRUE), logical(1))))
  # testServer needs session; student scripts keep only input and output.
  formals(server) <- as.pairlist(c(as.list(formals(server)), alist(session = )))
  testServer(server, {
    histograms <- character()
    boxplots <- character()
    groups <- if (file == "optional_groups_app.R") c("speech", "writing", "both") else c("speech", "writing")
    for (group in groups) {
      expected <- switch(group, speech = 33L, writing = 39L, both = 72L)
      selection <- if (group == "both") c("speech", "writing") else group
      session$setInputs(modality = selection, binwidth = 25)
      base_box <- output$values_plot$src
      if (file == "extension_app.R") base_table <- output$summary_table
      for (width in c(25, 100, 250)) {
        session$setInputs(binwidth = width)
        stopifnot(identical(output$selection_note, paste("Participants shown:", expected)),
                  nzchar(output$rt_plot$src), nzchar(output$values_plot$src),
                  identical(output$values_plot$src, base_box))
        if (file != "comparison_app.R") {
          stopifnot(nrow(selected_data()) == expected)
          if (group == "both") stopifnot(dplyr::n_distinct(selected_data()$modality) == 2L)
        }
        if (file == "extension_app.R") {
          cells <- xml2::xml_text(xml2::xml_find_all(
            xml2::read_html(output$summary_table), "//tr[td]/td"))
          values <- as.numeric(trimws(cells))
          expected_values <- c(expected,
            round(median(d$mean_rt[d$modality == group]), 1),
            round(IQR(d$mean_rt[d$modality == group]), 1))
          stopifnot(isTRUE(all.equal(values, expected_values)),
                    identical(output$summary_table, base_table))
        }
        histograms <- c(histograms, output$rt_plot$src)
        boxplots <- c(boxplots, output$values_plot$src)
      }
    }
    stopifnot(length(unique(histograms)) == 3L * length(groups), length(unique(boxplots)) == length(groups))
    if (file == "optional_groups_app.R") {
      session$setInputs(modality = character())
      stopifnot(nrow(selected_data()) == 0L, identical(output$selection_note, "Participants shown: 0"))
      session$setInputs(modality = c("speech", "writing"))
      stopifnot(nrow(selected_data()) == 72L, identical(output$selection_note, "Participants shown: 72"))
    }
  })
  cat("Checked:", file, "\n")
}

guide <- "session-guide.Rmd"
meta <- rmarkdown::yaml_front_matter(guide)
stopifnot(identical(meta$author, "Jens Roeser"),
          !grepl("**", paste(readLines(guide), collapse = "\n"), fixed = TRUE))
rmarkdown::render(guide, output_file = "week7-session-guide-check.html",
                  output_dir = tempdir(), quiet = TRUE)
cat("Staff source renders to HTML; student app completion stays in scripts.\n")
