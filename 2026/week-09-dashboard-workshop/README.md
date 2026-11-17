# Week 9: Turn questions into a dashboard

Use session-guide.html in a browser. Students edit whole R scripts and use Run App; they do not knit the guide or type along with live coding. The current student ZIP is built with 2026/scripts/package_workshop_materials.py, using an explicit file list that excludes archives, guide sources and gfx/.

Core files:

- plotly_app.R and plotly_worked_app.R: three Plotly connections on the dense trial-level timing scatterplot; hover and zoom inspect local detail without changing selected counts.
- supplied_data_app.R: runnable empty UI/server/sidebar/two-tab outline for supplied data. Five code-block markers identify two controls, shared preparation and two plots. NULL results keep unfinished outputs empty. Students also write two tab explanations.
- own_data_app.R: generic outline for a student's chosen dataset, controls and plot types; complete the import before running.
- reactivity-graph-template.svg: blank inputs/reactivity/outputs template, also embedded in the HTML guide. Students add names, arrows and tab labels using PowerPoint, Word or paper.
- worked_example_app.R: completed small core, with sentence-condition checkboxes, one phase selector, one shared reactive filter, a mean plot and individual paths.
- extension_app.R: the same core with both plots converted to Plotly; compare only after an attempt.

Route A uses the student's own dataset and chosen question, plots and controls. Route B supplies a short data description and input/output requirements; students draw a graph before implementing those connections. The guide provides specific code tasks and borrowing references to Weeks 6–8. Study methods and research findings are not required.

Start with two plots, two tabs and two controls. After the core works, students choose one useful addition: a vocabulary-range slider, a faceting checkbox affecting only the average plot, or Plotly conversion. The first two are alternatives for a third control. No count output, SE calculation, layout-switching system or heatmap is required by the core.

Timing: first 50 minutes—setup 5, Plotly explanation/exercise 15, purpose/tab/control/graph planning and brief class feedback 20, begin implementation 10. Second 50—continue building/testing 35, Exercise 5 feedback from another student, refinement and retesting 10, close 5. Two working plots and controls are the target; retain a runnable partial app and a clear next step if unfinished. Optional additions use early finishes or independent work; do not compress core support to reach them.

General portfolio resources, full submission requirements, AI declaration and submission-guide walkthrough are in Week 10. Retain only the app-planning constraints needed here. Do not regenerate PPTX until requested.

The supplied study app uses data/participant_rates.csv. With all three conditions and phase Before, there are 246 summary rows; After also has 246. Baseline alone in either phase gives 82. Clearing conditions triggers shared recovery feedback; both plots recover when conditions are restored. Repeated rows are not additional learners.

The Plotly task uses data/trial_reaction_times.csv: 8,648 trials from 72 participants, prepared by 2026/scripts/prepare_week09_plotly_trials.py. Source trials are retained without additional exclusions. The other workshop data are prepared by 2026/scripts/prepare_dutch_syntax_teaching_data.R. Students receive ready CSVs, not the preparation scripts.

Older complex starter/reference versions are retained under archive/before-small-scaffold/. The former study-specific slide teaching belongs in the guide/data dictionary rather than whole-class presentation. Active RPubS document paths remain unchanged.

Purpose-first sequence: after Plotly, use ten minutes for the overall exploratory question, tab roles and reasons for two controls, then five minutes for the preliminary graph. Preview ggplots outside Shiny before wiring controls/shared preparation; add descriptions, test predictions and revise. First checkpoint is a purpose/graph/working plot, not an expectation that every app is complete. Between sessions students confirm their own data, develop the prototype and start a rendered static-report draft. Week 10 protects report review and submission guidance while allowing unfinished app work during support.
