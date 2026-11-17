# Participant data for Week 8

One row is one participant mean across familiarisation conditions in the module's name-production dataset: 72 participants, 33 speech and 39 writing. The groups contain different participants.

- `ppt_id`: participant code.
- `modality`: speech or writing.
- `mean_rt`: mean reaction time in milliseconds; unchanged from Week 7.
- `vocabulary_score`: the score recorded as `ppt_vocab` in the original Week 6 `spellname.csv`. It is constant within each participant. Supplied values are retained on their recorded scale, rounded to four decimals to remove floating-point noise. Consult the original study documentation before interpreting the scale more strongly.

Observed vocabulary scores range from 0.8125 to 1.0000. The app slider spans 0.80–1.00, in steps of 0.01. With both groups selected, 0.90–0.95 retains 19 participants, while 0.80–0.81 retains none. Vocabulary selects the participants; the plots continue to show reaction time. Narrower selections are not evidence of invalid observations or causal effects.

`2026/scripts/prepare_week08_vocabulary.R` reproduces this extract from the Week 7 reaction-time means and the original participant vocabulary scores. Students receive the CSV ready to use. The same extract supplies the introductory Week 9 Plotly app; the later workshop uses a richer version with response duration.
