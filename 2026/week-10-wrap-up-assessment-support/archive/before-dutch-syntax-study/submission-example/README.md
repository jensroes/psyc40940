# Reproducibility practice project

This example is complete and runnable; it is a teaching aid, not a model assessment answer.

Open `portfolio.Rproj`, Knit `report.Rmd`, then open `app/app.R` and choose Run App. The report reads `data/participant_behaviour.csv` from the project root. The app reads `../data/participant_behaviour.csv` relative to its app folder. Keep this structure intact.

The original data are the module-provided name-production extract used in Week 9, with one row per participant and means across familiarisation conditions. Both time variables are milliseconds; vocabulary_score retains the supplied ppt_vocab values. Different output groups contain different participants. Source preparation is documented in the Week 9 teaching folder; your assessed portfolio needs a suitable behavioural dataset with its original source citation and transparent preparation.

Before zipping a real portfolio, keep exactly one Rmd report and its rendered HTML (PDF only with a good reason), the existing RStudio project file, `app/app.R`, data, and required bibliography/helper files. Include setup packages, `sessionInfo()` in the report, and access instructions/code if data cannot be included. Include the required AI declaration according to the NOW submission instructions.

Do not include this week's exercise guide, slide deck, archive, .RData, .Rhistory, or unused drafts in an assessment ZIP. Check for names/N numbers in content, filenames, project names and paths. The maximum is 2,000 words across report text, figure commentary/captions, dashboard explanatory text and reflection; code, references, raw R output and data-file contents are excluded.

The four example figures demonstrate report structure and rendering. Choose and justify your own four plot types for your behavioural questions; a chart counting groups is not automatically useful.

Close RStudio or restart R, extract a copy of the ZIP into a new temporary folder, open the extracted project and rerun both outputs. Testing the original folder does not test your submission.
