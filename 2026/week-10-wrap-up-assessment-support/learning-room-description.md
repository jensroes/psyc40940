# Week 10: Connect your app controls and prepare your portfolio

This week continues directly from the app you started in Week 9. You have made a plot appear inside Shiny; now connect input controls so readers can change what it shows. We start by organising a dedicated assessment project, then spend most of the session completing, testing and explaining your app. We will also go through the summative submission requirements.

Use your current app and data, even if unfinished. You do not need a completed report or dashboard before this session. The first priority is a working connection from a control through shared reactive preparation to your existing plot, followed by a second complementary view.

By the end, you should be able to:

- connect UI controls to shared reactive filtering and a plot,
- make a second view use the same selected observations,
- test selections, empty results and recovery in both tabs,
- explain the purpose, views and controls to another reader,
- identify the files and checks needed for the summative submission.

## Materials

- [HTML slides](https://jensroes.github.io/psyc40940/2026/week-10-wrap-up-assessment-support/week-10-wrap-up-assessment-support.html)
- [Session guide](https://jensroes.github.io/psyc40940/2026/week-10-wrap-up-assessment-support/session-guide.html)
- [Week 10 exercises (ZIP)](https://jensroes.github.io/psyc40940/2026/student-zips/psyc40940-week-10-wrap-up-assessment-support.zip)
- [Portfolio starter (ZIP)](https://jensroes.github.io/psyc40940/2026/student-zips/psyc40940-portfolio.zip)

The slides have Previous/Next arrow buttons; the keyboard arrow keys also work.

## Before the session

1. Bring and save the app script and actual data files you used in Week 9, together with your purpose, tab sketch and reactivity graph. Keep the original weekly work as a backup. Bring any current error and a note of what you expected to happen.
2. Download `psyc40940-week-10-wrap-up-assessment-support.zip` and unzip the whole folder into your module project. Open `session-guide.html` in a browser beside RStudio; edit the app script and use Run App.
3. We will copy your working script into a dedicated assessment project as `app.R`, with the data in `data/`. If you missed Week 9 or have no working app, the download also includes its own-data and supplied-data templates for the catch-up route. The included `psyc40940-portfolio/` supplies a project file, a report template, an example bibliography and APA style file. Copy this folder to your assessment location, copy last week's app into it as `app.R`, and copy your data file into `data/`, keeping its filename and format. Double-click `psyc40940-portfolio.Rproj` to open the project.
4. Have your formative feedback and the [summative assessment brief](https://now.ntu.ac.uk/d2l/le/lessons/1174881/topics/15225379) available. Bring your report draft if started; it is fine if the app is still your immediate priority. No additional package installation is required for the core tasks.

## Continue building the app

The first teaching block focuses on connecting your existing plot:

- Exercise 1, about 10 minutes: address the path and data-loading problems encountered in Week 9. Copy the supplied portfolio folder, copy last week's app into it and rename the copy `app.R`, put your data file into `data/`, and double-click `psyc40940-portfolio.Rproj`. Update the import path and check the existing plot. The blank report knits immediately; completing it is independent work. Keep `app.R`, the report Rmd and `.Rproj` at the same folder level. Both app and report can then use the same `data/` path with your actual filename and the import function for its format, including when checking the import from the project Console.
- After a short explanation, Exercise 2 takes about 35 minutes, including testing and brief feedback: add UI controls, complete shared reactive preparation and connect the first plot. Test one input at a time, empty selections and recovery. If a control does not change the plot, trace its name, filter and data connection against your graph. The guide provides supplied-data code to complete and explains how to adapt the pattern to your own variables.

If you missed Week 9 or have not built the first plot, begin with the same project-organisation task. With your own data, copy `own_data_app.R` as `app.R`, load your data file and put one working ggplot into its first render block. Without a dataset, use `supplied_data_template.R` and the provided CSV; the guide supplies a first plot to complete. These are the Week 9 templates, included again so you do not need a separate download. Once that plot runs, continue with the controls task. A useful catch-up outcome is one plot responding to a control; identify a candidate dataset and next step for your own assessment before leaving.

You may use an AI coding assistant during the app work. The guide shows how to get R to list the chosen variable and its available values. Copy the command and output with your current app code into the short prompt, then ask how and where to add the control in the UI and server. Read and test the suggested changes in RStudio. This is optional help within the existing exercises. Write your own assessment commentary and design rationale, and declare any assistance using the official NOW form.

Exercise 3 starts the second block, about 25 minutes. Add the complementary plot from your Week 9 plan and make it use the shared selection. For supplied data, compare the average pattern with individual learner paths, using full passive-response counts out of four trials. Add explanations of the app's purpose, tabs, units and controls. Show the app to another student nearby, use their feedback to refine it and retest both views.

Two useful plots and two controls remain the workshop target. If unfinished, save a runnable version and record the next connection to build. You do not need to repeat the Week 9 planning or Plotly exercise. Extra features can wait until the core works.

## Submission requirements and the static report

We will protect about 15 minutes for the full submission sequence. Open the [summative submission guide](https://now.ntu.ac.uk/d2l/le/lessons/1174881/topics/15286394) on NOW and the [official AI declaration form](https://now.ntu.ac.uk/d2l/le/lessons/1174881/topics/15126556). Building on the project organised at the start, this walkthrough checks the report, app, actual data and supporting files, anonymity, the completed declaration, and testing an extracted ZIP. The guide retains the full project-creation steps for reference.

Submit one Rmd report and its rendered output, the RStudio project file, a separate runnable Shiny app, the data and any helper/bibliography/style files needed, package/version information, and the required NOW AI declaration. Follow agreed data-access arrangements where needed. Use the current brief and submission guide for the authoritative file requirements and upload instructions. The weekly teaching ZIP is not your assessment submission.

The full fresh-session extracted-ZIP check is essential before submission, but is independent preparation rather than another timed exercise during this app workshop. Detailed project, report and ZIP instructions remain in collapsed reference sections of the session guide. The separate `submission-example/` project is available for practising these checks after class; it is not a set of extra app features to reproduce today.

The starter is also available separately as `psyc40940-portfolio.zip`. Its report template provides four figure sections, captions, one citation example, dashboard commentary, reflection and package/version information. Replace its placeholders and example citation with your own work.

We will also spend about five minutes identifying what the static report still needs. Plan four different static plot types with clear questions, interpretation and justified design choices. Use your formative feedback to identify one improvement for the new dataset. The dashboard complements this report; it does not replace the static figures, commentary or reflection.

## After the session

Save the app and graph, and write a specific next step. Continue the static report independently, with meaningful Markdown headings, captioned figures, citations, interpretation, design reasoning and reflection. The report and app should use the same dataset and make complementary contributions.

Use the targeted Shiny, ggplot2 and RMarkdown resources in the guide when needed; they are optional references, not additional tasks. Completed core app code is introduced at the end of the guide, after your own attempt.

Before submitting, follow the [summative submission guide](https://now.ntu.ac.uk/d2l/le/lessons/1174881/topics/15286394): assemble the required files and official AI declaration, check anonymity, ZIP them, restart R, extract to a different folder and test both the report and app. Retain the tested ZIP and submission confirmation. Use the assessment brief for the deadline and full requirements.
