args <- commandArgs(trailingOnly = TRUE)
format_arg <- grep("^--format=", args, value = TRUE)
if (length(format_arg) > 1L) stop("Supply at most one --format option.")
format <- if (length(format_arg)) sub("^--format=", "", format_arg) else "both"
formats <- switch(format, both = c("pdf_document", "html_document"),
                  pdf = "pdf_document", html = "html_document",
                  word = "word_document", stop("Format must be pdf, html, word or both."))
base <- normalizePath("2026/formative-assessment/feedback-preparation", mustWork = TRUE)
drafts <- file.path(base, "drafts")
output <- file.path(base, "feedback-for-review")
final_output <- file.path(base, "final-pdfs")
dir.create(output, showWarnings = FALSE, recursive = TRUE)
ids <- args[!grepl("^--", args)]
unknown <- args[grepl("^--", args) & !grepl("^--format=", args) & args != "--all"]
if (length(unknown)) stop("Unknown option: ", paste(unknown, collapse = ", "))
files <- if ("--all" %in% args) list.files(drafts, "\\.Rmd$", full.names = TRUE) else
  file.path(drafts, paste0(ids, "-feedback.Rmd"))
if (!length(files)) stop("Use --all or supply one or more submission codes.")
for (file in files) {
  if (!file.exists(file)) stop("Missing feedback source: ", file)
  meta <- rmarkdown::yaml_front_matter(file)
  text <- paste(readLines(file, warn = FALSE), collapse = "\n")
  if (grepl("\\[(Student number|A specific strength|A second strength|Explain a transferable|A transferable priority)", text))
    stop("Unfilled template in: ", file)
  if (isTRUE(meta$params$reviewed) &&
      (is.null(meta$params$feedback_date) || grepl("Pending|\\[", meta$params$feedback_date)))
    stop("Reviewed sheet needs a feedback date: ", file)
  for (out_format in formats) {
    result <- rmarkdown::render(file, output_format = out_format,
                               output_dir = output, quiet = TRUE,
                               envir = new.env(parent = globalenv()))
    cat(if (isTRUE(meta$params$reviewed)) "Reviewed:" else "DRAFT:", result, "\n")
    if (isTRUE(meta$params$reviewed) && out_format == "pdf_document") {
      dir.create(final_output, showWarnings = FALSE, recursive = TRUE)
      final <- file.path(final_output, basename(result))
      if (!file.copy(result, final, overwrite = TRUE))
        stop("Could not update final PDF: ", final)
      cat("Final PDF:", final, "\n")
    }
  }
}
