# Week 10 continuation data

These are the prepared data used in Week 9: van Lieburg, Sijyeniyo, Hartsuiker and Bernolet (2023), *The development of abstract syntactic representations in beginning L2 learners of Dutch*. [Paper](https://doi.org/10.1007/s41809-023-00131-5). [Public data](https://osf.io/x8ejm/).

`participant_rates.csv` contains 492 summaries from 17 learners. One row combines four target trials for one learner, testing occasion, sentence condition and phase. Repeated rows are not additional learners, and missing occasions are not zero responses.

- `participant`: anonymous learner label.
- `study_session`: testing occasion, 1–5.
- `prime_condition`: Baseline, Active sentence or Passive sentence.
- `phase`: Before or After the practice block within an occasion.
- `n_passive`: full passive responses out of four trials, 0–4. The average across learners can be fractional.
- `n_trials`: always four; other responses and no response remain among the four trials.
- `vocabulary_score`: measured once; not needed for the core continuation tasks.

Passive use is a sentence choice, not a correctness score. These exploratory counts do not reproduce the paper's binary analyses, which exclude other response types. The unchanged CSV also retains counts and percentage alternatives for tracing preparation. Use `n_passive` for the continuation plots.

The starting app shows average counts in the Before phase. Add controls to change the selected observations and connect both plots to the shared reactive result. You do not need to prepare or join the data again.
