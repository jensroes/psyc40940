# Assessment submission guides

Student handouts:

- `summative-submission-guide.html`: current final-portfolio submission workflow.
- `formative-submission-guide.html`: formative workflow, prepared for reuse in
  future teaching years as well as explaining the current expectations.

Upload the HTML handouts to NOW's Assessments area. They are self-contained,
browser-readable and printable, credit Jens Roeser, use regular-weight text,
and end with References. Students do not need the Rmd sources or CSS file.
`learning-room-text.md` provides short accompanying copy.

Build from the repository root:

```sh
Rscript 2026/scripts/render_submission_guides.R
```

Add `formative` or `summative` to build one guide. Edit the matching Rmd source;
the CSS is shared. There are no runnable app tasks in these handouts and no
sample assessment submission to copy. The AI declaration itself must be
downloaded from NOW, completed and included by the student.

Content is based on the 2026 briefs in `2026/admin/assessment-briefs/` and the
module leader's instruction to include the NOW AI declaration in both ZIPs.
The formative uses three feedback criteria and 3–4 plot techniques with no
dashboard component. The summative uses four static types, a separate app with
at least two interactive plots and at most three tabs, and reflection. The
guides are submission instructions, not replacement marking rubrics.

Before reusing in a new year, verify the brief's required files, word limits,
report formats, app requirements, anonymity rules, AI policy/form location and
submission process. Check software menu labels and support links. Dates are
deliberately left in the current brief/Dropbox rather than duplicated here.
Retain any approved restricted-data access arrangements. Week 1 teaches a
module project; these guides distinguish that class-work folder from a clean,
self-contained assessment project/copy.
