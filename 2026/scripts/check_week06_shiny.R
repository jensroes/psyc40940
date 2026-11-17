root <- normalizePath("2026/week-06-shiny-basics-reactivity")
setwd(root)
library(shiny)

data <- readr::read_csv("data/participant_reaction_times.csv", show_col_types = FALSE)
stopifnot(nrow(data) == 72L, dplyr::n_distinct(data$ppt_id) == 72L,
          sum(data$modality == "speech") == 33L,
          sum(data$modality == "writing") == 39L,
          all(is.finite(data$mean_rt)))

load_app <- function(file) {
  env <- new.env(parent = globalenv())
  app <- source(file, local = env)$value
  stopifnot(inherits(app, "shiny.appobj"),
            identical(names(formals(app$serverFuncSource())), c("input", "output")))
  attr(app, "test_ui") <- as.character(env$ui)
  app
}

complete_scaffold <- function(file) {
  code <- paste(readLines(file), collapse = "\n")
  if (file == "starter_app.R") {
    code <- gsub('plotOutput("---")', 'plotOutput("rt_plot")', code, fixed = TRUE)
    code <- gsub("input$---", "input$modality", code, fixed = TRUE)
    code <- gsub("ggplot(---,", "ggplot(selected_data,", code, fixed = TRUE)
  } else if (file == "slider_app.R") {
    code <- gsub('p("---")',
                 'p("Each value is one participant mean reaction time in milliseconds.")',
                 code, fixed = TRUE)
    code <- gsub('helpText("---")',
                 'helpText("Bin width changes grouping, not the participants included.")',
                 code, fixed = TRUE)
    code <- gsub('sliderInput("binwidth", "---"',
                 'sliderInput("binwidth", "Bin width (ms)"', code, fixed = TRUE)
    code <- gsub("value = ---", "value = 100", code, fixed = TRUE)
    code <- gsub("input$---", "input$binwidth", code, fixed = TRUE)
  }
  stopifnot(!grepl("---", code, fixed = TRUE))
  target <- file.path(tempdir(), paste0("completed-", file))
  writeLines(code, target)
  target
}

testable_server <- function(app) {
  server <- app$serverFuncSource()
  # testServer requires session; add it only to this test copy.
  formals(server) <- as.pairlist(c(as.list(formals(server)), alist(session = )))
  server
}

app <- load_app("minimal_app.R")
testServer(testable_server(app), {
  for (n in c(5, 7, -3)) {
    session$setInputs(number = n)
    stopifnot(identical(output$double, as.character(n * 2)))
  }
})
cat("Minimal app checked: number input updates matching text output.\n")

for (file in c("starter_app.R", "slider_app.R",
               "worked_example_app.R", "extension_app.R")) {
  app <- load_app(complete_scaffold(file))
  testServer(testable_server(app), {
    images <- character()
    widths <- if (file == "starter_app.R") 100 else c(25, 100, 300)
    for (group in c("speech", "writing")) {
      for (width in widths) {
        session$setInputs(modality = group, binwidth = width)
        stopifnot(nzchar(output$rt_plot$src))
        images <- c(images, output$rt_plot$src)
        if (file == "extension_app.R") {
          expected_n <- if (group == "speech") 33L else 39L
          stopifnot(identical(output$selection_note,
                              paste("Participants shown:", expected_n,
                                    "| Bin width:", width, "ms")))
        }
      }
    }
    stopifnot(length(unique(images)) == 2L * length(widths))
  })
  cat("App checked:", file, "\n")
}

chunks <- list()
old_document_hook <- knitr::knit_hooks$get("document")
knitr::knit_hooks$set(document = function(text) {
  chunks <<- knitr::knit_code$get()
  text
})
knitr::knit("01_read_and_modify_a_shiny_app.Rmd",
            output = file.path(tempdir(), "week6-instructions.md"), quiet = TRUE)
knitr::knit_hooks$set(document = old_document_hook)
stopifnot(identical(names(chunks), c("install-shiny", "data-frame-example", "dollar-example", "select-column",
                                    "paste-example", "complete-paste")),
          identical(trimws(paste(chunks[["install-shiny"]], collapse = "\n")),
                    'install.packages("shiny")'))
function_env <- new.env(parent = baseenv())
eval(parse(text = chunks[["data-frame-example"]]), envir = function_env)
selected_doubles <- eval(parse(text = chunks[["dollar-example"]]), envir = function_env)
completed_selection <- gsub("---", "number", chunks[["select-column"]], fixed = TRUE)
selected_numbers <- eval(parse(text = completed_selection), envir = function_env)
stopifnot(identical(dim(function_env$example_data), c(5L, 2L)),
          identical(names(function_env$example_data), c("number", "doubled")),
          identical(selected_numbers, 1:5),
          identical(selected_doubles, (1:5) * 2))
paste_result <- eval(parse(text = chunks[["paste-example"]]), envir = function_env)
completed_paste <- gsub("---", "bin_width", chunks[["complete-paste"]], fixed = TRUE)
summary_result <- eval(parse(text = completed_paste), envir = function_env)
stopifnot(identical(paste_result, "Participants shown: 33"),
          identical(summary_result, "Participants shown: 33 | Bin width: 100 ms"))
cat("Worksheet checked: data-frame selection and optional paste examples work; app code stays in scripts.\n")
