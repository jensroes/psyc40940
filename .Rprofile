# Make rmarkdown rendering work in environments where pandoc is bundled
# with RStudio/Quarto but is not on PATH.
if (!nzchar(Sys.getenv("RSTUDIO_PANDOC")) && !nzchar(Sys.which("pandoc"))) {
  pandoc_candidates <- c(
    "/usr/lib/rstudio/resources/app/bin/quarto/bin/tools/x86_64",
    "/usr/share/positron/resources/app/quarto/bin/tools/x86_64",
    "~/opt/quarto-1.7.31/bin/tools/x86_64"
  )

  pandoc_dirs <- path.expand(pandoc_candidates)
  pandoc_dirs <- pandoc_dirs[file.exists(file.path(pandoc_dirs, "pandoc"))]

  if (length(pandoc_dirs) > 0) {
    Sys.setenv(RSTUDIO_PANDOC = pandoc_dirs[[1]])
  }
}
