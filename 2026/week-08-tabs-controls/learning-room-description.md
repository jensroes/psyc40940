# Week 8: Tabs and reliable controls

This week we build on the Week 7 app to organise plots into tabs, select one or several groups, and select participants within a vocabulary-score range. We will also add clear feedback when no observations match, so readers know how to recover.

Reactivity graphs help us trace which controls affect which outputs. Moving plots into tabs preserves those connections; adding a range extends the shared preparation. After completing the core app, you will label supplied boxes and draw the arrows for its graph, building on Week 7's graph-labelling task. You will inspect examples, complete supplied code, predict results and test the app. No typing along with live coding is required.

Both plots continue to display reaction time. The vocabulary-range control filters participants using an additional variable, so it changes the sample without changing the plotted variables.

By the end, you should be able to:

- organise useful views into tabs while preserving their server connections,
- choose group and range controls and extend a shared filter,
- explain an empty selection with a helpful recovery message,
- test both valid selections and recovery across tabs,
- complete a reactivity graph showing which inputs affect the shared selection and outputs.

## Before the session

1. Have your completed Week 7 `layout_app.R` available for the opening recap. The slides also show the dependency graph needed for that task.
2. Download `psyc40940-week-08-tabs-controls.zip` and unzip the whole folder into your existing module RStudio project. Keep scripts and `data/` together inside `week-08-tabs-controls/`.
3. Open `session-guide.html` in a web browser and keep it beside your app script. The guide is also available directly on NOW. Read its instructions and references in the browser; edit and run the app scripts in RStudio. You do not need to knit the guide.
4. The app exercises use the same `shiny` and `tidyverse` packages as previous weeks.

## Practical work

- Exercise 1, about 20 minutes: complete five blanks in `starter_app.R` to add two tabs and explain what each view contributes. The server and plots remain familiar.
- Exercise 2A, about 12 minutes: complete four active blanks in `controls_app.R` to combine group and vocabulary-range filters. Check that the count and both plots use the same selection. Multiple-group selection is a brief recap for students who tried it in Week 7.
- Exercise 2B, about 13 minutes: continue in that same script, enable the supplied validation block and complete its two blanks. Write useful feedback and test empty selections and recovery across both tabs.

After Exercise 2B, label the seven supplied empty boxes and add dependency arrows to complete the core app's reactivity graph from your code. Then check its names and arrows against the supplied answer (about four minutes).

Read instructions in the session guide, edit the named R scripts, and use Run App. Complete the blanks for the current checkpoint; the guide explains which code stays commented until later. You do not need to have completed Week 7's optional exercises.

## Optional independent practice

If the core app works, choose an independent extension:

- Complete seven blanks in `optional_density_app.R` to compare one pooled density curve with separate group curves using coloured outlines and transparent fills. Explain what pooling reveals or conceals.
- Complete four blanks in `optional_histogram_app.R` to add a checkbox that lets the reader switch between a pooled histogram and separate group panels with common scales and bin width.
- Add the supplied third summary tab from `extension_app.R` and test that it uses the same selected participants.

The density task develops colour and fill mappings; the histogram task develops user-controlled faceting. In both, test that the display control changes only its own plot. Update your reactivity graph by adding the new input and connecting it to the plot it changes. The guide explains the supplied conditional code and testing checkpoints.

Summary and Density are alternative third tabs. Choose one, or replace it when trying the other. The histogram task keeps two tabs. These tasks can be completed after class; other control types are listed for reference.

The core app has two tabs and two plots. The assessment permits up to three tabs; it does not require three. A third tab or table should serve a useful purpose.

## After the session

Read Wickham's *Mastering Shiny*, [section 6.3.1: tabsets](https://mastering-shiny.org/action-layout.html#tabsets) and [section 8.1.4: validating outputs](https://mastering-shiny.org/action-feedback.html#validate-output). No written response is required.

Bring a dataset for Week 9: have it available in your project, along with the code to load it, its source, and one question you would like to explore. A candidate dataset is fine if you are still deciding; supplied practice data remain available as a backup. Week 9 adds Plotly and time to adapt the dashboard.

Completed reference code is introduced at the end of the guide, after you have tested your own version.
