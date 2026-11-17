# Dutch sentence-production data: teaching dictionary

Source: van Lieburg, Sijyeniyo, Hartsuiker and Bernolet (2023), *The development
of abstract syntactic representations in beginning L2 learners of Dutch*.
Paper: https://doi.org/10.1007/s41809-023-00131-5
Public data and analyses: https://osf.io/x8ejm/

An active sentence is “The girl pushes the boy”; its passive alternative is
“The boy is pushed by the girl”. Participants described pictures after prompts.
Passive use is not a score of correctness or overall language ability.
The 17 learners were tested five times over eight months, about six weeks apart.
At each testing occasion, a short practice block used passive sentences with repeated
verbs; Before and After refer to responses before and after that block. This extract covers the longitudinal production experiment.

## participant_rates.csv — use this for the workshop app

There are 492 rows. One row represents one learner, one study session, one prompt
condition and one before/after phase. It summarises four recorded target trials.
The same learner therefore appears in many rows. No personal names are supplied.

| Column | Meaning |
|---|---|
| participant | Anonymous learner label, P01–P17 |
| study_session | Testing occasion, 1–5, about six weeks apart; not an independent group |
| prime_condition | Baseline, Active sentence or Passive sentence prompt |
| phase | Before or After the intervention within that session |
| n_trials | Number of recorded target trials in this row; always four |
| n_passive | Number coded as full passive sentences out of four trials (0–4); the workshop outcome |
| n_active | Number coded as active sentences |
| n_other | Other, short passive or no response; retained in the default denominator |
| passive_percent | 100 × n_passive / n_trials; retained as an alternative representation |
| scorable_trials | n_active + n_passive |
| passive_percent_scorable | Alternative percentage among Active + Passive only; NA if none |
| vocabulary_score | LexTALE score on a 0–1 scale, measured once at Session 4 |

Baseline prompts are conjoined noun phrases rather than active/passive sentences.
Select one, several or all sentence conditions. Separate panels keep conditions
distinct; the filter uses %in% to retain any selected condition.
Vocabulary score is repeated for convenience; it is not a score measured in
each session and need not be used in the core app.

Before and After are repeated observations of the same learners. There are
16, 17, 16, 17 and 16 observed learners in sessions 1–5 respectively; 15 have all
five. Missing occasions have no row, rather than a zero. Four trials per row
give integer counts from 0 to 4. Means across learners can be fractional. A line connects observed sessions;
it does not establish a smooth learning curve or an intervention's causal effect.

The default app selection (all three conditions, both phases, occasions 1–5) has
17 distinct learners and 492 summary rows. Selecting Baseline alone gives 164 rows;
Baseline and Before alone gives 82 rows. All testing occasions remain visible. Use n_distinct(participant) to count
people; nrow() counts summaries. Clearing all conditions or phases gives no rows and should
trigger a recovery message.

## production_trials.csv — supplied for tracing and alternative views

There are 2,232 records: one learner's production trial in one session.
The columns are participant, study_session, trial_in_session, item,
prime_condition, phase, response and vocabulary_score. Response categories are
Active, Passive, Other, Short passive and No response. The 1,968 ordinary target
trials have Before/After phases; the 264 intervention trials are marked During
and Intervention. Do not pool these trial types without explaining the question.

The authors' main binary analyses exclude Other, Short passive and No response.
Our count outcome retains all four trials, asking how many resulted in full
passive sentences. The percentage column is 100 times this count divided by four. The alternative scorable percentage asks how
often a response was passive among Active + Passive responses. State the
denominator and do not silently switch it. This is a teaching preparation,
not a reproduction of the paper's models or published percentages.

Staff preparation: 2026/scripts/prepare_dutch_syntax_teaching_data.R. Students
receive the prepared data and do not need to join, recode or summarise raw files.

The average comparison control changes colour/facet roles without changing selected rows. Error bars are mean ±1 SE across learner counts out of four trials in each occasion × condition × phase cell. They are not paired-difference intervals. Vocabulary was measured once, so it is not a longitudinal outcome.

The study-app LexTALE slider spans 0–1 in 0.0125 steps. Observed scores range from 0.4875 to 0.7875. It filters learners by their once-measured vocabulary score and retains their available observations across all five occasions. Empty selections require widening the range; SE bars are absent for cells with fewer than two learners. The earlier Week 8 vocabulary slider belongs to the separate reaction-time exercise.
