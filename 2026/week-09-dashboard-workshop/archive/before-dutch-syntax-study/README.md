# Week 9: Turn questions into a dashboard

Knit `01_plotly_and_dashboard_workshop.Rmd` first, read its HTML, and edit whole R scripts using Run App.

Core sequence: three Plotly connections in `plotly_app.R`, then a workshop adapting a shared-data/two-tab app to a meaningful question. `starter_app.R` has nine blanks and three sensible question options. Students with ready own data adapt the same pattern; others use `participant_behaviour.csv` and its dictionary in data/README.md.

Complete reference scripts are introduced at the end: `plotly_worked_app.R` for the first task and `worked_example_app.R` for one provided-data question. `extension_app.R` optionally converts both workshop plots to Plotly.

The practice extract has 72 participant means and includes response duration and the supplied vocabulary score. `prepare_workshop_data.R` records its preparation from the original Week 6 data; students do not need to run it. It is a practice option; the assessment requires a suitable dataset whose source and suitability you explain.

Timing: first 50 minutes—Plotly explanation 5, connection exercise 10, plan question/data/views 10, begin adaptation 25. Second 50—continue building/testing 35, compare choices 10, close and next steps 5. Work is completion/modification, not live coding.

At least two Shiny-reactive plots satisfy the assessment interactivity requirement. Plotly is taught as an available tool; the brief does not require its use. No generated UI, observers or controlled-update buttons are compulsory. The previous workshop is archived and excluded from the student ZIP.
