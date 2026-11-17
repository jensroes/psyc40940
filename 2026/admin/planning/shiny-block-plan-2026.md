# Shiny Teaching Approach 2026

Agreed with Jens on 20 October 2026 and aligned with the summative assessment on 29 October. Sessions 6–10 now implement this approach. It replaces the earlier emphasis on observers and generated UI. See the [assessment brief](../assessment-briefs/PSYC40940%20Assessment%20Brief%202026.html) and [grading matrix](../assessment-briefs/PSYC40940%20PG%20Grading%20Matrix%202026.html).

## Scope

Use four taught sessions (Weeks 6-9) and a consolidation/support session (Week 10). Teach a small, connected set of essential functions through progressively more independent app modifications. The assessment requires purposeful user input, at least two interactive plots, and a maximum of three tabs. Shiny-reactive plots meet the interactivity requirement; Plotly is useful but not compulsory.

There is enough content without a catalogue of functions. Reading app structure, connecting controls to plots, sharing data preparation, choosing useful views, explaining the interface, handling invalid selections, and adapting to a new dataset all need practice.

## Teaching Pattern

- Run, inspect, predict, modify, test, then extend a functioning example.
- Do not rely on students typing along with live coding. Demonstrate the finished behaviour, then show a short code pattern on slides before the corresponding task.
- Keep one coherent app progression per week, with a runnable introductory example, full-script practical scaffolds, a worked reference, and an optional extension. In Week 6, introduce the completed reference only at the end of the slides and guide, after students have completed and tested their own app.
- Supply an R Markdown worksheet with instructions and checks, but put all Shiny completion code in full R scripts. Students complete and test those scripts as whole apps, not fragments copied from worksheet chunks.
- Weeks 7–8 supply an HTML-only session guide: open session-guide.html in a browser beside the app R scripts in RStudio. Staff maintain the Rmd sources. Week 6 retains its Knit-first Rmd because the short data-frame/$ task is edited and run there; app changes remain in full R scripts. Week 7 has no separate paste exercise; the supplied count code is explained in context. Reading a guide does not run an app.
- Keep code comments limited to explaining code. Put instructions in Markdown; use `---` for code-completion placeholders in the R scripts. Worksheet chunks may contain setup or short ordinary-R illustrations, but not UI/server completion tasks.
- Separate installation chunks (`eval = FALSE`, run once) from library loading. Keep supplied data preparation out of the main learning task.
- Provide visible expected behaviours and small checks after each change. Teach save, stop, and rerun, matching IDs, commas between UI elements, and locating errors from the beginning.
- Fade scaffolding: complete values and connections, adapt an existing output, add a feature, then transfer to students' own datasets.
- Use two 50-minute blocks. Include short discussion points about app behaviour, interpretation, and design rather than uninterrupted code explanation.

## Explanation Is Part Of App Design

Student apps previously had too little instructional text. Make communication a core requirement, not a polishing exercise.

From Week 6, use `titlePanel()`, `p()`, and `helpText()` to explain the question, data and unit of observation, units, what each control affects, and an interpretative limitation. Later add concise dynamic text with `textOutput()`/`renderText()` to identify the current selection and sample size. Do not confuse developer comments with text that an app user can see.

Ask a peer to use the app without its author explaining it. Can the peer identify the question, operate the controls, tell which observations are shown, and interpret the outputs? More text is not automatically better: put short, relevant explanations near the controls or plots they describe.

## Session Progression

| Week | Core learning | Student outcome | Optional material |
|---|---|---|---|
| 6 | App structure; UI versus server; names; `selectInput()` and `sliderInput()`; `plotOutput()`/`renderPlot()`; `input$...`; static help text | Modify a supplied app so a group selector filters a histogram and a slider changes its bin width; explain both controls | Add a short dynamic selection summary |
| 7 | `reactive()` for shared filtered data; a second useful plot; participant-count text; simple sidebar | Several consistent views of one selection, with clear instructions and units | Summary table |
| 8 | Tabs; control choices; multi-group and range filters; req() and validate(need()) | Two meaningful tabs sharing reliable controls and actionable empty-selection messages; bring a candidate dataset for Week 9 | Pooled/faceted histograms, or a third Summary or Density tab; density radio buttons switch colour/facet views |
| 9 | Plotly output/render pair; transfer to another dataset; purposeful questions and complementary views | A working two-view prototype with clear explanations, filtering and tests | Convert the second plot to Plotly when it helps |
| 10 | Separate report/app structure; package setup; sessionInfo(); extracted-ZIP testing; assessment coverage | A tested reproducible portfolio and specific remaining improvements | Individual project-specific support |

