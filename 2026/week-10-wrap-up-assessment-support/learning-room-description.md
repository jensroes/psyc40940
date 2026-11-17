# Week 10: Reproduce and review your portfolio

Preliminary session information: the materials may be refined before the session.

This session brings together the report, separate Shiny app and supporting files for your summative portfolio. We will check that the work runs from the files you intend to submit, then use the remaining time for individual project work, questions and feedback. No new compulsory Shiny feature is introduced.

A working app is a starting point. We will also review whether your plots answer clear questions, whether the controls support useful exploration, and whether the report and app explain their choices and limitations. Use your individual formative feedback to identify improvements that matter for your summative work.

By the end, you should be able to:

- organise the report, app, data and supporting files into a reproducible project,
- render the report and run the app from a fresh extracted copy of your ZIP,
- identify missing files, package dependencies and paths that rely on your own computer,
- review the visualisations, explanations and reflection against the assessment brief,
- identify specific remaining improvements and a practical plan for completing them.

## Before the session

1. Bring your current summative project, including the data, Rmd report, latest rendered draft, app and supporting files, plus your Week 9 purpose sentence, tab sketch and reactivity graph. An unfinished project is fine; bring the code and errors you need help with.
2. Revisit your formative feedback, the current assessment brief and the summative submission guide on NOW. Note any requirements or feedback you are unsure how to address.
3. Download `psyc40940-week-10-wrap-up-assessment-support.zip` and unzip the whole folder. Open `session-guide.html` in a browser; you do not need to knit it.
4. If you do not yet have a runnable project, the supplied `submission-example/` project is available for practising the checks. It already contains `portfolio.Rproj`; open that project rather than creating another one.

## Practical work

Start with about five minutes to list four different static plot types for your report and at least two interactive plot views for your app. For each, state the question and what readers should learn. Identify one priority from your formative feedback for improving the static figures or their commentary. Keep this plan available during the checks and project work; your Session 9 reactivity graph can also help with app debugging.

Then open the Summative submission guide and find the AI declaration form in NOW Assessments. We will explicitly go through creating or checking an RStudio project, adding data and supporting files, saving and rendering the report, testing the separate app, and including the completed declaration. You can reuse an organised assessment project; a new project is needed only if you do not already have one.

Then inspect the supplied project and identify how its report and app find their data and load their packages. Knit `report.Rmd`, then open `app/app.R` and use Run App. The example continues Week 9's Dutch sentence-production study, with four static visualisation types and a separate app for exploring average and individual patterns.

Preparing the summative Rmd is a specific activity, about 15 minutes. Open or create your report inside the project, add appropriate Markdown headings and package/data setup, and include at least one working static figure with a caption, interpretation and design rationale. Reuse the citation and figure-reference format introduced in Week 1, and draw on your formative feedback. Knit a readable HTML draft and plan all four different static plot types; the report need not be complete in class. Keep reflection in the report and the Shiny app separate.

The extracted-ZIP practice takes about 15 minutes after the report-preparation activity. Use your own project if ready, or practise with the supplied example:

- Render the report and save the app.
- Create a ZIP containing the intended project files.
- Extract it to a different folder and open its RStudio project without restoring saved objects.
- Knit the extracted report and run the extracted app.
- Test the controls, tabs, empty selections and recovery. Fix missing files, packages or connections, then rebuild and retest the ZIP.

Use the summative submission guide to check the file set: the report Rmd and rendered report, RStudio project file, separate app, permitted data and required supporting files, package/version information, and the AI declaration available on NOW. Follow any agreed data-access arrangements. Check anonymity and the full requirements against the current assessment brief.

The teaching ZIP includes guides and examples; it is not your assessment submission. Include only the files needed for your own work.

## Project support and review

Most of the remaining time is for your project. Bring a specific question, the relevant file and any error message. If you are still choosing data, bring a source link and a description of the variables and observations.

If your report and app run, focus on communication: what each figure contributes, why the design suits the question, what an interaction reveals, and what the data cannot establish. Make sure an app reader can understand the question, controls, units and selected observations without your spoken explanation.

Record concrete reflection notes about decisions, challenges and compromises. Explain the consequences for the reader rather than listing functions you used. The report and dashboard should make complementary contributions using the same dataset.

## Resources for your portfolio

The slides and session guide collect targeted chapters from Wickham's Mastering Shiny on reactivity, debugging, layouts, user feedback and reactive graphs, alongside Andrews's Shiny chapter. They also revisit the ggplot2 book, Andrews's visualisation chapter and function references from earlier weeks. Use the R Markdown Cookbook for report problems and the R for Data Science project chapter for file organisation.

Posit's Shiny Assistant is an optional source of coding support. Ask about a specific error or small change, then understand and test the result. Follow the assessment's AI guidance and complete the official NOW declaration; the written commentary, interpretation and reflection must be your own work. These resources are for use when needed, not additional required reading.

## After the session

Aim to have a working report and app before the winter break, with a short list of remaining improvements. Use the assessment brief for the deadline, word guidance, anonymity and submission requirements, and the summative submission guide for preparing and checking the files.

Keep a backup of the exact ZIP you test and retain the submission confirmation after uploading your work.
