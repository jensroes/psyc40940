# Week 7: Shared data and clear layouts

This week develops the Week 6 app using the same participant data and controls. We will add a boxplot with individual values and a participant count, then use `reactive()` to share the filtering step across the outputs. We will also arrange the controls and outputs in a sidebar layout.

Together, let's inspect examples, predict what should change, then complete and test small modifications. The slides introduce each task before you attempt it. The completed reference is introduced at the end, after you have tested your own version.

A short supplied function example shows how a call can return a data frame, before we use `selected_data()` to obtain the shared reactive data. You do not need to have completed Week 6's optional function-writing exercise.

By the end of the session, you should be able to:

- share preparation across outputs using `reactive()`,
- obtain the current selected data using `selected_data()`,
- explain which controls affect which outputs,
- organise and explain an app using a simple sidebar layout.

## Before the session

1. Download `psyc40940-week-07-layout-observers.zip` and unzip the whole folder into your existing module RStudio project. Keep the scripts and `data` folder together.
2. Open `01_shared_data_and_layout.Rmd` and click **Knit**. Keep the HTML guide beside your app script and use its contents menu to find the section named on the slides.
3. Use the same `shiny` and `tidyverse` packages as Week 6; no additional packages are needed for the app exercises.

## Practical files

- `01_shared_data_and_layout.Rmd`: guided examples, instructions, expected results, and troubleshooting.
- `intro_app.R`: complete example with three outputs and repeated filtering.
- `starter_app.R`: Exercise 1, about 20 minutes; complete six blanks for shared data and output connections.
- `layout_app.R`: Exercise 2, about 22 minutes; complete five blanks for layout and explanatory text. Its server is already complete.
- `extension_app.R`: optional summary table, supported by the optional worksheet sections.

Read the instructions in HTML, but edit the named R scripts and use **Run App** to test them. The guide is not the Shiny app. After code changes, save, stop, and run again; keep the app running while testing controls.

Changing the group should update both plots and the participant count. Changing bin width should affect only the histogram. Tabs and the summary table are not required to complete the core session.

## After the session

**Reading for everyone:** Hadley Wickham's [Mastering Shiny, section 1.6](https://mastering-shiny.org/basic-app.html#reducing-duplication-with-reactive-expressions), on sharing preparation with reactive expressions. No written response is required. [Chapter 6, section 6.2](https://mastering-shiny.org/action-layout.html#single-page-layouts) is optional layout reference.

Keep your working app and continue exploring possible summative datasets. It is fine not to have chosen one; adapting the app to your own data is not required this week.

After completing and testing your own app, use `worked_example_app.R` for comparison, as explained at the end of the guide. Tabs are taught as a core skill in Session 8; Plotly is introduced in Session 9.
