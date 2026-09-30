#!/usr/bin/env Rscript

# Render PSYC40940 slide decks to HTML and/or PPTX.
# Usage:
#   Rscript 2026/scripts/render_slides.R html
#   Rscript 2026/scripts/render_slides.R pptx
#   Rscript 2026/scripts/render_slides.R both
#   Rscript 2026/scripts/render_slides.R pptx 2026/week-02-foundations/week-02-foundations.Rmd

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[[1]] else "both"
if (!mode %in% c("html", "pptx", "both")) {
  stop("First argument must be one of: html, pptx, both", call. = FALSE)
}

`%||%` <- function(x, y) if (is.null(x)) y else x
script_file <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA_character_)
if (!is.na(script_file) && file.exists(script_file)) {
  repo_root <- normalizePath(file.path(dirname(script_file), "../.."), mustWork = TRUE)
} else if (file.exists(file.path(getwd(), "2026"))) {
  repo_root <- normalizePath(getwd(), mustWork = TRUE)
} else {
  repo_root <- normalizePath(file.path(getwd(), "../.."), mustWork = TRUE)
}

slides <- c(
  "2026/week-01-introduction/part-1-introduction.Rmd",
  "2026/week-01-introduction/part-2-rmarkdown.Rmd",
  "2026/week-02-foundations/week-02-foundations.Rmd",
  "2026/week-03-grammar-of-graphics/week-03-grammar-of-graphics.Rmd",
  "2026/week-04-major-visualisation-tools/week-04-major-visualisation-tools.Rmd",
  "2026/week-05-customising-visualisations/week-05-customising-visualisations.Rmd",
  "2026/week-06-shiny-basics-reactivity/week-06-shiny-basics-reactivity.Rmd",
  "2026/week-07-layout-observers/week-07-layout-observers.Rmd",
  "2026/week-08-dynamic-ui/week-08-dynamic-ui.Rmd",
  "2026/week-09-dashboard-workshop/week-09-dashboard-workshop.Rmd"
)

if (length(args) > 1) {
  slides <- args[-1]
}

pandoc_dir <- Sys.getenv("RSTUDIO_PANDOC", unset = NA_character_)
if (is.na(pandoc_dir) || !file.exists(file.path(pandoc_dir, "pandoc"))) {
  candidates <- c(
    "/usr/lib/rstudio/resources/app/bin/quarto/bin/tools/x86_64",
    "/usr/share/positron/resources/app/quarto/bin/tools/x86_64",
    "/home/jensroes/opt/quarto-1.7.31/bin/tools/x86_64"
  )
  hit <- candidates[file.exists(file.path(candidates, "pandoc"))]
  if (length(hit) > 0) {
    Sys.setenv(RSTUDIO_PANDOC = hit[[1]])
  }
}


add_pptx_yaml_options <- function(lines) {
  yaml <- which(lines == "---")
  if (length(yaml) < 2) return(lines)
  end <- yaml[[2]]
  if (!any(grepl("^always_allow_html:\\s*true\\s*$", lines[seq_len(end)]))) {
    lines <- append(lines, "always_allow_html: true", after = end - 1)
  }
  lines
}

strip_html_chunks <- function(lines) {
  out <- character()
  i <- 1
  while (i <= length(lines)) {
    line <- lines[[i]]
    if (grepl("^```\\{r embed-slide-helper", line)) {
      i <- i + 1
      while (i <= length(lines) && !grepl("^```\\s*$", lines[[i]])) {
        i <- i + 1
      }
      i <- i + 1
      next
    }
    out <- c(out, line)
    i <- i + 1
  }
  out
}

flatten_html <- function(lines) {
  x <- lines
  x <- gsub('<img[^>]*src="([^"]+)"[^>]*alt="([^"]*)"[^>]*>', '![](\\1)', x)
  x <- gsub('<h3>(.*)</h3>', '**\\1**', x)
  x <- gsub('<p><strong>(.*)</strong></p>', '**\\1**', x)
  x <- gsub('<p>(.*)</p>', '\\1', x)
  x <- gsub('<br\\s*/?>', '  ', x)
  x <- gsub('<em>([^<]+)</em>', '*\\1*', x)
  x <- gsub('<strong>([^<]+)</strong>', '**\\1**', x)
  x <- gsub('<code>([^<]+)</code>', '`\\1`', x)
  x <- gsub('<span[^>]*contenteditable="true"[^>]*></span>', '____', x)
  x <- gsub('<span[^>]*class="answer-blank"[^>]*></span>', '____', x)
  x <- gsub('<span[^>]*>([^<]*)</span>', '\\1', x)
  x <- x[!grepl('^<div', x)]
  x <- x[!grepl('^</div>', x)]
  x <- x[!grepl('^<script', x)]
  x <- x[!grepl('^</script>', x)]
  x
}

flatten_fenced_divs <- function(lines) {
  lines[!grepl("^:{3,}\\s*(\\{[^}]*\\})?\\s*$", lines)]
}

