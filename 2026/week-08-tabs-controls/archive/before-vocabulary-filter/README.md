# Week 8: Tabs and reliable controls

Active folder: `week-08-tabs-controls`. Slide source and output files use the same stem; student download: `psyc40940-week-08-tabs-controls.zip`. The earlier materials are retained under `archive/` and excluded from the download. Any future source rename must migrate its matching `rsconnect/documents/` records too; there were no active Week 8 publishing records when this rename was made.

Start before Week 8 setup with the completed Week 7 app and a familiar reactivity graph. The recap graph, tab-placement graph and expanded group/range graph use the Week 7 visual style. Each adds one point: recall dependencies, preserve them while moving outputs, then extend them with another input. Do not walk through the same server code repeatedly.

Knit `01_tabs_and_reliable_controls.Rmd` first; read its HTML beside the app scripts. Use Run App for whole scripts. Instructions live in Markdown; completion code is in R scripts and uses `---` blanks. No live coding or typing along is required.

- `intro_app.R`: identical to the completed Week 7 sidebar app, including its server and plots.
- `starter_app.R`: five blanks for three tab functions and two explanations. Only the UI changes; the plotting/server code remains identical.
- `controls_app.R`: checkpoint A has four active blanks for group/range filtering. Checkpoint B enables a commented validation block and completes its two blanks. The commented facet line belongs to optional practice, not checkpoint B.
- `worked_example_app.R`: completed two-tab reference, introduced only at the end.
- `extension_app.R`: optional completed example with a third summary tab and pipe-free `summarise()` code.

Keep `data/` beside the scripts. The unchanged participant CSV contains 72 means: 33 speech and 39 writing. Checkboxes and `%in%` are core today even though some students tried them optionally in Week 7. Explain the UI name `groups` versus the data column `modality`.

Timing, two blocks of 50 minutes: first block—recap/setup 7, tabs discussion/graph/structure 8, Exercise 1 20, check/design choice 5, checkbox and membership introduction 10. Take the break after the checkbox example. Second block—empty-selection discussion 3, range and dependency graph 6, checkpoint A 12, shared validation explanation 4, checkpoint B 13, recovery checks 7, close/reading/reference 5. Each checkpoint allocation includes its tests. Optional tasks use early finishes or independent work after class; core support takes priority.

Keep `req(input$rt_range)` supplied and explain it briefly with the shared expression; validation is the main feedback lesson. Do not silently stop on cleared groups. Test 72/33/39 counts, narrower ranges, no groups, an empty 2350–2400 range, restoration, control persistence and bin-width-only updates.

The core histogram pools groups, while the second plot separates groups on its x axis. Optional practice compares pooled versus faceted histograms for different reading questions, or adds a third summary tab. Other control types are an optional reference. Generated UI, controlled updates and observers are not core content. Week 9 teaches Plotly and adaptation; Week 10 protects reproducibility and project-support time.

Read *Mastering Shiny* sections 6.3.1 and 8.1.4. Tabs are part of the core assessment skill set; three is a maximum, not a target. Do not add required functions merely to fill time.
