#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
cmd_args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", cmd_args, value = TRUE)
if (length(file_arg) == 0) {
  stop("Could not determine script path", call. = FALSE)
}
script_file <- normalizePath(sub("^--file=", "", file_arg[[1]]), mustWork = TRUE)
render_images <- file.path(dirname(script_file), "render_slide_images.R")
status <- system2("Rscript", c(render_images, "pptx", args))
quit(status = status)
