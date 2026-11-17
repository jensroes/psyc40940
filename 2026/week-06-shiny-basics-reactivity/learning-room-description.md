# Week 6: Shiny basics and reactivity

This week we begin building interactive dashboards in R using Shiny. We will briefly explore real dashboards, then run a minimal app and trace how its user interface connects to its server. We will explain the server as a function Shiny calls and introduce `$` using a small data frame.

Together, let's examine working examples before completing and testing small code changes. We will build a reaction-time histogram with a group selector, a bin-width slider, and text explaining the data and controls. You do not need to type along with live coding.

By the end of the session, you should be able to:

- identify the roles of the UI and server,
- connect input controls to outputs using matching names,
- explain why changing a control updates an output,
- modify a supplied app and explain what it shows.

## Before the session

1. Download `psyc40940-week-06-shiny-basics-reactivity.zip` and unzip the whole folder into your existing module RStudio project. Keep the scripts and `data` folder together; do not move individual CSV files or work inside the ZIP.
2. Open `01_read_and_modify_a_shiny_app.Rmd` and click **Knit**. Read the resulting HTML guide beside your code. Its contents menu links to the sections named on the slides. The original guide knits before any blanks are completed.
3. Make sure Shiny is installed before class. If needed, run the guide's installation chunk once.

## Practical files

- `01_read_and_modify_a_shiny_app.Rmd`: instructions, a short `$` exercise, checks, and an optional dynamic-summary task.
- `minimal_app.R`: complete introductory app to inspect together.
- `starter_app.R`: Part 1, connecting a group selector to a histogram.
- `slider_app.R`: Part 2, adding a bin-width control and explanatory text.
- `extension_app.R`: optional dynamic-summary extension for spare time or independent practice.

Edit and run the small `$` exercise in the Rmd. Make Shiny changes in the named R scripts, replacing the `---` blanks, and use **Run App**. The HTML guide is for reading, not editing. After code changes, save, stop the app, and run it again; keep it running while testing controls.

## After the session

**Reading for everyone:** Hadley Wickham's [Mastering Shiny, Chapter 1](https://mastering-shiny.org/basic-app.html), sections **1.1-1.5**, ending with *Adding behaviour*. Focus on the UI/server connection and automatic updates. No written response or book exercises are required.

Keep your working app and start exploring possible datasets for the summative assessment. It is fine not to have found or chosen one yet.

After completing and testing your own app, use `worked_example_app.R` to compare behaviour and check your understanding. The final section of the guide explains how to use this completed reference.
