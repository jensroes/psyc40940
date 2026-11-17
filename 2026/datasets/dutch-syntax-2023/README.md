# Dutch sentence production: teaching extract

Source: van Lieburg, R., Sijyeniyo, E., Hartsuiker, R. J., & Bernolet, S. (2023).
The development of abstract syntactic representations in beginning L2 learners
of Dutch. *Journal of Cultural Cognitive Science, 7*, 289–309.
https://doi.org/10.1007/s41809-023-00131-5

Public data and author analysis scripts: https://osf.io/x8ejm/.
This extract uses the longitudinal production experiment, not the native-speaker
control experiment or cross-sectional experiment. Source CSVs were retrieved
on 9 November 2026. `source-files.csv` records exact download URLs and checksums.
The OSF project metadata do not specify a project licence; retain the source
attribution and distinguish this teaching preparation from the authors' files.

Rebuild from the repository root with
`Rscript 2026/scripts/prepare_dutch_syntax_teaching_data.R`. It downloads the two
source files only if absent. The preparation is supplied by staff; students do
not need to run it. Original analysis scripts were inspected, not executed.

## What was prepared

- Retain 2,232 production records from 17 learners across five study sessions.
- Replace source participant codes with stable anonymous labels P01–P17.
- Retain session, trial/item codes, prompt condition, phase and response category.
  Remove utterance text, stimulus filenames and personal/background details.
- Join the 17 available vocabulary scores. They were measured at Session 4;
  repeating a score across rows does not make it a repeated proficiency measure.
- Summarise ordinary target trials into 492 rows, each representing one
  participant in one session, prompt condition and before/after phase.
- Retain intervention trials separately identified as During/Intervention in
  `production_trials.csv`; they are not pooled into the before/after summaries.
- Retain other responses and non-responses when calculating the teaching
  `passive_percent`, including zero-passive cells. No missing session is filled
  with zero.

## Interpretation and differences from the article

The target task is sentence production: a learner describes a picture after a
prompt. Active and passive are alternative sentence structures, not a simple
incorrect/correct distinction. Baseline prompts contain conjoined noun phrases;
the other conditions provide active or passive sentence prompts. Before and
After refer to the intervention within each study session, not separate groups.

The default percentage is passive responses divided by all four ordinary target
trials in a participant/session/condition/phase cell. The authors' main binary
production analyses exclude Other, Short passive and No response. The additional
`passive_percent_scorable` column uses Active + Passive as the denominator, with
NA when neither occurred. These two measures answer different questions; the
teaching app uses the all-trial denominator consistently and is not a reproduction
of the article's percentages or inferential models.

Available participants by session: 16, 17, 16, 17, 16. Fifteen learners have all
five sessions. Trial and summary rows repeat participants; never count rows as
independent people. Four trials per cell give coarse percentages (0, 25, 50,
75 or 100). Small samples and repeated exposure constrain interpretation;
descriptive before/after changes do not isolate an intervention's causal effect.
Do not fit mixed models as part of this teaching task.

Student-facing dictionaries are beside the CSVs in Weeks 9 and 10. Existing
reaction-time data remain only for Week 9's short, familiar Plotly exercise.
