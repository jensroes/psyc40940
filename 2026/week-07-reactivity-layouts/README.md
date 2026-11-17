# Week 7 app files

This session continues Week 6 with the same 72 participant means, group selector, and bin-width slider. The core session covers shared reactive preparation and sidebar layouts.

Open `session-guide.html` in a browser and keep it beside the app script in
RStudio. Its contents menu links to the sections named on the slides. The guide
provides instructions and expected behaviours; all app completion code is in
full R scripts. Edit the named scripts and use Run App to test them. No knitting
of the guide, live coding or typing along is required.

- `intro_app.R`: unchanged completed Week 6 example: one histogram, group selector and bin-width slider; no count, boxplot or shared reactive expression.
- `comparison_app.R`: next supplied example, adding boxplot/points and count. Each of its three render blocks repeats the filter; use it to motivate shared preparation.
- `starter_app.R`: Exercise 1, six blanks for one shared reactive filter, three data calls, and two UI output names.
- `layout_app.R`: Exercise 2, five blanks for three layout function names and two explanatory sentences. Its shared-data server is already complete.
- `extension_app.R`: independent optional exercise with five blanks: summary explanation, table UI function, matching server output name, render function and shared-data call. The rest of the sidebar app is complete; finish and test this script directly. Tabs are core in Session 8.
- `optional_groups_app.R`: optional exercise with four blanks for checkboxes, a shared `%in%` filter, the boxplot's group x axis, and help text. The histogram pools the selected groups. The guide explains choices, selected values, and `%in%`, with expected counts of 33, 39, and 72; no conditional branching is needed.

Unzip the whole Week 7 folder into the existing module project. Keep the scripts beside `data/`. Complete a scaffold's blanks before running it; the introduction and reference apps run as supplied. Use Run App for the whole file. After editing code, save, stop the app, and run it again. Keep it running while testing controls.

The data file is copied unchanged from Week 6: `data/participant_reaction_times.csv`. It contains 33 spoken-output participants and 39 written-output participants, one row per participant with their mean reaction time across familiarisation conditions. The group codes are `speech` and `writing`; the unit is milliseconds. Original trial data and preparation remain with the Week 6 materials; no additional wrangling is required here.

Test the app by selecting each group and changing bin width separately. Changing group updates both plots and the count. Changing width affects only the histogram. The boxplot's individual points are spread sideways, not vertically, and no observations are removed. These different participant groups do not support a causal conclusion about output modality.

Exercise 1 includes predicting control changes and repairing a deliberate UI text-output name mismatch. A simple dependency graph accompanies the Week 6 recap; the data/input distinction follows opening intro_app.R. A before-and-after reactivity graph replaces the caching table: trace dependencies to see when filtering repeats and when a cached result can be reused. The graph is also included in the guide; its images are embedded in the HTML session guide. Exercise 2 moves UI elements while keeping the input/output names and server connections intact.

Timing: first 50 minutes—Week 6 recall and familiar histogram graph 7, Week 7 overview/setup 3, familiar histogram/data-input distinction and added views 5, repeated filtering/caching/shared-code explanation 9, Exercise 1 21, graph labels 3 and prediction check 2. Second 50—layout discussion 4, annotated layout 4, Exercise 2 22, test/design comparison 5, optional independent choice 10, close/reading/reference 5. The 20–25 minute exercise allocations include testing. Allow 30–60 seconds for the repeated benefits slide. Take the break after Exercise 1 and its checks; restart with the layout comparison. If setup or debugging takes longer, use the optional slot for core support and leave extensions for independent work after class; do not rush the core checks.

Core dependencies are `shiny` and `tidyverse`, already used in earlier weeks. The session guide explains how to install Shiny once in the RStudio Console if needed. There are no new package requirements for the app exercises.

The optional table uses the same shared filter. Its supplied calculations report count, median and interquartile range; the latter two are in milliseconds. The guide lists all five blanks, explains the UI/render pair and summarise(), and checks group updates, bin-width independence and agreement with the boxplot. No copying into another app is required.

Previous teaching materials are retained under `archive/` in the teaching repository and excluded from the student ZIP.

After completing and testing your own app, use `worked_example_app.R` for comparison, as explained at the end of the guide. Tabs are taught as a core skill in Session 8; Plotly is introduced in Session 9.

The post-Exercise 1 check now includes a three-minute graph-labelling task. A
small server example has two inputs, one shared reactive expression and two
outputs. Students label five supplied boxes/arrows, then compare the solution
on the next slide; the code is repeated alongside the answer. The guide includes
both SVGs and a collapsible answer. There is no extra app script or coding task.
Within the existing five-minute check slot, allow three minutes for labelling
and two for checking predictions against the working app. The UI-name repair
remains in the guide/Exercise 1 testing. The break still follows these checks.

App progression: recall the one-histogram `intro_app.R`, inspect the added views in `comparison_app.R`, then complete shared preparation in `starter_app.R`. The guide and slides mark when to switch; no extra code-completion exercise or live coding is added.

The student ZIP excludes `gfx/`: all guide images are embedded in `session-guide.html`. App scripts need only their supplied data files. Teaching graphics remain in the repository for the slides and guide sources.
