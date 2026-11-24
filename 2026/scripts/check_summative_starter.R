# Render the distributed starter in a fresh extracted directory without data.
archive <- normalizePath("2026/student-zips/psyc40940-portfolio.zip")
place <- tempfile("summative-starter-")
dir.create(place)
unzip(archive, exdir = place)
project <- file.path(place, "psyc40940-portfolio")
source <- file.path(project, "report.Rmd")
lines <- readLines(source)
stopifnot(!any(grepl("^author:", lines)),
          sum(grepl('^```\\{r figure-', lines)) == 4L,
          sum(grepl('fig.cap="---"', lines, fixed = TRUE)) == 4L,
          !any(grepl("\\|>|%>%", lines)),
          length(list.files(file.path(project, "data"), pattern = "csv$")) == 0L)
bib <- readLines(file.path(project, "references.bib"))
stopifnot(sum(grepl("^@", bib)) == 1L)
result <- rmarkdown::render(source, quiet = TRUE,
                            envir = new.env(parent = globalenv()))
html <- paste(readLines(result), collapse = "\n")
stopifnot(grepl('ref-Wickham2021MasteringShiny', html, fixed = TRUE),
          grepl('Mastering shiny', html, ignore.case = TRUE))
# Complete one real figure and cross-reference using only generated test data.
text <- paste(lines, collapse = "\n")
text <- sub('# ---', 'example_data <- data.frame(value = 1:5)', text, fixed = TRUE)
text <- sub('# ---', 'ggplot(example_data, aes(x = value)) + geom_histogram(binwidth = 1)',
            text, fixed = TRUE)
text <- sub('# Figure 2: ---', 'Figure \\@ref(fig:figure-one) shows the distribution.\n\n# Figure 2: ---',
            text, fixed = TRUE)
writeLines(text, source)
result <- rmarkdown::render(source, quiet = TRUE,
                            envir = new.env(parent = globalenv()))
html <- paste(readLines(result), collapse = "\n")
stopifnot(grepl('href="#fig:figure-one"', html, fixed = TRUE),
          !grepl('Figure ??', html, fixed = TRUE))
cat("Starter checked: fresh extraction, no-data render, one bibliography entry, four figure chunks, citation and completed figure cross-reference.\n")