Teach basic automatic reactivity in Week 6. Introduce the `reactive()` function as the solution to duplicated preparation in Week 7, when multiple outputs make the need visible. Do not teach that `reactive()` is necessary for an input to update a plot.

Keep Plotly: converting an existing ggplot is a relatively small extension once students understand matching output/render functions. Teach the complete pair `plotlyOutput()`/`renderPlotly()` plus `ggplotly()`, and what hover/zoom adds. Do not equate interactivity with analytical value or require 3D plots.

Observers, controlled-update buttons, and generated UI are not compulsory milestones. Introduce one pattern only when a real problem motivates it. Use static controls and ordinary reactive outputs where they suffice. Avoid teaching both legacy and alternative event APIs in the introductory sequence.

## Week 6 Draft

Open with explicit session outcomes: explain dashboard purpose and UI/server roles; trace input/output connections; modify and test a selector/slider histogram; add useful app explanations. Required follow-up reading is Mastering Shiny Chapter 1, sections 1.1-1.5. Section 1.6 is optional preparation for Week 7; no book exercises or written reading response are required.

Keep `dplyr::filter()` for the fixed `modality` column. Briefly explain row selection, `==`, unchanged columns, and saving the subset without modifying the source. Wickham's [Chapter 12](https://mastering-shiny.org/action-tidy.html) addresses indirection when an input supplies a column name, plus data-masking collisions (e.g. an uploaded column named `input`). These do not require replacing the current value-based filter with base indexing. The same filter can move into a shared `reactive()` in Week 7. If later apps let users choose columns, introduce `.data[[input$variable]]` for that specific need; use `.env$input` when disambiguating environment input from data columns. Do not teach tidy evaluation in Week 6 or describe tidyverse functions as incompatible with Shiny.

Introduce UI/front end, server/back end, and the dependency-based update model in Week 6, after exploring real dashboards and before code examples. Contrast running an ordinary sequential R script with defining reactive relationships. R remains the same language; Shiny supplies the framework. Distinguish this foundational idea from the `reactive()` function, which remains the Week 7 shared-preparation topic. Show the concrete flow: group selector in UI, filtering/plot generation in server, updated histogram in UI.

Use supplied participant-level means from the familiar spell-name data. One row represents one participant and output modality; means are across familiarisation conditions. Distinguish participant means from trial-level reaction times and avoid causal claims about the groups.

First block (50 minutes): introduce dashboards and explore real-world examples with brief contributions (10); run the minimal app, explain its server function, and introduce $ with a direct data frame (12); inspect the selector/name/filter pattern (5); complete the selector and filtered plot (15); check behaviour (3); retain five minutes for setup or questions (5). Keep the opening activity focused: three minutes exploring, then a sentence or two from a couple of groups about what the dashboard shows and what a control changes. The aim is familiarity with dashboards, not a formal report or design critique. If discussion runs long, demonstrate the deliberate name mismatch together rather than having every student reproduce it. The debugging slide follows Exercise 1 and supports its shared check.

Run the minimal app before teaching function syntax. Explain its actual server <- function(input, output) as instructions that Shiny calls when a user opens the app, with input/output supplied as arguments. Keep functions distinct from reactivity: functions organise instructions, while Shiny tracks dependencies and updates dependent render calculations. Changing a control does not rerun the whole server. There is no separate function-writing exercise; the optional task extends the app with a dynamic summary.

Introduce $ using a data frame constructed directly as example_data, with two columns and five rows. Students complete example_data$--- to select the original numbers. Do not construct it via a function or call it output: this avoids suggesting that the server returns a data frame. Shiny's input/output are special named objects, not data frames; distinguish reading a control value from assigning a render function to an output.

