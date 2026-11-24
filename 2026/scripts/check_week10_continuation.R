# Check the runnable fallback and completion tasks in the Week 10 guide.
library(shiny)
library(tidyverse)
root <- normalizePath("2026")
folder <- file.path(root, "week-10-wrap-up-assessment-support")
lines <- readLines(file.path(folder, "session-guide.Rmd"))
chunk <- function(label, replacements = list()) {
  first <- grep(paste0("^```\\{r ", label, ","), lines)
  stopifnot(length(first) == 1L)
  last <- first + which(lines[(first + 1L):length(lines)] == "```")[1]
  code <- paste(lines[(first + 1L):(last - 1L)], collapse = "\n")
  for (pair in replacements) code <- sub(pair[1], pair[2], code, fixed = TRUE)
  stopifnot(!grepl("---", code, fixed = TRUE))
  code
}
load_app <- function(path) {
  env <- new.env(parent = globalenv())
  app <- source(path, local = env)$value
  stopifnot(inherits(app, "shiny.appobj"))
  server <- app$serverFuncSource()
  stopifnot(identical(names(formals(server)), c("input", "output")))
  formals(server) <- as.pairlist(c(as.list(formals(server)), alist(session = )))
  list(server = server, ui = as.character(env$ui))
}
# Run from an extracted student ZIP, not the original teaching directory.
place <- tempfile("week10-extracted-")
dir.create(place)
unzip(file.path(root, "student-zips/psyc40940-week-10-wrap-up-assessment-support.zip"),
      exdir = place)
materials <- file.path(place, "week-10-wrap-up-assessment-support")
project <- file.path(place, "behavioural-portfolio")
dir.create(project)
dir.create(file.path(project, "data"))
stopifnot(file.copy(file.path(materials, "supplied_data_app.R"), file.path(project, "app.R")),
          file.copy(file.path(materials, "data/participant_rates.csv"),
                    file.path(project, "data/participant_rates.csv")),
          file.copy(file.path(materials, "submission-example/portfolio.Rproj"),
                    file.path(project, "behavioural-portfolio.Rproj")))
setwd(project)
console_data <- readr::read_csv("data/participant_rates.csv", show_col_types = FALSE)
stopifnot(nrow(console_data) == 492L)
# Check the real Shiny app-directory startup from outside the project folder.
setwd(place)
directory_app <- shiny::shinyAppDir(project)
tryCatch({
  directory_app$onStart()
  stopifnot(identical(normalizePath(getwd()), normalizePath(project)))
  directory_app$serverFuncSource()
}, finally = directory_app$onStop())
setwd(project)
initial <- load_app("app.R")
stopifnot(!grepl('id="phase"', initial$ui, fixed = TRUE),
          !grepl('id="prime_condition"', initial$ui, fixed = TRUE))
testServer(initial$server, {
  stopifnot(nzchar(output$overview_plot$src))
  output$participant_plot
})
cat("Fallback runs from the extracted folder: one plot, no input controls.\n")
condition <- chunk("continuation-condition-control",
                   list(c("---(", "checkboxGroupInput(")))
phase <- chunk("continuation-phase-control", list(c("---(", "selectInput(")))
shared <- chunk("continuation-shared-preparation", list(
  c("---({", "reactive({"), c("input$---", "input$prime_condition"),
  c("input$---", "input$phase"), c('"---"', '"No observations match. Select a condition."')
))
individual <- chunk("continuation-individual-plot", list(
  c("ggplot(---,", "ggplot(selected_data(),"),
  c('"---"', '"Full passive responses (out of 4)"')
))
code <- paste(readLines("app.R"), collapse = "\n")
replace <- function(old, new) {
  stopifnot(grepl(old, code, fixed = TRUE))
  code <<- sub(old, new, code, fixed = TRUE)
}
replace("# --- condition control", paste0(condition, ","))
replace("# --- phase control", paste0(phase, ","))
replace("# --- shared reactive preparation", shared)
replace('filter(d_workshop, phase == "Before")', "selected_data()")
replace("NULL # --- individual plot", individual)
replace('p("---")', 'p("Follow each learner behind the mean pattern.")')
stopifnot(!grepl("---", code, fixed = TRUE))
writeLines(code, "app.R")
for (file in c("app.R", file.path(materials, "worked_example_app.R"))) {
  app <- load_app(file)
  testServer(app$server, {
    session$setInputs(prime_condition = c("Baseline", "Active sentence", "Passive sentence"),
                      phase = "Before")
    stopifnot(nrow(selected_data()) == 246L,
              n_distinct(selected_data()$participant) == 17L,
              all(selected_data()$n_trials == 4L),
              all(selected_data()$n_passive %in% 0:4),
              nzchar(output$overview_plot$src), nzchar(output$participant_plot$src))
    before <- output$overview_plot$src
    session$setInputs(phase = "After")
    stopifnot(all(selected_data()$phase == "After"),
              !identical(before, output$overview_plot$src),
              nzchar(output$participant_plot$src))
    session$setInputs(prime_condition = "Baseline")
    stopifnot(nrow(selected_data()) == 82L,
              all(selected_data()$prime_condition == "Baseline"),
              nzchar(output$overview_plot$src), nzchar(output$participant_plot$src))
    session$setInputs(prime_condition = character())
    for (name in c("overview_plot", "participant_plot")) {
      error <- tryCatch({output[[name]]; NULL}, error = identity)
      stopifnot(inherits(error, "shiny.silent.error"))
    }
    session$setInputs(prime_condition = "Baseline")
    stopifnot(nrow(selected_data()) == 82L,
              nzchar(output$overview_plot$src), nzchar(output$participant_plot$src))
  })
  cat("Controls, both plot connections, counts and recovery checked:", file, "\n")
}

