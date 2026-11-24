# Slide rendering

Use `render_slides.R` to render the 2026 slide decks to HTML, image-only PPTX, or both.

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

PPTX output now uses the HTML screenshot workflow. The script renders the HTML deck if needed, opens each ioslides slide with headless Chrome, captures a 16:9 PNG screenshot, and builds a PowerPoint deck with one full-slide image per slide. This preserves the appearance of the HTML slides for students who need PowerPoint access.

Because these PPTX slides are screenshots, the content is visually faithful but not editable as PowerPoint text. Incremental build items are forced visible before screenshots are taken.

## Assessment-aligned Shiny checks

Run Rscript 2026/scripts/check_week07_shiny.R for shared data, the optional table and staff-source HTML rendering. Run Rscript 2026/scripts/check_shiny_assessment_core.R for completed Week 8/9 scaffolds, empty-selection recovery, Plotly connections and the separate Week 10 example app. The practice report is rendered separately and tested from an extracted ZIP. Student archives exclude archive/ and retain current guides, scripts and their data.

## Sentence-production teaching data for Weeks 9 and 10

Run `Rscript 2026/scripts/prepare_dutch_syntax_teaching_data.R` from the repository
root to rebuild the documented trial and participant-summary extracts. Raw public
source files and checksums are retained in `2026/datasets/dutch-syntax-2023/`.
Students receive ready CSVs, not a new data-wrangling assignment.

`Rscript 2026/scripts/render_dutch_syntax_examples.R` updates the three preview
figures used in the Week 9 deck. The existing core checks now verify the new
workshop scaffold, trial-to-summary percentages, both individual-view options
(including outer heatmap tiles), Plotly and the separate Week 10 app.

Weeks 9 and 10 use the same HTML-only session-guide workflow as Weeks 7 and 8.
Guide Rmd sources and graphics stay with the teaching sources; images are embedded
in the HTML. Week 9 gives the one-time Plotly installation command directly in the guide and slides.
Week 10 still includes report.Rmd because reproducing that report is an exercise.
The example report uses the supplied APA CSL file. Render the guides, example report
and HTML slides after changing data; defer PPTX until requested.

## Browser session guides for Weeks 7 to 10

Run `Rscript 2026/scripts/render_session_guides.R` to build all four guides, or add
one or more week numbers (`7`, `8`, `9`, `10`). Each week's `session-guide.Rmd` is
the staff source; the command writes self-contained `session-guide.html` beside it.
Share the HTML directly on NOW and include it in the student ZIP. Guide sources
and gfx/ assets are excluded from student ZIPs; report exercise sources remain.
Guides credit Jens Roeser and use regular-weight text without Markdown bold emphasis.

## Assessment submission guides

Run `Rscript 2026/scripts/render_submission_guides.R` to render the formative
and summative submission guides in `2026/assessment-submission-guides/`.
Add `formative` or `summative` to build one. Distribute the self-contained HTML;
Rmd sources and shared CSS are for maintenance. The folder README records the
brief alignment and checks needed before future-year reuse.

## Week 10 continuation after Week 9 progress

`Rscript 2026/scripts/check_week10_continuation.R` tests the one-plot fallback and completes the actual tasks from the Week 10 guide in an extracted student ZIP. It checks both controls, shared selections, both plots and recovery. Week 10 protects 75 minutes for app continuation; detailed report and ZIP exercises are independent practice rather than extra class tasks.

`Rscript 2026/scripts/check_summative_starter.R` extracts the standalone starter ZIP, renders it without data, and checks the single bibliography entry, citation, four captioned figure chunks and a completed example figure cross-reference. Build the ZIP first with `python3 2026/scripts/package_workshop_materials.py`.
