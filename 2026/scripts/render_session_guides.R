# Staff build command; students receive only each rendered session-guide.html.
args <- commandArgs(trailingOnly = TRUE)
guides <- c(
  "7" = "2026/week-07-reactivity-layouts/session-guide.Rmd",
  "8" = "2026/week-08-tabs-controls/session-guide.Rmd",
  "9" = "2026/week-09-dashboard-workshop/session-guide.Rmd",
  "10" = "2026/week-10-wrap-up-assessment-support/session-guide.Rmd"
)
if (!length(args) || identical(args, "all")) args <- names(guides)
if (any(!args %in% names(guides))) stop("Choose 7, 8, 9, 10, or all.")
for (week in unique(args)) {
  source <- normalizePath(guides[[week]], mustWork = TRUE)
  result <- rmarkdown::render(source, output_file = "session-guide.html",
                             output_dir = dirname(source), quiet = TRUE,
                             envir = new.env(parent = globalenv()))
  cat("Session guide:", result, "\n")
}
