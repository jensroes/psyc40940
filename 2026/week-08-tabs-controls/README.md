# Week 8: Tabs and reliable controls

Active folder: `week-08-tabs-controls`. Slide source and output files use the same stem; student download: `psyc40940-week-08-tabs-controls.zip`. The earlier materials are retained under `archive/` and excluded from the download. Any future source rename must migrate its matching `rsconnect/documents/` records too; there were no active Week 8 publishing records when this rename was made.

Start before Week 8 setup with the completed Week 7 app and a familiar reactivity graph. The recap graph, tab-placement graph and expanded group/range graph use the Week 7 visual style. Each adds one point: recall dependencies, preserve them while moving outputs, then extend them with a vocabulary-score input that is not mapped to the plot axes. Do not walk through the same server code repeatedly.

Open `session-guide.html` in a browser and read it beside the app scripts in RStudio. No knitting of the guide is needed. Use Run App for whole scripts. Instructions live in Markdown; completion code is in R scripts and uses `---` blanks. No live coding or typing along is required.

- `intro_app.R`: identical to the completed Week 7 sidebar app, including its server and plots.
- `starter_app.R`: five blanks for three tab functions and two explanations. Only the UI changes; the plotting/server code remains identical.
- `controls_app.R`: checkpoint A has four active blanks for group/range filtering. Checkpoint B enables a commented validation block and completes its two blanks. The commented facet line belongs to optional practice, not checkpoint B.
- `worked_example_app.R`: completed two-tab reference, introduced only at the end.
- `extension_app.R`: optional completed example with a third summary tab and pipe-free `summarise()` code.
- `optional_density_app.R`: seven blanks for a third density tab, radio buttons, output/render connection, shared data, and colour/fill mappings. Compare a pooled curve with grouped curves; supplied checks require two observations per curve.
- `optional_histogram_app.R`: four blanks for an explanatory paragraph, checkboxInput, shared data and facet_wrap. The supplied conditional code adds facets when checked; the task retains two tabs. Summary and Density are alternative third tabs.

Keep `data/` beside the scripts. The participant CSV keeps the same 72 reaction-time means (33 speech, 39 writing) and adds `vocabulary_score` from the original `ppt_vocab`. The score is constant per participant and is rounded to four decimal places. Observed scores span 0.8125–1.0000; the slider spans 0.80–1.00. Both groups with range 0.90–0.95 give 19 participants; 0.80–0.81 gives none. The data dictionary and `2026/scripts/prepare_week08_vocabulary.R` document preparation. Checkboxes and `%in%` are core today even though some students tried them optionally in Week 7. Explain the UI name `groups` versus the data column `modality`.

Timing, two blocks of 50 minutes: first block—recap/setup 7, tabs walkthrough/graph/structure 8, Exercise 1 20, check/design choice 5, checkbox/membership recap 5, flexible support 5. Take the break after the checkbox recap and any needed checks. Second block—vocabulary range and dependency graph 6, checkpoint A 12, empty-selection discussion 3, shared validation explanation 7, checkpoint B 13, independent graph completion/check 4, close/reading/reference 5. Each checkpoint allocation includes its tests. The core has 95 planned minutes and five flexible minutes; support takes priority. Keep checkboxes to a quick prediction/check for students who completed Week 7's task, with the full guide explanation available to others.

One substantial optional exercise is enough: offer the pooled/group density comparison or the histogram-faceting checkbox, allowing roughly 10–15 minutes for completion, testing and explanation. This is an estimate, not extra core time. Early finishers can start it; five spare minutes may only let others begin. Remaining work can continue after class. The histogram and summary examples remain independent alternatives/reference, not extra tasks everyone should finish. Do not compress validation or testing to reach optional content.

Keep `req(input$vocab_range)` supplied as a defensive startup guard. Explain req/need/validate together, the consequences of omitting checks, and their position inside one reactive node. The fixed slider normally has a default; validation supplies the visible recovery feedback. The added graph expands the shared expression without introducing new reactive nodes. Do not silently stop on cleared groups. Test 72/33/39 counts, narrower ranges, no groups, an empty 0.80–0.81 range, restoration, control persistence and bin-width-only updates.

The core histogram pools groups, while the second plot separates groups on its x axis. Optional practice compares pooled versus faceted histograms for different reading questions, or adds a third summary tab. Other control types are an optional reference. Generated UI, controlled updates and observers are not core content. Week 9 teaches Plotly and adaptation; Week 10 protects reproducibility and project-support time.

Read *Mastering Shiny* sections 6.3.1 and 8.1.4. Tabs are part of the core assessment skill set; three is a maximum, not a target. Do not add required functions merely to fill time.

Bring a dataset to Week 9, with import code, source and an exploratory question. A candidate is fine; supplied practice data are a backup. The optional density input changes only its plot; group/vocabulary filters affect all views, while bin width affects only the histogram.

After Exercise 2B, students complete seven supplied empty boxes using their
completed controls_app.R: three inputs, one shared expression and three outputs.
They add names and the six direct dependency arrows themselves. Allow three minutes to complete and one to check
the next slide. The guide has the task and a collapsible answer. This replaces
the former four-minute repeated recovery check; recovery tests stay in
checkpoint B's thirteen minutes. req/filter/validate are inside the shared node;
tabs and static data do not add nodes. No extra script or coding task is added.

The student ZIP excludes `gfx/`: all guide images are embedded in `session-guide.html`. App scripts need only their supplied data files. Teaching graphics remain in the repository for the slides and guide sources.

The density extension compares pooled versus grouped curves using colour and fill;
the histogram extension adds a user-controlled faceting checkbox.
Keep the core checkbox teaching concise for this group. The extension contrasts
filters (which observations) with a display control (how the same observations
are shown), asks students to compare overlap and shape, and adds the new input
and density output to their graph. Seven blanks remain; conditional code is
supplied. Histogram and summary tasks remain alternative independent practice.

## Release review: 9 November 2026

Checked the guide against the exercise scripts: Exercise 1 has five active
blanks; Exercise 2A has four active blanks and two commented blanks reserved
for 2B; the recommended density extension has seven. Instructions now state
the app-building goal and leave direct function-name hints in collapsible
sections. Tasks include explanations, predictions, design choices and tests,
rather than code completion alone. Keep the existing gaps; no extra functions
are needed to increase difficulty.

The existing Shiny checks passed through Week 8, covering the completed tab
scaffold, valid group/range selections, empty results before validation,
recovery after validation, faceted histograms, summary tables and independent
density-display controls. The guide remains self-contained HTML with author,
references and embedded figures. Updated the NOW description to reflect the
current sequence and recommended extension. PPTX generation was requested on
9 November; distribute the reviewed deck and refreshed student ZIP.

Completed optional answers for Jens are in `answers/`: density colour/facet comparison, faceted histogram, and summary table. Run each script as an app from that folder; its data path is `../data/participant_reaction_times.csv`. Exclude the entire answers folder from student ZIPs.

Optional-task revision: density now contrasts one pooled curve with separate group curves using colour and fill; it has no faceting branch. The separate histogram exercise now uses optional_histogram_app.R with a user-facing faceting checkbox, rather than merely uncommenting a line. Earlier review notes describing colour/facet densities are superseded by this version. Keep answers/ excluded from all student ZIPs.