plain_math_line <- function(line) {
  x <- line
  if (grepl('^\\s*\\$\\$\\s*$', x)) return(NA_character_)
  x <- gsub('\\\\text\\{([^}]*)\\}', '\\1', x)
  x <- gsub('\\\\mathcal\\{N\\}', 'N', x)
  x <- gsub('\\\\sim', '~', x)
  x <- gsub('\\\\cdot', '*', x)
  x <- gsub('\\\\hat\\{([^}]*)\\}', 'hat(\\1)', x)
  x <- gsub('\\\\mu', 'mu', x)
  x <- gsub('\\\\sigma', 'sigma', x)
  x <- gsub('\\\\beta', 'beta', x)
  x <- gsub('_\\\\text\\{([^}]*)\\}', '_\\1', x)
  x <- gsub('_\\{([^}]*)\\}', '_\\1', x)
  x <- gsub('\\^\\{([^}]*)\\}', '^\\1', x)
  x <- gsub('\\$', '', x)
  x <- gsub('\\\\', '', x, fixed = TRUE)
  x
}

plain_math <- function(lines) {
  out <- character()
  in_chunk <- FALSE
  for (line in lines) {
    if (grepl('^```', line)) {
      in_chunk <- !in_chunk
      out <- c(out, line)
      next
    }
    if (in_chunk) {
      out <- c(out, line)
      next
    }
    line <- plain_math_line(line)
    if (!is.na(line)) out <- c(out, line)
  }
  out
}

scale_line_fonts <- function(line, scale, min_size = 700L) {
  pattern <- 'sz="[0-9]+"'
  matches <- gregexpr(pattern, line, perl = TRUE)[[1]]
  if (matches[1] == -1) return(line)
  lengths <- attr(matches, "match.length")
  pieces <- character(length(matches))
  for (i in seq_along(matches)) {
    match <- substr(line, matches[i], matches[i] + lengths[i] - 1)
    value <- as.integer(gsub('[^0-9]', '', match))
    pieces[i] <- paste0('sz="', max(min_size, as.integer(round(value * scale))), '"')
  }
  regmatches(line, gregexpr(pattern, line, perl = TRUE)) <- list(pieces)
  line
}

scale_pptx_fonts <- function(path, scale = 0.84, reference_scale = 0.42) {
  tmp <- tempfile("pptx")
  dir.create(tmp)
  utils::unzip(path, exdir = tmp)
  xml_files <- list.files(file.path(tmp, "ppt"), pattern = "\\.xml$", recursive = TRUE, full.names = TRUE)
  for (xml in xml_files) {
    txt <- readLines(xml, warn = FALSE)
    txt <- vapply(txt, scale_line_fonts, character(1), scale = scale)
    writeLines(txt, xml, useBytes = TRUE)
  }
  slide_files <- list.files(file.path(tmp, "ppt", "slides"), pattern = "^slide[0-9]+\\.xml$", full.names = TRUE)
  if (length(slide_files) > 0) {
    slide_num <- as.integer(sub("^slide([0-9]+)\\.xml$", "\\1", basename(slide_files)))
    last_slide <- slide_files[which.max(slide_num)]
    txt <- readLines(last_slide, warn = FALSE)
    if (any(grepl("References", txt, fixed = TRUE))) {
      txt <- vapply(txt, scale_line_fonts, character(1), scale = reference_scale / scale, min_size = 360L)
      writeLines(txt, last_slide, useBytes = TRUE)
    }
  }
  old <- getwd()
  on.exit(setwd(old), add = TRUE)
  zip_abs <- normalizePath(path, mustWork = FALSE)
  setwd(tmp)
  files <- list.files('.', recursive = TRUE, all.files = TRUE, no.. = TRUE)
  if (file.exists(zip_abs)) file.remove(zip_abs)
  utils::zip(zipfile = zip_abs, files = files, flags = "-q")
}


render_html <- function(slide) {
  message("Rendering HTML: ", slide)
  old <- getwd()
  on.exit(setwd(old), add = TRUE)
  setwd(dirname(slide))
  rmarkdown::render(basename(slide), quiet = TRUE)
}

render_pptx <- function(slide) {
  message("Rendering PPTX: ", slide)
  old <- getwd()
  on.exit(setwd(old), add = TRUE)
  setwd(dirname(slide))

  lines <- readLines(basename(slide), warn = FALSE)
  lines <- add_pptx_yaml_options(lines)
  lines <- strip_html_chunks(lines)
  lines <- flatten_html(lines)
  lines <- flatten_fenced_divs(lines)
  lines <- plain_math(lines)

  output_file <- sub("\\.Rmd$", ".pptx", basename(slide))
  temp_rmd <- tempfile(pattern = "pptx-source-", tmpdir = ".", fileext = ".Rmd")
  on.exit(unlink(temp_rmd), add = TRUE)
  writeLines(lines, temp_rmd)

  rmarkdown::render(temp_rmd,
                    output_format = rmarkdown::powerpoint_presentation(),
                    output_file = output_file,
                    output_dir = ".",
                    quiet = TRUE,
                    envir = new.env(parent = globalenv()))

  scale_pptx_fonts(output_file, scale = 0.84)
}

slides <- normalizePath(file.path(repo_root, slides), mustWork = TRUE)

for (slide in slides) {
  if (mode %in% c("html", "both")) render_html(slide)
  if (mode %in% c("pptx", "both")) render_pptx(slide)
}

message("Slide render complete")
