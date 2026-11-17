# Week 6 app files

The real-world dashboard discussion is led from the slides in class. App code is in complete R scripts; `01_read_and_modify_a_shiny_app.Rmd` contains instructions and checks, not Shiny code snippets to complete.

Start by running the minimal app, then explain its server as a function Shiny calls. A small data frame constructed directly in the Rmd introduces `$` before tracing the input/output connections. Each core stage labels what we inspect together, what you modify and test, and what we check together. The optional extension adds a dynamic summary to the app.

Open the `01_` Rmd in RStudio and click Knit before starting. Read the HTML guide, using its contents menu to find the sections named on the slides. Edit the Rmd for the `$` example, and the named R scripts for the apps; the HTML is for reading. Unfinished chunks are skipped when knitting, so the original guide knits before the blanks are filled. Run completed Rmd chunks interactively to see their results.

- `minimal_app.R`: runnable introductory example showing a number input and matching text output.
- `starter_app.R`: Part 1 scaffold; complete three blanks connecting a group selector to a histogram.
- `slider_app.R`: Part 2 scaffold; complete five blanks for the slider, an introductory paragraph, and control help. Locate the text in the running app before refining its wording.
- `extension_app.R`: optional dynamic selection summary.

Open an app file and choose Run App. Complete a scaffold's blanks before running it; the minimal app runs as supplied. Keep the `data/` folder beside the scripts. Save, stop, and rerun after changing source code. Do not run UI or server fragments separately.

The app uses `data/participant_reaction_times.csv`: 72 participant means across familiarisation conditions, with the original `speech` and `writing` group codes. Reaction times are in milliseconds. The groups contain different participants; the plots alone do not establish a causal effect of modality.

The original `data/spellname.csv` is retained as the source data. The supplied `prepare_teaching_data.R` regenerates the smaller CSV from it using one mean per participant and modality. It is not part of the in-class tasks. Run it from the Week 6 folder if you need to reproduce the preparation.

Detailed shared reactive expressions, multiple plots, and layout follow in later weeks. This week's core app needs only `shiny` and `tidyverse`.

After completing and testing your own app, use `worked_example_app.R` to compare behaviour, trace the connections, and explain any changes needed. This completed reference is introduced at the end of the slides and guide.
