library(shiny)
library(tidyverse)

complete_file <- function(path, replacements, destination) {
  code <- paste(readLines(path), collapse = "\n")
  for (pair in replacements) code <- sub(pair[[1]], pair[[2]], code, fixed = TRUE)
  lines <- strsplit(code, "\n", fixed = TRUE)[[1]]
  active <- paste(lines[!grepl("^\\s*#", lines)], collapse = "\n")
  stopifnot(!grepl("---", active, fixed = TRUE))
  writeLines(code, destination)
  destination
}
load_app <- function(path) {
  env <- new.env(parent = globalenv())
  app <- source(path, local = env)$value
  stopifnot(inherits(app, "shiny.appobj"))
  server <- app$serverFuncSource()
  stopifnot(identical(names(formals(server)), c("input", "output")))
  formals(server) <- as.pairlist(c(as.list(formals(server)), alist(session = )))
  list(app = app, server = server, ui = as.character(env$ui))
}
root <- normalizePath("2026")
temporary <- file.path(tempdir(), "shiny-core-checks")
dir.create(temporary, showWarnings = FALSE)

setwd(file.path(root, "week-07-reactivity-layouts"))
stopifnot(identical(readLines("intro_app.R"),
                    readLines("../week-06-shiny-basics-reactivity/worked_example_app.R")))
familiar <- load_app("intro_app.R")
stopifnot(grepl('id="rt_plot"', familiar$ui, fixed=TRUE),
          !grepl("selection_note", familiar$ui, fixed=TRUE),
          !grepl("values_plot", familiar$ui, fixed=TRUE))
testServer(familiar$server, {
  session$setInputs(modality="speech", binwidth=100)
  hist <- output$rt_plot$src
  stopifnot(nzchar(hist))
  session$setInputs(binwidth=250)
  stopifnot(!identical(output$rt_plot$src, hist))
  hist <- output$rt_plot$src
  session$setInputs(modality="writing")
  stopifnot(!identical(output$rt_plot$src, hist))
})
shared_file <- complete_file("starter_app.R", list(
  c('textOutput("---")', 'textOutput("selection_note")'),
  c('plotOutput("---"', 'plotOutput("values_plot"'),
  c("selected_data <- ---({", "selected_data <- reactive({"),
  c("nrow(---)", "nrow(selected_data())"),
  c("ggplot(---,", "ggplot(selected_data(),"),
  c("ggplot(---,", "ggplot(selected_data(),")
), file.path(temporary, "week7-shared.R"))
for (file in c("comparison_app.R", shared_file)) {
  app <- load_app(file)
  testServer(app$server, {
    session$setInputs(modality="speech", binwidth=100)
    stopifnot(identical(output$selection_note,"Participants shown: 33"),
              nzchar(output$rt_plot$src), nzchar(output$values_plot$src))
    box <- output$values_plot$src
    hist <- output$rt_plot$src
    session$setInputs(binwidth=250)
    stopifnot(identical(output$values_plot$src,box),
              !identical(output$rt_plot$src,hist))
    session$setInputs(modality="writing")
    stopifnot(identical(output$selection_note,"Participants shown: 39"))
  })
}
cat("Checked Week 7: familiar histogram, added views and shared-data scaffold.\n")

setwd(file.path(root, "week-08-tabs-controls"))
d_week8 <- readr::read_csv("data/participant_reaction_times.csv",show_col_types=FALSE)
d_week7 <- readr::read_csv("../week-07-reactivity-layouts/data/participant_reaction_times.csv",show_col_types=FALSE)
stopifnot(identical(as.data.frame(d_week8[names(d_week7)]),as.data.frame(d_week7)),
          !anyNA(d_week8$vocabulary_score),
          identical(readLines("intro_app.R"),
                    readLines("../week-07-reactivity-layouts/worked_example_app.R")))
intro <- load_app("intro_app.R")
tabs <- complete_file("starter_app.R", list(
  c("---(", "tabsetPanel("), c("---(", "tabPanel("), c("---(", "tabPanel("),
  c('p("---")', 'p("Explore the selected distribution.")'),
  c('p("---")', 'p("Inspect its summary and individual values.")')
), file.path(temporary, "tabs.R"))
app <- load_app(tabs)
stopifnot(identical(body(app$server), body(intro$server)),
          length(gregexpr('data-toggle="tab"', app$ui, fixed=TRUE)[[1]]) == 2L)
