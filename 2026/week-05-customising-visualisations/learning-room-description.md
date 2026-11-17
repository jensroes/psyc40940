# Week 5: Customising visualisations

This week we will customise visualisations to help readers understand the data and make meaningful comparisons. We will focus on labels and legends, colour choices for different variable types, and choosing a useful built-in theme.

The session links back to the Week 2 principles and Tufte's ideas about data-ink, chartjunk, small multiples, and guiding interpretation. We will consider which elements help readers and which create unnecessary distraction. Theme choices are not just personal preferences: grids, backgrounds, and panel boundaries support different reading tasks.

The practical work has two parts. First, you will identify problems with an original plot, write meaningful labels, and compare colour palettes and overlapping distributions. Second, you will start one formative assessment template and draft a figure for your data or question. Detailed facet and theme customisation is available in a separate supplementary slide set and optional exercise for your own time.

By the end of Week 5, you should be able to:

- improve plot labels using `labs()`,
- choose legend labels, colour palettes, and aesthetics that support comparison,
- explain how customisation choices connect to visualisation principles,
- choose a built-in theme for the reading task and output medium,
- begin an assessment-style RMarkdown document using either the provided dataset or your own candidate dataset.

## Before the practical work: weekly files

Download the Week 5 zip folder from this week's section in the NOW Learning Room. Unzip the folder, then move the unzipped Week 5 folder into your existing module RStudio Project folder. Do not work inside the zip file.

Keep the `.Rmd` files, `data` folder, and supporting files together. In the exercises that use patchwork, an installation chunk is provided with `eval = FALSE`. Run it once if the package is not already installed; run the library chunks each time you start a new R session.

## Week 5 files

`week-05-customising-visualisations`  
Main slides for the taught session, available as HTML and PowerPoint.

`week-05-supplementary-customising-visualisations`  
**Supplementary Materials: Customising Visualisations.** Separate HTML and PowerPoint slides with worked examples of facet labels and detailed theme customisation. Explore these in your own time alongside `03_themes.Rmd`.

`psyc40940-week-05-customising-visualisations.zip`  
Student practical materials for the week.

`01_labels_and_legends.Rmd`  
In-class practical (about 12 minutes). First inspect the original plot, then complete Tasks 1-3: write axis labels, distinguish legend titles from group labels, and label shape and combined colour/shape legends. Fill legends and recoding are marked optional; you are welcome to continue through them.

`02_colours_and_aesthetics.Rmd`  
In-class practical (about 12 minutes). Complete Tasks 1-2: compare palette functions and choose how to show overlapping distributions. Complete the code marked `---` and use side-by-side plots to judge your choices. Continuous scales and their reversal, manual palettes, and outline-only densities are marked optional; you are welcome to continue through them.

`03_themes.Rmd`  
Optional/homework/reference practical on themes. Use this after class if you want more practice with `theme()` and theme functions. The separate **Supplementary Materials: Customising Visualisations** slide set provides worked examples of facet labels and theme customisation.

`04_formative_practice_provided_data.Rmd`, `05_formative_planning_own_data.Rmd`  
Assessment-support templates. In the second block of the session, choose one template: use the provided-data template to practise the formative structure, or the own-data template to start working with your candidate dataset.

`data/`  
Data files needed by the weekly practicals and the provided-data formative template.

`references.bib` and `apa.csl`  
Bibliography and citation style files used by the weekly materials where needed.

## Formative assessment submission

Submit one ZIP archive containing your R Markdown (`.Rmd`), rendered HTML report (`.html`), RStudio project (`.Rproj`), data files, supporting files (including bibliography, citation style, images, and helper scripts used), and GenAI Usage Declaration Form. Keep the project folder structure intact and the submission anonymous.

Check reproducibility by unzipping into a new folder, opening the project, restarting R, and knitting the report. Use relative paths and include any additional package requirements or setup instructions in a short README. If we have agreed a data-licence exception, include the dataset link and exact download instructions instead of the restricted data file, including its filename and location in the project.

## Homework before Week 6

Continue working on the formative assessment template you started in class. Aim to have at least one draft visualisation and a short note explaining what the figure is meant to show, why you chose that visualisation, and what you might need to change to make the comparison clearer.

The formative assessment is due **Friday 30 October 2026, before 2 pm** (maximum 1,000 words). Develop 3-4 visualisations using different techniques, with commentary on what they show, why you chose them, and what they may hide.

For further practice, use `03_themes.Rmd` and the supplementary slide set. Focus on changes that help readers rather than trying every option.