# Knit the same import in a report beside the app and project file.
writeLines(c("---", "title: Path check", "output: html_document", "---",
             "```{r import}",
             'd <- readr::read_csv("data/participant_rates.csv", show_col_types = FALSE)',
             'stopifnot(nrow(d) == 492L)', "```"), "path-check.Rmd")
rmarkdown::render("path-check.Rmd", quiet = TRUE, envir = new.env(parent = globalenv()))
stopifnot(file.exists("path-check.html"))
cat("Project Console, Shiny app-directory startup and knitting use the same data path.\n")

# Catch-up with an own dataset: load it and create one plot before controls.
stopifnot(identical(readLines(file.path(materials, "own_data_app.R")),
                    readLines(file.path(root, "week-09-dashboard-workshop/own_data_app.R"))),
          identical(readLines(file.path(materials, "supplied_data_template.R")),
                    readLines(file.path(root, "week-09-dashboard-workshop/supplied_data_app.R"))))
own <- data.frame(response_ms = c(320, 410, 380, 520, 460, 350, 440, 490),
                  condition = rep(c("A", "B"), each = 4))
write_csv(own, "data/catchup-own.csv")
code <- paste(readLines(file.path(materials, "own_data_app.R")), collapse = "\n")
code <- sub('data/---', 'data/catchup-own.csv', code, fixed = TRUE)
histogram <- chunk("catchup-own-histogram", list(c("---", "response_ms")))
code <- sub("NULL # --- first plot", histogram, code, fixed = TRUE)
writeLines(code, "app.R")
app <- load_app("app.R")
testServer(app$server, {
  stopifnot(nzchar(output$plot_one$src))
})
cat("Own-data catch-up template: CSV import and first histogram work.\n")

# Catch-up with supplied data: complete one ordinary plot, then add controls.
code <- paste(readLines(file.path(materials, "supplied_data_template.R")), collapse = "\n")
first_plot <- chunk("catchup-supplied-first-plot", list(c("---", "n_passive")))
replace("NULL # --- average plot", first_plot)
writeLines(code, "app.R")
app <- load_app("app.R")
testServer(app$server, {
  stopifnot(nzchar(output$overview_plot$src))
})
replace("# --- condition control", paste0(condition, ","))
replace("# --- phase control", paste0(phase, ","))
replace("selected_data <- reactive({\n    NULL # --- shared preparation\n  })", shared)
replace('filter(d_workshop, phase == "Before")', "selected_data()")
replace("NULL # --- individual plot", individual)
replace('p("---")', 'p("Compare average counts.")')
replace('p("---")', 'p("Inspect individual learners.")')
stopifnot(!grepl("---", code, fixed = TRUE))
writeLines(code, "app.R")
app <- load_app("app.R")
testServer(app$server, {
  session$setInputs(prime_condition = "Baseline", phase = "Before")
  stopifnot(nrow(selected_data()) == 82L,
            nzchar(output$overview_plot$src), nzchar(output$participant_plot$src))
  session$setInputs(phase = "After")
  stopifnot(all(selected_data()$phase == "After"), nzchar(output$overview_plot$src))
  session$setInputs(prime_condition = character())
  error <- tryCatch({output$overview_plot; NULL}, error = identity)
  stopifnot(inherits(error, "shiny.silent.error"))
  session$setInputs(prime_condition = "Baseline")
  stopifnot(nrow(selected_data()) == 82L, nzchar(output$overview_plot$src))
})
cat("Supplied-data catch-up template: first plot, controls, second view and recovery work.\n")