testServer(app$server, {
  session$setInputs(modality = "speech", binwidth = 100)
  stopifnot(identical(output$selection_note, "Participants shown: 33"),
            nzchar(output$rt_plot$src), nzchar(output$values_plot$src))
  box <- output$values_plot$src
  hist <- output$rt_plot$src
  session$setInputs(binwidth = 250)
  stopifnot(identical(output$values_plot$src, box), !identical(output$rt_plot$src, hist))
  session$setInputs(modality = "writing")
  stopifnot(identical(output$selection_note, "Participants shown: 39"))
})
cat("Checked Week 8: familiar server and plots preserved when adding tabs.\n")
phase_a <- complete_file("controls_app.R", list(
  c('---("groups"', 'checkboxGroupInput("groups"'),
  c("input$---", "input$groups"),
  c("input$vocab_range[---]", "input$vocab_range[1]"),
  c("input$vocab_range[---]", "input$vocab_range[2]")
), file.path(temporary, "controls-a.R"))
app <- load_app(phase_a)
d <- readr::read_csv("data/participant_reaction_times.csv", show_col_types=FALSE)
testServer(app$server, {
  for (group in list(c("speech","writing"), "speech", "writing")) {
    session$setInputs(groups=group, vocab_range=c(0.80,1.00), binwidth=100)
    expected <- if(length(group)==2) 72L else if(group=="speech") 33L else 39L
    stopifnot(nrow(selected_data())==expected,
              identical(output$selection_note,paste("Participants shown:",expected)),
              nzchar(output$rt_plot$src),nzchar(output$values_plot$src))
  }
  session$setInputs(groups=c("speech","writing"),vocab_range=c(0.90,0.95))
  stopifnot(nrow(selected_data())==sum(d$vocabulary_score>=0.90 & d$vocabulary_score<=0.95))
  session$setInputs(groups=character())
  stopifnot(nrow(selected_data())==0L, identical(output$selection_note,"Participants shown: 0"))
  session$setInputs(groups=c("speech","writing"),vocab_range=c(0.80,0.81))
  stopifnot(nrow(selected_data())==0L)
  session$setInputs(vocab_range=c(0.80,1.00))
  stopifnot(nrow(selected_data())==72L,nzchar(output$rt_plot$src))
})
cat("Checked Week 8: checkpoint A runs with two blanks still commented; filtering and empty rows behave as expected.\n")
controls <- complete_file(phase_a, list(
  c("nrow(---)", "nrow(selected)"),
  c('"---"', '"No participants match. Select a group or widen the range."')
), file.path(temporary, "controls-b.R"))
writeLines(sub("^    # ", "    ", readLines(controls)), controls)
faceted <- file.path(temporary,"controls-faceted.R")
writeLines(sub("      # facet_wrap(~modality) +", "      facet_wrap(~modality) +",
               readLines(controls),fixed=TRUE),faceted)
for (file in c(controls, "worked_example_app.R", "extension_app.R", faceted)) {
  app <- load_app(file)
  testServer(app$server, {
    session$setInputs(groups = c("speech", "writing"),
                     vocab_range = c(0.80, 1.00), binwidth = 100)
    stopifnot(nrow(selected_data()) == 72L, nzchar(output$rt_plot$src))
    if(file=="extension_app.R") {
      stopifnot(grepl("speech",output$summary_table,fixed=TRUE),
                grepl("writing",output$summary_table,fixed=TRUE))
    }
    for (group in c("speech", "writing")) {
      session$setInputs(groups = group)
      stopifnot(nrow(selected_data()) == if (group == "speech") 33L else 39L)
    }
    box <- output$values_plot$src
    hist <- output$rt_plot$src
    session$setInputs(binwidth = 250)
    stopifnot(identical(output$values_plot$src, box),
              !identical(output$rt_plot$src, hist))
    for (bad in c("no-groups", "empty-range")) {
      if (bad == "no-groups") session$setInputs(groups = character())
      else session$setInputs(groups = c("speech","writing"), vocab_range = c(0.80,0.81))
      problem <- tryCatch({selected_data(); NULL}, error = identity)
      stopifnot(inherits(problem, "shiny.silent.error"), nzchar(conditionMessage(problem)))
      for(name in c("selection_note","rt_plot","values_plot")) {
        feedback <- tryCatch({output[[name]]; NULL},error=identity)
        stopifnot(inherits(feedback,"shiny.silent.error"),nzchar(conditionMessage(feedback)))
      }
      session$setInputs(groups = c("speech","writing"), vocab_range = c(0.80,1.00))
      stopifnot(nrow(selected_data()) == 72L,
                identical(output$selection_note, "Participants shown: 72"),
                nzchar(output$values_plot$src))
    }
  })
  cat("Checked Week 8:", basename(file), "\n")
}

