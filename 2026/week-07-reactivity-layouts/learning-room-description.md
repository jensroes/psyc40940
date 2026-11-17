# Week 7: Shared data and clear layouts

This week starts with the familiar Week 6 app: one histogram, a group selector and a bin-width slider. We then open a supplied example that adds a boxplot with individual values and a participant count, and use `reactive()` to share one filtering step across those outputs. This makes the preparation easier to change and avoids repeating the same work. We will also arrange the controls, plots, and explanatory text in a sidebar layout.

We will begin with a short recall task using your completed Week 6 app, then work through examples and two core exercises. A reactivity graph shows which outputs depend on each input and how sharing the filter avoids repeated work. After Exercise 1, label a supplied graph from a short server example and check which outputs each input affects. You will complete or change supplied code, predict its behaviour, and test the result. There is no typing along with live coding. You do not need to have completed Week 6's optional task.

By the end of the session, you should be able to:

- share preparation across outputs using `reactive()`,
- obtain the current result from a reactive expression you created,
- label a reactivity graph and explain which controls affect which outputs,
- organise and explain an app using a simple sidebar layout.

## Before the session

1. Have your completed Week 6 `slider_app.R` available for the opening recall task. The slides also show the code needed for that review.
2. Download `psyc40940-week-07-reactivity-layouts.zip` and unzip the whole folder into your existing module RStudio project. Keep the scripts and `data` folder together.
3. Open `session-guide.html` in a web browser. Keep it beside your app script and use its contents menu to find the section named on the slides. Complete the app exercises in RStudio; the guide is for reading.
4. Use the same `shiny` and `tidyverse` packages as Week 6; no additional packages are needed for the app exercises.

## Practical files

- `session-guide.html`: the session guide by Jens Roeser, with examples, instructions, expected results, troubleshooting and references.
- `intro_app.R`: familiar Week 6 histogram with group and bin-width controls.
- `comparison_app.R`: supplied next example adding boxplot/points and count; repeated filtering motivates sharing the selected rows.
- `starter_app.R`: Exercise 1, about 20–25 minutes; complete six blanks, predict and test changes, then repair a mismatched output name.
- `layout_app.R`: Exercise 2, about 20–25 minutes; complete five blanks for layout and explanatory text, then test that the connections still work. Its server is already complete.

Read the session guide in your browser, and edit the named R scripts and use Run App to test them. The guide is not the Shiny app. After code changes, save, stop, and run again; keep the app running while testing controls.

Changing the group should update both plots and the participant count. Changing bin width should affect only the histogram.

## Optional independent practice

Choose one of two independent exercises for the remaining time, or continue after class:

- Compare both groups (`optional_groups_app.R`): complete four blanks to select one or both groups with checkboxes. Use `%in%` to filter the selection, separate the groups on the boxplot's x axis, and keep the histogram pooled. The guide explains each change.
- Add a summary table (`extension_app.R`): complete five blanks to connect and explain the supplied participant count, median and interquartile-range calculations. Complete and test this script directly; the guide explains each function and expected result.

Neither optional exercise requires completing the other. The two core exercises take priority.

## After the session

Reading for everyone: Hadley Wickham's [Mastering Shiny, section 1.6](https://mastering-shiny.org/basic-app.html#reducing-duplication-with-reactive-expressions), on sharing preparation with reactive expressions. No written response is required. [Chapter 6, section 6.2](https://mastering-shiny.org/action-layout.html#single-page-layouts) is optional layout reference.

Keep your working app and continue exploring possible summative datasets. It is fine not to have chosen one; adapting the app to your own data is not required this week.

After completing and testing your own app, use `worked_example_app.R` for comparison, as explained at the end of the guide. Tabs are taught as a core skill in Session 8; Plotly is introduced in Session 9.

