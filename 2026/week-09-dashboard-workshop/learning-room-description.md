# Week 9: Turn questions into a dashboard

This week we build on Weeks 6–8 to plan and implement a small dashboard around a behavioural question. We first add Plotly hover and zoom to a familiar scatterplot, then spend most of the session deciding what an app should help readers explore and building it in stages. Use your proposed summative dataset if ready, or the supplied language-learning data for practice.

Plan the app's purpose and views before choosing controls. The aim is to make useful comparisons possible and explain them clearly to the reader. A small working prototype is a useful starting point; it does not need to be a polished assessment submission.

Open the [slides](https://jensroes.github.io/psyc40940/2026/week-09-dashboard-workshop/week-09-dashboard-workshop.html) and [session guide](https://jensroes.github.io/psyc40940/2026/week-09-dashboard-workshop/session-guide.html) in your browser. Download the exercise ZIP for the R scripts and data.

By the end, you should be able to:

- add Plotly hover and zoom to a ggplot displayed in Shiny,
- define an app purpose and choose two views that contribute different information,
- choose useful controls and sketch their connections to shared preparation and outputs,
- implement and test those connections using supplied outlines and earlier examples,
- use feedback from another student to improve the app's explanations and behaviour.

## Before the session

1. Bring your proposed summative dataset if ready, together with its source, code to load it and one question you would like to explore. Be able to explain what one row represents. If you are still choosing data, use the supplied dataset for practice.
2. Download `psyc40940-week-09-dashboard-workshop.zip` and unzip the whole folder into your existing module RStudio project. Keep the app scripts beside `data/` inside `week-09-dashboard-workshop/`.
3. Keep the session guide open in a browser beside RStudio. You can use the online version or open `session-guide.html` from the downloaded folder. Read the guide, edit the named R scripts and use Run App; you do not need to knit the guide.
4. If Plotly is not installed, run `install.packages("plotly")` in the RStudio Console. This only needs to be done once. The apps also use `shiny` and `tidyverse`.

## Practical work

Exercise 1: add hover and zoom, about 10 minutes after the introduction. Complete three connections in `plotly_app.R`. The scatterplot shows response duration and reaction time for 8,648 naming trials from 72 participants, coloured by speech/writing group. Zoom into the dense cluster, hover to inspect a stimulus and timings, then reset. Compare changing the visible region with filtering the observations, and test recovery from an empty selection.

Exercises 2 and 3: plan before coding. Allow about 20 minutes for planning and brief class feedback. Use pen and paper, Word, PowerPoint or similar; do not edit app code yet. Write an overall purpose, sketch two tabs and their plot types, and choose two useful controls. Then draw a preliminary reactivity graph showing inputs, shared reactive preparation and outputs. Label the tabs and arrows so you can predict which outputs each input should change.

Choose the data route before planning:

- Route A, your own data: use your dataset description, variables and question. You choose the plots and controls.
- Route B, supplied data: first read the guide's supplied-dataset section, including the variable table, suggested purposes and app requirements. These data accompany van Lieburg et al. (2023); the paper is linked in the guide. Each row summarises four trials for one learner, testing occasion, sentence condition and phase. The app compares average and individual counts of full passive responses out of four trials. You do not need to reproduce the paper's findings.

Exercise 4: implement your plan. Most of the remaining workshop time is for building and debugging, roughly 45 minutes across the two teaching blocks. Follow one coding route:

- Route A: use `own_data_app.R` or a copy of your current app. Load your data, make the ggplots work outside Shiny, then connect the controls, shared preparation and outputs.
- Route B: use `supplied_data_app.R`. The guide provides code to complete in stages: preview the plots, add the condition and phase controls, complete shared filtering, then connect one plot at a time.

Start with two tabs, two plots and two controls. Test each stage and update your graph when the design changes. Two working views are the target; if unfinished, retain a runnable version and identify the next step. The collapsed hints offer earlier examples when needed, rather than additional reading to complete now. No typing along with live coding is required.

Exercise 5: show your app to another student, about 10 minutes. Let someone nearby explore it before you explain it. Ask whether its purpose, tab roles, units and controls make sense. Use their feedback to refine it, then retest the affected controls, both tabs, empty selections and recovery where relevant. Record one change and why it helps the reader, or one choice that worked well.

## Optional independent practice

Once the core works, choose one useful addition: a numeric range filter, a faceting checkbox, or Plotly on a view. The guide supplies instructions and references to earlier examples. Keep two plots and no more than three controls for this exercise. These additions can be completed after class.

Plotly is optional for the assessment: plots that respond to Shiny controls already count as interactive. Completed reference apps are introduced at the end of the guide, after your own attempt.

## After the session

Read Wickham's *Mastering Shiny*, [section 7.1.6: interactivity limitations](https://mastering-shiny.org/action-graphics.html#interactivity-limitations). No written response is required.

Before Week 10:

- Confirm your proposed summative dataset and source, and explain what one row represents. If you used the supplied route, transfer the planning task to a candidate dataset of your own.
- Keep your purpose sentence, tab sketch and updated graph. Continue towards two working app plots and controls. Get at least one own-data ggplot working; bring any remaining error with a note of what you expected and the next step.
- Start or update your report Rmd. Plan four different static figure types and render a draft with at least one figure, using your formative feedback to identify an improvement.
- Bring the whole project, latest rendered report and specific questions.

Week 10 provides time for app refinement, static figures and report commentary, reproducibility checks, and the full submission requirements, including the AI declaration and summative submission guide. An unfinished but working starting point is fine; the supplied practice app is not your assessment submission.