plot_expression <- function(server, name) {
  target <- parse(text=paste0("output$",name))[[1]]
  assignments <- Filter(function(x) is.call(x) && identical(x[[1]],as.name("<-")) &&
                         identical(x[[2]],target), as.list(body(server))[-1])
  stopifnot(length(assignments)==1L)
  assignments[[1]][[3]][[2]]
}
histogram <- complete_file("optional_histogram_app.R", list(
  c('p("---")','p("Checkbox switches between pooled and group histograms.")'),
  c('---("facet_groups"','checkboxInput("facet_groups"'),
  c('ggplot(---,','ggplot(selected_data(),'),
  c('---(~modality)','facet_wrap(~modality)')
), file.path(temporary,"histogram-optional.R"))
app <- load_app(histogram)
testServer(app$server, {
  session$setInputs(groups=c("speech","writing"),vocab_range=c(0.8,1),
                    binwidth=100,facet_groups=FALSE)
  before <- selected_data(); box <- output$values_plot$src
  pooled <- ggplot_build(eval(plot_expression(app$server,"rt_plot")))
  stopifnot(nrow(pooled$layout$layout)==1L)
  session$setInputs(facet_groups=TRUE)
  panels <- ggplot_build(eval(plot_expression(app$server,"rt_plot")))
  stopifnot(nrow(panels$layout$layout)==2L,identical(before,selected_data()),
            identical(box,output$values_plot$src),nzchar(output$rt_plot$src),
            sum(pooled$data[[1]]$count)==sum(panels$data[[1]]$count))
  session$setInputs(binwidth=250)
  stopifnot(nzchar(output$rt_plot$src),identical(box,output$values_plot$src))
  session$setInputs(groups="speech")
  stopifnot(nrow(selected_data())==33L,
            nrow(ggplot_build(eval(plot_expression(app$server,"rt_plot")))$layout$layout)==1L)
  session$setInputs(groups=character())
  problem <- tryCatch({output$rt_plot;NULL},error=identity)
  stopifnot(inherits(problem,"shiny.silent.error"))
  session$setInputs(groups=c("speech","writing"))
  stopifnot(nrow(selected_data())==72L,nzchar(output$rt_plot$src))
})
cat("Checked Week 8: histogram checkbox changes facets, preserves observations and recovers.\n")

