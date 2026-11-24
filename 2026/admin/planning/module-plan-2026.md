# PSYC40940 2026 teaching plan

The Shiny sequence was aligned to the current summative brief with Jens on 29 October 2026. See [Shiny teaching approach](shiny-block-plan-2026.md) for timing, rationale and exercise details.

| Session | Topic | Core outcome |
|---|---|---|
| 1 | Introduction and RMarkdown | Reproducible reporting, datasets and project organisation |
| 2 | Visualisation principles | Judge summaries and claims; build first ggplots |
| 3 | Grammar of graphics | Choose layers and aesthetics intentionally |
| 4 | Visualisation types | Choose useful geoms; distinguish raw values and summaries |
| 5 | Customisation and formative support | Clear labels, colour, themes and reproducible reporting |
| 6 | From a plot to a Shiny app | UI/server/input/output connections; group selector, bin-width slider and useful text |
| 7 | Shared data and clear layouts | Core paste/count output, reactive preparation, complementary plots and sidebar |
| 8 | Tabs and reliable controls | Core tabs, multiple-group/range filters and empty-selection feedback |
| 9 | Turn questions into a dashboard | Brief Plotly introduction, then adapt a two-view app to behavioural questions/data |
| 10 | Connect app controls and prepare the portfolio | Continue Week 9: shared filtering, connected views and testing; concise submission walkthrough and static-report reminder |

Teach each pattern using supplied examples, then code completion/modification, then a shared check. Do not rely on live coding or typing along. Each Shiny week has a session guide and full app scripts. Weeks 7–8 supply a browser-ready HTML guide only; Week 6 retains the Rmd for its short ordinary-R exercise. Introduce completed reference apps at the end.

The assessment requires four static visualisation types, meaningful app inputs, at least two interactive plots, and at most three tabs. Shiny-reactive plots qualify; Plotly is taught as an available tool rather than a compulsory addition to every plot. Tabs are core in Session 8. The optional Session 7 extension is a table, not tabs.

Generated UI, observers, controlled updates, download handlers and advanced layout/theme techniques remain optional project-specific tools. No extra functions are required just to fill teaching time. Session 10 preserves substantial individual support.

Keep existing week folder and ZIP names to avoid breaking links. Old Session 8/9 materials are archived. Student ZIPs contain current materials only; the submission-example project is a teaching aid, not a ready-made portfolio answer. Defer PPTX rendering until requested.

## For next year: a browser-ready guide for every session

Recorded with Jens on 6 November 2026: provide a session guide for every session,
using the current HTML session-guide format. Add each rendered HTML guide
directly to its session's NOW learning-room content so students can open and
read it there without downloading a guide or exercise ZIP first. Retain the
self-contained format, with embedded figures, clear activities and checkpoints,
and references. Keep the editable source for staff; app scripts, data and other
files needed to complete activities can still be supplied separately for
download. This is a planning note for next year, not a request to change or
publish the current learning-room materials.

Introduce reactivity graphs in the first Shiny session (Session 6), alongside
the first working app. Start with input-to-render dependencies and use the graph
to predict and test updates. Build on the same visual language in later sessions,
adding a shared reactive expression when it is introduced in Session 7. See the
[Week 6 notes](../../week-06-shiny-basics-reactivity/notes-for-next-year.md) for
the teaching rationale and scaffolding.

For next year's Week 9, create/check the dedicated summative assessment project before data import and app development. Put app.R and the report beside .Rproj, with data in data/, to prevent the Console/Run App path mismatch. See [Week 9 notes for next year](../../week-09-dashboard-workshop/notes-for-next-year.md).
