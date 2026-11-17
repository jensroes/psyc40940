#!/usr/bin/env Rscript

# Render ioslides HTML decks to image-only PPTX.
# Each PowerPoint slide is a full-slide screenshot of the corresponding HTML slide.
# Usage:
#   Rscript 2026/scripts/render_slide_images.R pptx
#   Rscript 2026/scripts/render_slide_images.R pptx 2026/week-3/part-1-nested-comparison.Rmd

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[[1]] else "pptx"
if (!mode %in% c("pptx", "html", "both")) {
  stop("First argument must be one of: pptx, html, both", call. = FALSE)
}

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
  "2026/week-07-reactivity-layouts/week-07-reactivity-layouts.Rmd",
  "2026/week-08-tabs-controls/week-08-tabs-controls.Rmd",
  "2026/week-09-dashboard-workshop/week-09-dashboard-workshop.Rmd"
)
slides <- file.path(repo_root, slides)

if (length(args) > 1) {
  slides <- file.path(repo_root, args[-1])
}
slides <- normalizePath(slides, mustWork = TRUE)

pandoc_dir <- Sys.getenv("RSTUDIO_PANDOC", unset = NA_character_)
if (is.na(pandoc_dir) || !file.exists(file.path(pandoc_dir, "pandoc"))) {
  candidates <- c(
    "/usr/lib/rstudio/resources/app/bin/quarto/bin/tools/x86_64",
    "/usr/share/positron/resources/app/quarto/bin/tools/x86_64",
    "/home/jensroes/opt/quarto-1.7.31/bin/tools/x86_64"
  )
  hit <- candidates[file.exists(file.path(candidates, "pandoc"))]
  if (length(hit) > 0) Sys.setenv(RSTUDIO_PANDOC = hit[[1]])
}

chrome <- Sys.getenv("CHROME", unset = Sys.which("google-chrome"))
if (!nzchar(chrome)) chrome <- Sys.which("chromium")
if (!nzchar(chrome)) stop("Could not find google-chrome or chromium", call. = FALSE)

render_html <- function(slide) {
  old <- getwd()
  on.exit(setwd(old), add = TRUE)
  setwd(dirname(slide))
  message("Rendering HTML: ", slide)
  rmarkdown::render(basename(slide), quiet = TRUE)
}

html_for_slide <- function(slide) {
  sub("[.]Rmd$", ".html", slide)
}

count_slides <- function(html_file) {
  doc <- xml2::read_html(html_file)
  length(xml2::xml_find_all(doc, "//slide[not(contains(@class, 'backdrop'))]"))
}

html_url <- function(path) {
  paste0("file://", normalizePath(path, winslash = "/", mustWork = TRUE))
}

prepare_capture_html <- function(html_file) {
  lines <- readLines(html_file, warn = FALSE)
  inject <- c(
    "<style>",
    "*, *::before, *::after { transition-delay: 0s !important; transition-duration: 0s !important; animation-delay: 0s !important; animation-duration: 0s !important; }",
    ".build > *, .to-build, .build-fade, .auto-fadein { visibility: visible !important; opacity: 1 !important; }",
    "</style>",
    "<script>",
    "document.addEventListener('DOMContentLoaded', function() {",
    "  document.querySelectorAll('.to-build, .build-fade, .auto-fadein').forEach(function(x) { x.classList.remove('to-build', 'build-fade', 'auto-fadein'); x.style.visibility = 'visible'; x.style.opacity = '1'; });",
    "});",
    "</script>"
  )
  head <- grep("</head>", lines, fixed = TRUE)
  if (length(head) > 0) {
    lines <- append(lines, inject, after = head[[1]] - 1)
  } else {
    lines <- c(inject, lines)
  }
  # Keep relative image and CSS URLs anchored to the deck's own folder.
  out <- tempfile("slide-capture-", tmpdir = dirname(html_file), fileext = ".html")
  writeLines(lines, out, useBytes = TRUE)
  out
}

capture_slide <- function(capture_html, slide_num, out_png, width = 1600, height = 900) {
  url <- paste0(html_url(capture_html), "#", slide_num)
  status <- system2(chrome, c(
    "--headless=new",
    "--no-sandbox",
    "--disable-gpu",
    "--hide-scrollbars",
    "--force-device-scale-factor=1",
    paste0("--window-size=", width, ",", height),
    "--virtual-time-budget=2500",
    paste0("--screenshot=", out_png),
    url
  ), stdout = TRUE, stderr = TRUE)
  if (!file.exists(out_png)) {
    stop("Chrome did not create screenshot for slide ", slide_num, ":\n", paste(status, collapse = "\n"), call. = FALSE)
  }
}

empty_template <- function(template) {
  x <- officer::read_pptx(template)
  n <- length(x)
  if (n > 0) {
    for (i in seq_len(n)) x <- officer::remove_slide(x, index = 1)
  }
  x
}

render_image_pptx <- function(slide) {
  html_file <- html_for_slide(slide)
  if (!file.exists(html_file) || file.info(html_file)$mtime < file.info(slide)$mtime) {
    render_html(slide)
  }
  n <- count_slides(html_file)
  if (n == 0) stop("No <slide> elements found in ", html_file, call. = FALSE)

  output_file <- sub("[.]Rmd$", ".pptx", slide)
  old_pptx <- output_file
  template <- if (file.exists(old_pptx)) old_pptx else "/home/jensroes/psyc40940-visdata/2026/week-03-grammar-of-graphics/week-03-grammar-of-graphics.pptx"
  if (!file.exists(template)) stop("No PPTX template found for widescreen page size", call. = FALSE)

  message("Rendering image PPTX: ", slide, " (", n, " slides)")
  capture_html <- prepare_capture_html(html_file)
  shot_dir <- tempfile("slide-shots-")
  dir.create(shot_dir)
  on.exit(unlink(c(capture_html, shot_dir), recursive = TRUE, force = TRUE), add = TRUE)

  ppt <- empty_template(template)
  size <- officer::slide_size(ppt)
  for (i in seq_len(n)) {
    png <- file.path(shot_dir, sprintf("slide-%03d.png", i))
    capture_slide(capture_html, i, png)
    ppt <- officer::add_slide(ppt, layout = "Blank", master = "Office Theme")
    ppt <- officer::ph_with(
      ppt,
      officer::external_img(png, width = size$width, height = size$height),
      location = officer::ph_location(left = 0, top = 0, width = size$width, height = size$height)
    )
  }
  print(ppt, target = output_file)
}

for (slide in slides) {
  if (mode %in% c("html", "both")) render_html(slide)
  if (mode %in% c("pptx", "both")) render_image_pptx(slide)
}

message("Image PPTX render complete")