density <- complete_file("optional_density_app.R", list(
  c('p("---")', 'p("Compare pooled and grouped distributions.")'),
  c('---("density_view"', 'radioButtons("density_view"'),
  c('plotOutput("---")', 'plotOutput("density_plot")'),
  c('output$density_plot <- ---({', 'output$density_plot <- renderPlot({'),
  c('ggplot(---,', 'ggplot(selected_data(),'),
  c('---(aes(colour = modality, fill = ---)', 'geom_density(aes(colour = modality, fill = modality)')
), file.path(temporary, "density.R"))
app <- load_app(density)
stopifnot(length(gregexpr('data-toggle="tab"', app$ui, fixed=TRUE)[[1]]) == 3L)
testServer(app$server, {
  session$setInputs(groups=c("speech","writing"), vocab_range=c(0.80,1.00),
                    binwidth=100, density_view="groups")
  stopifnot(nrow(selected_data()) == 72L, nzchar(output$density_plot$src))
  grouped <- ggplot_build(eval(plot_expression(app$server,"density_plot")))$data[[1]]
  stopifnot(length(unique(grouped$group))==2L,
            length(unique(grouped$colour))==2L,length(unique(grouped$fill))==2L)
  hist <- output$rt_plot$src
  box <- output$values_plot$src
  curve <- output$density_plot$src
  session$setInputs(density_view="pooled")
  stopifnot(!identical(output$density_plot$src, curve),
            identical(output$rt_plot$src, hist), identical(output$values_plot$src, box),
            identical(output$selection_note, "Participants shown: 72"))
  pooled <- ggplot_build(eval(plot_expression(app$server,"density_plot")))$data[[1]]
  stopifnot(length(unique(pooled$group))==1L)
  curve <- output$density_plot$src
  session$setInputs(binwidth=250)
  stopifnot(identical(output$density_plot$src, curve),
            !identical(output$rt_plot$src, hist))
  for (group in c("speech", "writing")) {
    session$setInputs(groups=group)
    stopifnot(nzchar(output$density_plot$src))
  }
  session$setInputs(groups=c("speech","writing"), vocab_range=c(0.90,0.95))
  stopifnot(nrow(selected_data()) == 19L, nzchar(output$density_plot$src))
  session$setInputs(vocab_range=c(0.81,0.82))
  stopifnot(nrow(selected_data()) == 1L, nzchar(output$rt_plot$src),
            nzchar(output$values_plot$src))
  problem <- tryCatch({output$density_plot; NULL}, error=identity)
  stopifnot(inherits(problem,"shiny.silent.error"),
            grepl("at least two", conditionMessage(problem), fixed=TRUE))
  session$setInputs(groups=character())
  problem <- tryCatch({output$density_plot; NULL}, error=identity)
  stopifnot(inherits(problem,"shiny.silent.error"),
            grepl("No participants match",conditionMessage(problem),fixed=TRUE))
  session$setInputs(groups=c("speech","writing"), vocab_range=c(0.80,1.00))
  stopifnot(nrow(selected_data()) == 72L, nzchar(output$density_plot$src))
})
cat("Checked Week 8: pooled/group densities with colour and fill, independent controls and recovery.\n")

setwd(file.path(root, "week-09-dashboard-workshop"))
plotly_file <- complete_file("plotly_app.R", list(
  c('---("rt_plot")', 'plotlyOutput("rt_plot")'),
  c("output$rt_plot <- ---({", "output$rt_plot <- renderPlotly({"),
  c('---(p, tooltip = "text")', 'ggplotly(p, tooltip = "text")')
), file.path(temporary,"plotly.R"))
for (file in c(plotly_file, "plotly_worked_app.R")) {
  app <- load_app(file)
  testServer(app$server, {
    session$setInputs(groups = c("speech","writing"), vocab_range = c(0.80,1.00))
    stopifnot(grepl('"data"', output$rt_plot, fixed=TRUE),
              nzchar(output$values_plot$src))
    widget <- plotly_build(eval(plot_expression(app$server,"rt_plot")))
    traces <- widget$x$data
    stopifnot(length(traces)==2L,
              all(vapply(traces,function(t) t$type=="scatter" && t$mode=="markers",logical(1))),
              sum(vapply(traces,function(t) length(t$x),integer(1)))==8648L,
              !grepl("binwidth",app$ui,fixed=TRUE),
              all(vapply(traces,function(t) any(grepl("Stimulus:",t$text,fixed=TRUE)),logical(1))))
    stopifnot(n_distinct(selected_data()$ppt_id)==72L,
              identical(output$selection_note,"Participants: 72 | Trials: 8648"))
    session$setInputs(vocab_range=c(0.90,0.95))
    stopifnot(n_distinct(selected_data()$ppt_id)==19L,
              grepl('"data"',output$rt_plot,fixed=TRUE))
    session$setInputs(groups=character())
    problem <- tryCatch({output$rt_plot;NULL},error=identity)
    stopifnot(inherits(problem,"shiny.silent.error"))
    session$setInputs(groups=c("speech","writing"),vocab_range=c(0.80,1.00))
    stopifnot(nrow(selected_data())==8648L)
    session$setInputs(groups = "speech")
    stopifnot(identical(output$selection_note, "Participants: 33 | Trials: 3402"))
  })
  cat("Checked Plotly:",basename(file),"\n")
}
d_study <- read_csv("data/participant_rates.csv", show_col_types=FALSE)
trials <- read_csv("data/production_trials.csv", show_col_types=FALSE)
stopifnot(nrow(d_study)==492L, nrow(trials)==2232L,
          n_distinct(d_study$participant)==17L,
          all(d_study$n_trials==4L), sum(d_study$n_trials)==1968L,
          all(d_study$n_active+d_study$n_passive+d_study$n_other==d_study$n_trials),
          isTRUE(all.equal(d_study$passive_percent,
                           100*d_study$n_passive/d_study$n_trials)),
          !anyDuplicated(d_study[c("participant","study_session","prime_condition","phase")]))
