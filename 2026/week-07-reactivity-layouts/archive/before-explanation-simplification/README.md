# Week 7 app files

This session continues Week 6 with the same 72 participant means, group selector, and bin-width slider. The folder retains its previous name, but observers and update/reset buttons are not part of the revised core session.

Open `01_shared_data_and_layout.Rmd` in RStudio and click Knit before starting. Read the HTML guide beside the app script; its contents menu links to the sections named on the slides. The supplied HTML version is also available for reading. The worksheet explains every stage and provides expected behaviours. All Shiny completion code is in full R scripts, not worksheet chunks. Edit the named R scripts and use Run App, not Knit, to test them. no live-coding or typing-along is required.

- `intro_app.R`: runnable flat-layout example with a histogram, boxplot/points, and count. Each render block repeats its filtering.
- `starter_app.R`: Exercise 1, six blanks for one shared reactive filter, three data calls, and two UI output names.
- `layout_app.R`: Exercise 2, five blanks for three layout function names and two explanatory sentences. Its shared-data server is already complete.
- `extension_app.R`: optional worked example with a summary table. Tabs are taught as core content in Session 8.

Unzip the whole Week 7 folder into the existing module project. Keep the scripts beside `data/`. Complete a scaffold's blanks before running it; the introduction and reference apps run as supplied. Use Run App for the whole file. After editing code, save, stop the app, and run it again. Keep it running while testing controls.

The data file is copied unchanged from Week 6: `data/participant_reaction_times.csv`. It contains 33 spoken-output participants and 39 written-output participants, one row per participant with their mean reaction time across familiarisation conditions. The group codes are `speech` and `writing`; the unit is milliseconds. Original trial data and preparation remain with the Week 6 materials; no additional wrangling is required here.

Test the app by selecting each group and changing bin width separately. Changing group updates both plots and the count. Changing width affects only the histogram. The boxplot's individual points are spread sideways, not vertically, and no observations are removed. These different participant groups do not support a causal conclusion about output modality.

Core dependencies are `shiny` and `tidyverse`, already used in earlier weeks. The worksheet has a run-once Shiny installation chunk if needed. There are no new package requirements for the app exercises.

The optional table uses the same shared filter. The supplied table reports count, median, and interquartile range; the latter two are in milliseconds.

The previous layout/observer sequence is retained in `archive/previous-layout-observers/` in the teaching repository and excluded from the student ZIP.

After completing and testing your own app, use `worked_example_app.R` for comparison, as explained at the end of the guide. Tabs are taught as a core skill in Session 8; Plotly is introduced in Session 9.
