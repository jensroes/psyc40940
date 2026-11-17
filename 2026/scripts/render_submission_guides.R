# Staff build command. Upload the generated HTML guides to NOW.
args <- commandArgs(trailingOnly = TRUE)
if (!length(args) || identical(args, "all")) args <- c("formative", "summative")
if (any(!args %in% c("formative", "summative")))
  stop("Choose formative, summative, or all.")
folder <- normalizePath("2026/assessment-submission-guides", mustWork = TRUE)
for (assessment in unique(args)) {
  source <- file.path(folder, paste0(assessment, "-submission-guide.Rmd"))
  result <- rmarkdown::render(source, quiet = TRUE,
                             envir = new.env(parent = globalenv()))
  cat("Submission guide:", result, "\n")
}
