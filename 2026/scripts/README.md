# Slide rendering

Use `render_slides.R` to render the 2026 slide decks to HTML, PPTX, or both.

From the repository root:

```bash
Rscript 2026/scripts/render_slides.R html
Rscript 2026/scripts/render_slides.R pptx
Rscript 2026/scripts/render_slides.R both
```

To render one deck only:

```bash
Rscript 2026/scripts/render_slides.R pptx 2026/week-02-foundations/week-02-foundations.Rmd
```

The script uses the RStudio-bundled Pandoc path when Pandoc is not on the shell `PATH`. For PPTX output it creates a temporary cleaned RMarkdown file, removes HTML-only helper chunks, flattens simple HTML tags, allows HTML-only output where needed, renders with `rmarkdown::powerpoint_presentation()`, and lightly scales PPTX fonts down to reduce overflow.

PPTX output is a convenience export from HTML-first slide sources. Slides with HTML-specific layout, HTML tables, or complex CSS should still be checked after rendering.
