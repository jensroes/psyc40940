# Week 8: Tabs and reliable controls

This week we build on the Week 7 app to organise plots into tabs, select one or several groups, and filter a reaction-time range. We will also add clear feedback when no observations match, so readers know how to recover.

Reactivity graphs help us trace which controls affect which outputs. Moving plots into tabs preserves those connections; adding a range extends the shared preparation. You will inspect examples, complete supplied code, predict results and test the app. No typing along with live coding is required.

By the end, you should be able to:

- organise useful views into tabs while preserving their server connections,
- choose group and range controls and extend a shared filter,
- explain an empty selection with a helpful recovery message,
- test both valid selections and recovery across tabs.

## Before the session

1. Have your completed Week 7 `layout_app.R` available for the opening recap. The slides also show the dependency graph needed for that task.
2. Download **`psyc40940-week-08-tabs-controls.zip`** and unzip the whole folder into your existing module RStudio project. Keep scripts and `data/` together inside `week-08-tabs-controls/`.
3. Open `01_tabs_and_reliable_controls.Rmd` and click **Knit**. Keep the HTML guide beside the app script; a ready-made HTML guide is also supplied.
4. The app exercises use the same `shiny` and `tidyverse` packages as previous weeks.

## Practical work

- **Exercise 1, about 20 minutes:** complete five blanks in `starter_app.R` to add two tabs and explain what each view contributes. The server and plots remain familiar.
- **Exercise 2A, about 12 minutes:** complete four active blanks in `controls_app.R` and test group and range filtering.
- **Exercise 2B, about 13 minutes:** continue in that same script, enable the supplied validation block and complete its two blanks. Write useful feedback and test empty selections and recovery.

Read instructions in the HTML guide, edit the named R scripts, and use **Run App**. Complete the blanks for the current checkpoint; the guide explains which code stays commented until later. You do not need to have completed Week 7's optional exercises.

## Optional independent practice

If the core app works, compare pooled and faceted histograms for different questions, or add the supplied third summary tab from `extension_app.R`. These tasks are independent and can be completed after class. Other control types are listed for reference.

The core app has two tabs and two plots. The assessment permits **up to three tabs**; it does not require three. A third tab or table should serve a useful purpose.

## After the session

Read Wickham's *Mastering Shiny*, [section 6.3.1: tabsets](https://mastering-shiny.org/action-layout.html#tabsets) and [section 8.1.4: validating outputs](https://mastering-shiny.org/action-feedback.html#validate-output). No written response is required.

Keep your working app and continue exploring a suitable dataset. Week 9 adds Plotly and time to adapt the dashboard to your own data or a supplied practice dataset. Completed reference code is introduced at the end of the guide, after you have tested your own version.