Teach each stage as guided modification: Together (explain and trace a working example), Your turn (predict, complete, and test a small change), Together (check behaviour and discuss errors). The slides and worksheet label these roles for the minimal app, named-part access, the selector, and the slider. Avoid a long demonstration followed by an uninterrupted worksheet; retain regrouping points before moving on.

Lead the opening dashboard activity from the slides, which contain the direct links and two simple prompts; no separate handout is needed. Examples are OECD Well-being Data Monitor, ONS UK well-being, UKHSA public health, and Our World in Data's population explorer. Briefly establish what a dashboard shows and how a reader can change its view before introducing Shiny. The OECD source repository confirms an R/Shiny implementation; do not imply all examples use Shiny. Frame the assessment as a smaller focused app, not a recreation of a production dashboard.

Second block (50 minutes): explain bin-width effects (5), inspect the slider-to-geom pattern and explanatory app text (8), complete and test the slider plus app explanations and compare help text with a neighbour (25), troubleshoot and check behaviour together (7), recap and introduce the reading and dataset exploration (5). The dynamic summary is optional, for spare time or independent practice. Closing optional slides explain the task and introduce paste() with a worked example and a completion blank.

Begin with the complete, runnable `minimal_app.R`: one number input, a text output, and a two-argument `server <- function(input, output)`. Explain matching names and how an input changes an output before introducing the data app. Omit the unused `session` argument from all Week 6 student app examples.

Use full-script scaffolds for the practical: `starter_app.R` has three connection blanks for a group-filtered histogram; `slider_app.R` has five blanks for the second control, an introductory paragraph, and control help. Students locate temporary messages in the running app before refining their wording. Students complete that stage's blanks, then save and run the whole script. The Rmd supplies instructions and checks, not code fragments to copy or test in isolation. The minimal app is the introductory example; introduce the completed reference only at the end, for comparison after students have completed and tested their own app. Do not expect students to invent the UI/server skeleton from scratch.

## Week 7: Shared Data And Clear Layouts

Use `week-07-reactivity-layouts` and `psyc40940-week-07-reactivity-layouts.zip`. Begin with one diagnostic recap slide showing the Week 6 UI/server excerpts side by side: trace the input and output names and predict a control change. No completion of the optional summary is assumed.

Use the same 72 participant means and two controls. intro_app.R repeats the completed Week 6 histogram only; comparison_app.R then adds the boxplot and count with repeated filtering; starter_app.R has six blanks for shared preparation and output connections; layout_app.R has five blanks for sidebar functions and two explanations. Open the supplied session-guide.html in a browser; the Rmd is retained for staff only. Move directly from repeated filtering to cached shared preparation. Explain paste() briefly beside the supplied count code.

Apply the Session 6 delivery notes: students understood the general app logic, so reduce repeated explanation. Use one annotated shared-filter/server example to connect reactive(), selected_data(), the histogram and the count. Explain that parentheses obtain the result without introducing a separate ordinary-function example. Keep it available during the exercise. Explain quoted UI names as text keys matched to input/output references, and use students' responses to decide when to revisit a point.

First 50 minutes: Week 6 recall/histogram graph 7; Week 7 overview/setup 3; familiar histogram/data-input distinction and added views 5; repeated filtering/caching/shared-code explanation 9; Exercise 1 21; graph labels 3 and prediction check 2. Second 50: layout discussion 4; annotated layout 4; Exercise 2 22; test/design comparison 5; optional independent choice 10; close/reading/reference 5. Exercise allocations include testing. Treat the repeated benefits slide as a quick recap. Use optional time for core support if needed. In Exercise 1, predict and test changes, then deliberately mismatch and repair a UI text-output name. In Exercise 2, trace the unchanged names after moving UI elements. No live coding.

Introduce the completed reference only at the end. Offer two independent optional exercises: checkboxes and a shared `%in%` filter to compare both groups in the boxplot while pooling the histogram (`optional_groups_app.R`, four blanks), or completing five blanks for the supplied `summarise()` table (`extension_app.R`): explanation, table UI function, matching output name, render function and shared-data call. Complete and test that supplied app directly rather than copying code into another script. No pipes or conditional branches are needed in these student examples. Neither optional task is required to finish the core session. Tabs are core in Week 8. Required reading is Mastering Shiny section 1.6; section 6.2 is optional layout reference.

