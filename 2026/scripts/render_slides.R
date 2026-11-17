#!/usr/bin/env Rscript

# Render 2026 slide decks to HTML and/or image-only PPTX.
# PPTX rendering delegates to render_slide_images.R, which captures the HTML slides
# with headless Chrome and places one full-slide screenshot on each PPTX slide.

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[[1]] else "both"
if (!mode %in% c("html", "pptx", "both")) {
  stop("First argument must be one of: html, pptx, both", call. = FALSE)
}
cmd_args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", cmd_args, value = TRUE)
if (length(file_arg) > 0) {
  script_file <- normalizePath(sub("^--file=", "", file_arg[[1]]), mustWork = TRUE)
} else {
  script_file <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA_character_)
}
if (is.na(script_file) || !file.exists(script_file)) {
  stop("Could not determine script path", call. = FALSE)
}
render_images <- file.path(dirname(script_file), "render_slide_images.R")
status <- system2("Rscript", c(render_images, args))
quit(status = status)
