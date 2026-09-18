# PSYC40940 2026 Teaching Plan

This plan adapts the 2025 materials for a lighter 2026 delivery. The main change is to reduce the number of small exercises, move towards individual staged tasks, and separate foundational Shiny concepts from dynamic UI.

## Design Principles

- Use fewer exercises, each with a clear individual outcome.
- Keep live coding short and repeatable.
- Prefer one coherent app per Shiny session over many disconnected mini apps.
- Treat optional extensions as stretch tasks, not required class work.
- Reduce slide density before Shiny so students reach dashboards with enough cognitive bandwidth.

## Recommended Session Sequence

| Session | Topic | Core outcome | Exercise model |
|---|---|---|---|
| 1 | Module introduction and reproducibility workflow | Understand assessment, datasets, project structure, and reproducible reporting | Dataset search and project setup |
| 2 | Foundations of visualisation and `ggplot2` | Build and interpret simple plots | One scatterplot exercise plus optional extension |
| 3 | Grammar of graphics | Map variables to aesthetics intentionally | One guided plot rebuild |
| 4 | Major visualisation tools | Choose suitable plots for distributions, relationships, and groups | One analysis notebook with selected tasks |
| 5 | Customising visualisations | Improve labels, colour, theme, and export | One publication-ready figure task |
| 6 | Shiny basics and reactivity | Build a simple app with inputs, outputs, and `reactive()` | One individual starter app |
| 7 | Layout and observers | Structure dashboards and use buttons/observers for controlled updates | One dashboard layout task |
| 8 | Dynamic UI | Use `update*Input()`, `uiOutput()`, and `renderUI()` when the UI depends on data or previous choices | One dynamic-filter app |
| 9 | Interactive dashboards with Plotly and deployment | Add interactive Plotly outputs, consider deployment options, and check assessment dashboard reproducibility | One capstone starter app |
| 10 | Wrap up and assessment support | Resolve project-specific issues and check reproducibility | Individual assessment support |


## Main Content Reductions

- Compress detailed `ggplot2` theme internals. Students need enough theme control for the assessment, not a catalogue of every theme element.
- Shorten the grammar of graphics deck by keeping the data-aesthetic-geom-stat-facet-theme model and selected visual encoding examples.
- Make Plotly/3D optional. It is useful for inspiration but should not become a required skill unless directly needed for a student dashboard.
- Remove repeated Shiny micro-apps from required class activities. Keep reference examples available, but teach from fewer staged apps.

## Shiny Block

### Session 6: Shiny Basics and Reactivity

Required concepts:

- `fluidPage()`
- input widgets
- output placeholders
- `renderPlot()` and `renderTable()`
- `reactive()` for shared computation

Avoid or minimise:

- `observeEvent()`
- layout variants beyond `fluidPage()`
- dynamic UI

### Session 7: Layout and Observers

Required concepts:

- `sidebarLayout()`
- `navbarPage()` or `tabsetPanel()`
- `actionButton()`
- `observeEvent()`
- `eventReactive()`
- `update*Input()` as a controlled response to user action

This combines layout and observers because both support deliberate dashboard interaction.

### Session 8: Dynamic UI

Required concepts:

- dependent select boxes
- `uiOutput()`
- `renderUI()`
- conditional or generated controls
- when dynamic UI is worth the complexity

This is separate because students need to understand reactivity and observers before generated UI makes sense.

### Session 9: Interactive Dashboards with Plotly and Deployment

Required concepts:

- `plotlyOutput()` and `renderPlotly()`
- converting selected `ggplot2` plots with `ggplotly()`
- when interactive and 3D plots are useful rather than decorative
- assessment-ready project structure
- deployment options and reproducibility checks

## Exercise File Pattern

Each Shiny session should use:

- `starter_app.R`: students edit this individually.
- `worked_example_app.R`: reference version for class review.
- `extension_app.R`: optional challenge for confident students.

This replaces the 2025 pattern of many numbered app files.