Week 7 now uses the existing five-minute post-exercise check for a three-minute
five-box labelling task and two-minute behavioural check. The simple server
has modality and binwidth inputs, one shared reactive expression, a histogram
and a count. Supplied arrows distinguish shared-data and direct plotting
dependencies; the next slide repeats the code with the answer. Keep the UI-name
repair in Exercise 1 testing rather than adding a new timed activity.

Week 8 implements the next step: students draw the complete core graph after
checkpoint B, using their completed controls_app.R. Three minutes drawing plus
one minute checking replace the former four-minute recovery recap. Recovery
is tested within checkpoint B; no extra core minutes or new app script are added.
Checks stay inside the shared expression; tabs/static data do not add nodes.

## Week 8: Tabs And Reliable Controls

Use `week-08-tabs-controls` and `psyc40940-week-08-tabs-controls.zip`. Old materials are archived. Source renames must also migrate matching deployment records; no active Week 8 records existed at this rename.

Begin with the completed Week 7 sidebar app and its dependency graph before setup. intro_app.R is identical to that app. starter_app.R has five UI blanks for tabsetPanel, two tabPanel calls and two explanations; its server and plots stay unchanged. The tab-placement graph preserves the dependencies and marks output locations. Keep shared controls/count outside tabs.

Revisit checkboxes and %in% in a five-minute pre-break prediction/check, since most students completed Week 7's optional groups task. Keep the full guide explanation available for students who need it. Explain the UI name groups versus the data column modality. After the break, use a two-value vocabulary-score slider and extend the graph: groups/vocabulary range select participants for the reaction-time plots; bin width feeds only the histogram.

controls_app.R has two runnable checkpoints. A completes four active blanks (checkbox function, input name, two range indexes); validation remains commented. Students test valid selections and observe an empty result. B uncomments the four-line validation block and fills two further blanks (filtered data frame and recovery message). Explain supplied req(input$vocab_range) briefly in context; validate(need(nrow(selected)>0,message)) is the core feedback lesson. Preserve selected as the final expression. Do not silently stop on cleared groups.

First 50: recap/setup 7, tabs walkthrough/graph/structure 8, Exercise 1 20, check/design choice 5, checkbox/%in% recap 5, flexible support 5. Break. Second 50: range/graph 6, checkpoint A 12, empty-selection discussion 3, shared validation explanation 7, checkpoint B 13, supplied-box graph completion/check 4, close/reading/reference 5. Checkpoint allocations include testing. One recommended optional exercise is sufficient: density curves with a colour/facet control (roughly 10–15 minutes for early finishers or after class). Other examples are alternatives/reference. Five flexible minutes do not guarantee completion of the extension; protect core validation and testing.

The range app explicitly separates groups on the boxplot's x axis while pooling the histogram. Optional choices compare pooled versus faceted histograms or add a third group-summary tab. The extension uses nested summarise/group_by calls, without pipes. Other control types are optional reference, not new required skills. Generated UI remains outside the core; Week 9 adds Plotly/adaptation and Week 10 protects reproducibility/project support. Read Mastering Shiny 6.3.1 and 8.1.4. Three tabs is a maximum, not a target.

## Week 9: Turn Questions Into A Dashboard

Teach the Plotly pair and conversion briefly: plotlyOutput, renderPlotly, ggplotly. plotly_app.R has three connection blanks and uses the familiar Week 8 data/filters. Plotly is an available tool; Shiny-reactive plots already satisfy the assessment requirement.

Most time is for transfer. Own-data-ready students adapt their own tidy dataset and question. Others use starter_app.R with a prepared longitudinal sentence-production extract from van Lieburg et al. (2023). Seventeen learners contribute 492 participant/session/prompt/phase summaries; each cell contains four target trials. Nine gaps cover filename, three overview mappings, two axis labels and three explanations. Supplied shared filtering selects a prompt condition, phases and session range. Compare mean percentages with individual lines or a genuine commented heatmap alternative. Staff supply the raw-data preparation; no research model fitting is required. The extract is practice, not a portfolio answer.

First 50: Plotly explanation 5, connection task 10, question/data/view plan 10, adaptation 25. Second 50: build/test 35, compare design choices 10, close 5. Students should leave with one behavioural question, two complementary reactive views, clear controls and explanations, and a recorded design decision in their own words.

