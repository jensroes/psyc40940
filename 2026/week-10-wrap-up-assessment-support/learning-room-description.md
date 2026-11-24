# Week 10: Connect your app controls and prepare your portfolio

This week continues from the app you started in Week 9. The next step is to connect input controls so readers can change what your plot shows, then add a second complementary view. Most of the session is for developing, testing and explaining your app. We will also go through the summative submission requirements and the structure of the static report.

We start by setting up your assessment project to address the data-loading problems encountered last week. Keeping the project file, app and report together gives their relative data paths the same starting point.

By the end, you should be able to:

- organise your report, app and data in one assessment project,
- connect UI controls to shared reactive filtering and your plots,
- test selections, empty results and recovery across both tabs,
- explain what each view and control contributes,
- identify the files and checks needed for a reproducible summative submission.

## Materials

- [HTML slides](https://jensroes.github.io/psyc40940/2026/week-10-wrap-up-assessment-support/week-10-wrap-up-assessment-support.html)
- [Session guide](https://jensroes.github.io/psyc40940/2026/week-10-wrap-up-assessment-support/session-guide.html)
- [Week 10 exercises (ZIP)](https://jensroes.github.io/psyc40940/2026/student-zips/psyc40940-week-10-wrap-up-assessment-support.zip)
- [Portfolio starter (ZIP)](https://jensroes.github.io/psyc40940/2026/student-zips/psyc40940-portfolio.zip)

The Week 10 ZIP already includes the portfolio starter; you do not need to download both ZIPs. The separate starter link is available if you only need the assessment project and report template.

Use the slides' Previous/Next arrow buttons or your keyboard arrow keys to move through them. Open the session guide in a browser beside RStudio; follow its instructions while editing and running your app script.

## Before the session

Download and unzip the Week 10 exercises. Have the app script and data file you used last week available, together with your purpose, tab sketch and reactivity graph. Save your current work and keep the original weekly files as a backup. Bring any current error and a note of what you expected to happen.

Have your formative feedback and the [summative assessment brief](https://now.ntu.ac.uk/d2l/le/lessons/1174881/topics/15225379) available. An unfinished app is fine. If you missed Week 9 or do not yet have a dataset, the download includes templates and practice data so you can join the workshop. No additional package installation is required for the core app tasks.

## Exercise 1: organise your assessment project

Allow about 10 minutes. Together, set up the supplied portfolio folder:

1. Copy the whole `psyc40940-portfolio/` folder from the unzipped download to the location where you want to keep your assessment work.
2. Copy the app script you started in Week 9 into that folder and rename the copy `app.R`.
3. Copy your data file into its existing `data/` folder. Keep the actual filename and extension, whether CSV, Excel, SPSS or another supported format. Include any additional files your app needs.
4. Double-click `psyc40940-portfolio.Rproj` inside the portfolio folder to open the project in RStudio.
5. Open the copied `app.R`, update the import path to your file inside `data/`, and use Run App to check the existing plot. Keep the import function appropriate to your file format.

The project already contains `report.Rmd`, `references.bib` and `apa.csl`. Keep these beside `app.R` and the project file. Knit the blank report once to check it renders; completing it continues independently.

If you have no working app yet, follow the guide's catch-up route after setting up the same project. With your own data, copy `own_data_app.R` as `app.R`, load your file and add one working ggplot to its first render block. Without a dataset, use `supplied_data_template.R` and the provided data; the guide gives you a first plot to complete. Once the plot works, continue to Exercise 2. A useful catch-up outcome is one plot responding to one control.

## Exercises 2 and 3: connect and extend your app

After a short explanation, Exercise 2 takes about 35 minutes, including testing and brief feedback. Add useful UI controls, complete shared reactive preparation and connect your first plot to the selected data. Test one input at a time, empty selections and recovery. If a control does not change the plot, trace its name, filter and plot connection against your graph. The guide provides supplied-data code to complete and explains how to adapt the pattern to your own variables.

Exercise 3 takes about 25 minutes. Add a complementary plot using the same shared selection. For supplied data, compare the average pattern with individual learner paths. Add explanations of the app's purpose, tabs, units and controls. Show the app to another student nearby, use their feedback to refine it and retest both views.

Two useful plots and two controls are the workshop target. If unfinished, save a runnable version and record the next connection to build. There is no need to repeat the Week 9 planning or Plotly exercise; additional features can follow once the core works.

You may use an AI coding assistant during these tasks. The guide includes a short prompt and shows how to obtain your chosen variable's available values in R. Supply those values and your current code, then ask how and where to add one control. Read, understand and test the suggested changes. Write your own assessment commentary, interpretation, design rationale and reflection, and declare any assistance using the official NOW form.

## Submission requirements and the static report

We will spend about 15 minutes walking through the submission requirements. Open the [summative submission guide](https://now.ntu.ac.uk/d2l/le/lessons/1174881/topics/15286394) and the [official AI declaration form](https://now.ntu.ac.uk/d2l/le/lessons/1174881/topics/15126556) on NOW.

Your submission needs one Rmd report and its rendered output, the RStudio project file, a separate runnable Shiny app, the data and supporting files needed to reproduce the work, package/version information and the completed AI declaration. Follow any agreed data-access arrangements. The walkthrough also covers anonymity and testing a fresh copy extracted from your final ZIP. Use the current brief and submission guide for the full requirements and upload instructions.

We will spend about five minutes identifying what the static report still needs. The starter report provides four figure sections with caption placeholders, an example citation and bibliography entry, dashboard commentary, reflection and package/version information. Give it your own meaningful title and section headings, choose four different static plot types, and replace all placeholders and the example citation with your own work and sources. Explain the findings and justify design choices using the visualisation principles. Use your formative feedback to identify an improvement for the new dataset.

The report and app should use the same dataset and make complementary contributions. Routine code can remain hidden in the rendered report; its source remains available in the submitted Rmd.

## After the session

Continue the app and static report, using the targeted resources in the guide when needed. Completed core app code is introduced at the end of the guide, after your own attempt. The separate `submission-example/` project is available for independent reproducibility practice.

Before submitting, follow the submission guide: assemble the required files and completed AI declaration, check anonymity, ZIP the project, extract it to a different folder, restart R and test both the report and app. This full check is independent preparation. Keep the tested ZIP and submission confirmation, and use the assessment brief for the deadline.