raw_counts <- count(filter(trials,phase %in% c("Before","After")),
                     participant,study_session,prime_condition,phase,
                     wt=as.integer(response=="Passive"),name="observed_passives")
joined <- left_join(d_study,raw_counts,
                    by=c("participant","study_session","prime_condition","phase"))
stopifnot(all(joined$n_passive==joined$observed_passives),
          !anyNA(joined$observed_passives))
cat("Checked study data: repeated units, cell sizes and passive counts trace to trial records.\n")

# Complete the scaffold using the actual code tasks from the session guide.
task_code <- function(label, replacements) {
  lines <- readLines("session-guide.Rmd")
  first <- grep(paste0("^```\\{r ",label,","),lines)
  stopifnot(length(first)==1L)
  last <- first+which(lines[(first+1):length(lines)]=="```")[1]
  code <- paste(lines[(first+1):(last-1)],collapse="\n")
  for (pair in replacements) code <- sub(pair[[1]],pair[[2]],code,fixed=TRUE)
  stopifnot(!grepl("---",code,fixed=TRUE))
  code
}
condition_code <- task_code("condition-control-task",list(c("---(","checkboxGroupInput(")))
phase_code <- task_code("phase-control-task",list(c("---(","selectInput(")))
shared_code <- task_code("shared-preparation-task",list(c("---","d_workshop"),c('"---"','"No rows. Select a condition or widen the range."')))
average_code <- task_code("average-plot-task",list(c("---","selected_data()"),c('"---"','"Testing occasion"'),c('"---"','"Full passive responses (out of 4)"')))
individual_code <- task_code("individual-plot-task",list(c("---","selected_data()"),c('"---"','"Testing occasion"'),c('"---"','"Full passive responses (out of 4)"')))
workshop <- complete_file("supplied_data_app.R",list(
  c("# --- condition control",paste0(condition_code,",")),
  c("# --- phase control",paste0(phase_code,",")),
  c("NULL # --- shared preparation",shared_code),
  c("NULL # --- average plot",average_code),
  c("NULL # --- individual plot",individual_code),
  c('p("---")','p("Compare means across testing occasions.")'),
  c('p("---")','p("Follow each learner within each condition.")')
),file.path(temporary,"workshop.R"))
# The unchanged NULL blocks deliberately let the initial outline run.
outline <- load_app("supplied_data_app.R")
testServer(outline$server, {
  stopifnot(is.null(selected_data()))
  output$overview_plot
  output$participant_plot
})
for (file in c(workshop,"worked_example_app.R","extension_app.R")) {
  app <- load_app(file)
  stopifnot(!grepl("lextale_range",app$ui,fixed=TRUE),
            !grepl("average_layout",app$ui,fixed=TRUE),
            !grepl("selection_note",app$ui,fixed=TRUE))
  testServer(app$server, {
    session$setInputs(prime_condition=c("Baseline","Active sentence","Passive sentence"),phase="Before")
    stopifnot(nrow(selected_data())==246L,n_distinct(selected_data()$participant)==17L)
    for (phase in c("Before","After")) {
      session$setInputs(phase=phase)
      stopifnot(nrow(selected_data())==246L,all(selected_data()$phase==phase))
      for (name in c("overview_plot","participant_plot")) {
        result <- output[[name]]
        stopifnot(if(file=="extension_app.R") grepl('"data"',result,fixed=TRUE) else nzchar(result$src))
      }
    }
    if (file!="extension_app.R") {
      p <- ggplot_build(eval(plot_expression(app$server,"overview_plot")))
      means <- aggregate(n_passive ~ study_session + prime_condition,
                         data = selected_data(), FUN = mean)
      individual <- ggplot_build(eval(plot_expression(app$server,"participant_plot")))
      stopifnot(nrow(p$data[[2]])==15L,
                isTRUE(all.equal(sort(p$data[[2]]$y), sort(means$n_passive))),
                identical(p$layout$panel_params[[1]]$y$breaks, as.numeric(0:4)),
                isTRUE(all.equal(sort(individual$data[[2]]$y),
                                 sort(selected_data()$n_passive))))
    }
    session$setInputs(prime_condition="Baseline")
    stopifnot(nrow(selected_data())==82L)
    session$setInputs(prime_condition=character())
    for (name in c("overview_plot","participant_plot")) {
      problem <- tryCatch({output[[name]];NULL},error=identity)
      stopifnot(inherits(problem,"shiny.silent.error"))
    }
    session$setInputs(prime_condition=c("Baseline","Active sentence","Passive sentence"))
    stopifnot(nrow(selected_data())==246L)
  })
  cat("Checked small Week 9 app:",basename(file),"\n")
}
# Reproduce both alternative third-control recipes from the guide.
core <- paste(readLines(workshop),collapse="\n")
slider <- task_code("optional-vocabulary-control",list())
range_filter <- task_code("optional-vocabulary-filter",list())
range_code <- sub('helpText("Choose',paste0(slider,',\n      helpText("Choose'),core,fixed=TRUE)
start_filter <- 'selected <- filter(\n  d_workshop,\n  prime_condition %in% input$prime_condition,\n  phase == input$phase\n)'
stopifnot(grepl(start_filter,range_code,fixed=TRUE))
range_code <- sub(start_filter,range_filter,range_code,fixed=TRUE)
range_file <- file.path(temporary,"workshop-range.R");writeLines(range_code,range_file)
app <- load_app(range_file)
testServer(app$server, {
  session$setInputs(prime_condition=c("Baseline","Active sentence","Passive sentence"),phase="Before",lextale_range=c(0,1))
  stopifnot(nrow(selected_data())==246L)
  session$setInputs(lextale_range=c(0.5,0.6))
  stopifnot(n_distinct(selected_data()$participant)==12L,nzchar(output$overview_plot$src),nzchar(output$participant_plot$src))
  session$setInputs(lextale_range=c(0,0.4))
  problem <- tryCatch({output$overview_plot;NULL},error=identity)
  stopifnot(inherits(problem,"shiny.silent.error"))
  session$setInputs(lextale_range=c(0,1))
  stopifnot(nrow(selected_data())==246L,nzchar(output$overview_plot$src))
})
facet_code <- sub('helpText("Choose','checkboxInput("facet_conditions", "Separate condition panels", value=FALSE),\n      helpText("Choose',core,fixed=TRUE)
facet_code <- sub(average_code,paste0('p <- ',average_code,'\n',task_code("optional-facet-choice",list())),facet_code,fixed=TRUE)
facet_file <- file.path(temporary,"workshop-facets.R");writeLines(facet_code,facet_file)
app <- load_app(facet_file)
testServer(app$server, {
  session$setInputs(prime_condition=c("Baseline","Active sentence","Passive sentence"),phase="Before",facet_conditions=FALSE)
  rows <- selected_data(); other <- output$participant_plot$src
  stopifnot(nrow(ggplot_build(eval(plot_expression(app$server,"overview_plot")))$layout$layout)==1L)
  session$setInputs(facet_conditions=TRUE)
  stopifnot(nrow(ggplot_build(eval(plot_expression(app$server,"overview_plot")))$layout$layout)==3L,
            identical(rows,selected_data()),identical(other,output$participant_plot$src))
})
cat("Checked guide recipes: third numeric range or display-only faceting control.\n")

setwd(file.path(root,"week-10-wrap-up-assessment-support/submission-example"))
app <- load_app("app.R")
testServer(app$server, {
  session$setInputs(prime_condition=c("Baseline","Active sentence","Passive sentence"),
                    phases=c("Before","After"),average_layout="sentences",lextale_range=c(0,1))
  stopifnot(identical(output$selection_note,"Learners: 17 | Summary rows: 492"),
            nzchar(output$overview_plot$src),nzchar(output$participant_plot$src))
  session$setInputs(average_layout="phases")
  stopifnot(nzchar(output$overview_plot$src),nrow(selected_data())==492L)
  session$setInputs(phases=character())
  problem <- tryCatch({output$overview_plot;NULL},error=identity)
  stopifnot(inherits(problem,"shiny.silent.error"))
  session$setInputs(phases="After",prime_condition="Baseline")
  stopifnot(nrow(selected_data())==82L,nzchar(output$participant_plot$src))
})
cat("Checked separate study app, recovery and relative data path.\n")