Completed examples are introduced at the end. Converting the second view to Plotly is optional. Generated UI, observers, update buttons and variable selectors are project choices, not extra compulsory features.

## Week 10: Reproduce And Review The Portfolio

Provide a runnable submission-example project with one report.Rmd, rendered HTML, Rproj, bibliography, data and app/app.R, continuing the same sentence-production study. Four static techniques show mean change, distributions with points, a learner heatmap and response-composition bars. Captions, cross-reference, source citation, inline calculated counts, package setup and report sessionInfo() demonstrate reproducibility. Keep the commentary/reflection prompts: this is not a model assessment answer. The report reads prepared summary and trial files; the app uses summaries. Default percentages include all recorded target trials; the article's binary analysis denominator differs and is explicitly documented.

Practise the working-directory distinction: the report imports data/ from the project root; app/app.R imports ../data/ from the app folder. Students run the whole app, not source fragments.

First 50: requirements/structure 10, run example and trace paths/packages 10, extracted-ZIP exercise 20, identify remaining issues 10. Second 50: individual work/support 35, coverage/reflection review 10, close 5.

The actual assessment ZIP contains exactly one Rmd and rendered HTML (PDF with good reason), the existing Rproj, separate app, data/supporting files, clear package setup and package/version summary. Data access instructions/import/preparation code are needed where data cannot be included. Check anonymity and the required AI declaration. The teaching ZIP is not a ready-made assessment submission.

Check four distinct useful static plot types, at least two interactive plots, meaningful inputs, at most three tabs, data source/unit/limitations, and original reflection/commentary. Word limit 2,000 covers written text, figure commentary/captions, dashboard explanatory text and reflection; code/references/raw output/data contents are excluded. Use the current brief for authoritative details.

Testing must use a newly extracted copy and fresh R session. Retain individual support time and aim for working report/app before the winter break.

## Validation And Distribution

Keep scripts and data together. Each session has a session guide (HTML-only for students in Weeks 7–8) and self-explanatory full R scripts. Use --- for code completion. Instructions stay in Markdown; comments explain code. Completed reference apps are introduced at the end. Preserve old exercises in archive/ and exclude them from student ZIPs.

check_week07_shiny.R tests core group/count/plot behaviour and its optional table and guide knitting. check_shiny_assessment_core.R completes temporary scaffolds and tests tabs, shared validation, empty-path recovery, Plotly outputs, workshop plots and the separate example app. Also render the report and test an extracted project in fresh R. Render HTML and rebuild student ZIPs; defer PPTX until requested.

## Sources And Follow Up

- [Wickham, Mastering Shiny, Chapters 1-3](https://mastering-shiny.org/basic-app.html): app structure, UI, direct reactivity, and reactive expressions.
- [Chapter 4](https://mastering-shiny.org/basic-case-study.html): build a simple prototype and extend it.
- [Chapter 8](https://mastering-shiny.org/action-feedback.html): explain and handle invalid user choices.
- [Chapter 10](https://mastering-shiny.org/action-dynamic.html): use dynamic UI sparingly and choose the simplest suitable mechanism.
- [Shiny helpText documentation](https://shiny.posit.co/r/reference/shiny/latest/helptext.html): explanatory context alongside controls.
- Jens identified Andrews' Shiny chapter as a useful model for instructional app text. The chapter PDF URL in the current decks returns 404; locate a working edition/link before presenting it as a verified reading resource.

The revised Sessions 7–10 implement this scope. Check dataset values against slide examples and keep the learning-room descriptions and schedule aligned. Keep the four taught sessions aligned with the assessment rather than requiring advanced features to demonstrate progress.

## Guide distribution update: Weeks 7 and 8

Distribute session-guide.html only, authored by Jens Roeser. Students open it
in a browser and edit/run the app R scripts in RStudio; they do not knit the
guide. Keep session-guide.Rmd as the staff source in each week, without body
bold emphasis. Build with 2026/scripts/render_session_guides.R. Each HTML is
self-contained, including guide CSS and images. Do not include the guide Rmd,
old generated guide HTML, guide CSS or gfx/ in the student ZIPs. Week 6's Rmd contains
a short ordinary-R exercise and is unchanged by this Week 7/8 update.
