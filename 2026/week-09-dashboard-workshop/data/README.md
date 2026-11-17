# Week 9 teaching data

## Supplied workshop: participant_rates.csv

Source: van Lieburg, Sijyeniyo, Hartsuiker and Bernolet (2023), The development of abstract syntactic representations in beginning L2 learners of Dutch.
Paper: https://doi.org/10.1007/s41809-023-00131-5
Public data: https://osf.io/x8ejm/

The ready CSV has 492 summaries from 17 learners at five testing occasions. One row is one learner, occasion, sentence condition and phase, summarising four target trials. Before and After refer to tasks within the same visit, around a short practice block. Passive use is a sentence-structure choice, not a correctness score. The task is to build the specified app; knowledge of the paper's methods and findings is not required.

| Column | Meaning |
|---|---|
| participant | learner code, P01–P17, repeated across rows |
| study_session | testing occasion, 1–5, approximately six weeks apart |
| prime_condition | Baseline, Active sentence or Passive sentence prompt |
| phase | Before or After the practice block at that occasion |
| n_passive | number of full passive responses out of four target trials; 0–4; the workshop outcome |
| passive_percent | alternative percentage: 100 × n_passive / n_trials |
| vocabulary_score | LexTALE vocabulary score measured once at occasion 4; optional filter |
| n_trials | number of target trials in the summary; always four |
| n_active, n_other | counts of active and remaining responses |
| scorable_trials | n_active + n_passive |
| passive_percent_scorable | percentage passive among active + passive responses only; NA if none |

The core app uses two controls: selected sentence conditions and one phase. All conditions in Before gives 246 rows; After also gives 246. Baseline in either phase gives 82. Both plots use one shared selection. The mean plot summarises learners, while individual paths reveal variation. Repeated rows are not independent learners; missing occasions have no row, not a zero.

The workshop plots n_passive: full passive responses out of four recorded trials. Individual counts are 0–4; the average plot shows a mean across learners and can have fractional values. Other responses or no response remain among the four trials. The paper's binary analyses exclude other response types, so these teaching figures do not reproduce its exact published percentages or models. Percentage columns remain available for tracing the preparation.

LexTALE is an optional third-control exercise. The range 0–1 includes everyone; observed scores are 0.4875–0.7875. Filtering this once-measured score selects learners and retains their available observations across all occasions. It is not a repeated vocabulary outcome. An empty range needs a recovery message.

## production_trials.csv

There are 2,232 production records: one learner's trial in one testing occasion. The columns are participant, study_session, trial_in_session, item, prime_condition, phase, response and vocabulary_score. Response categories are Active, Passive, Other, Short passive and No response.

The 1,968 ordinary target trials have Before/After phases; 264 intervention trials are marked During and Intervention. Do not pool those trial types without explaining the question. The file is available for tracing summaries or independent work, not required by the core app.

## Trial data for the short Plotly task

`trial_reaction_times.csv` contains 8,648 records from the familiar naming study: one trial per row, with repeated trials from each of 72 participants. It retains all supplied trial records, including unusually long timings. This is a demonstration of inspection, not a claim that extreme timings are errors or that trials are independent participants.

- `ppt_id`: participant code (33 speech and 39 writing participants).
- `trial_id`: trial number within participant.
- `stimulus`: image filename without its extension, for identifying the pictured stimulus on hover.
- `modality`: speech or writing.
- `rt`: trial reaction time in milliseconds.
- `dur`: response duration in milliseconds.
- `vocabulary_score`: the participant's recorded `ppt_vocab`, rounded to four decimal places for range comparisons; constant within participant.

There are 3,402 speech trials and 5,246 writing trials. The scatterplot shows duration versus reaction time, with group colours and transparent points. Hover identifies the stimulus, participant, trial and timing values. The other tab shows trial reaction-time distributions by group. Both tabs use the group and vocabulary filters; the count distinguishes unique participants from trial rows. Zoom and legend visibility change what is visible without changing those counts.

The vocabulary slider retains the 0.80–1.00 scale from Week 8 and its 0.01 step. Zoom into the main cloud to inspect local detail, then reset to restore the full timing range. The ready CSV is provided; students do not need to prepare raw files.

