# Participant-level workshop data

`participant_reaction_times.csv` is unchanged from Weeks 6–8 and is used by the Plotly exercise.

`participant_behaviour.csv` is a richer extract of the same module-provided name-production experiment. One row is one participant and output modality (72 rows; 33 speech, 39 writing). Participant means are across familiarisation conditions, not trial-level observations.

- ppt_id: participant code; not an analysis variable.
- modality: speech or writing; different participant groups.
- mean_rt: mean reaction time in milliseconds.
- mean_duration: mean response duration in milliseconds.
- vocabulary_score: the participant vocabulary score supplied as ppt_vocab in the source. Consult the original study documentation before making stronger claims about its scale.

`prepare_workshop_data.R` documents the extraction from the original Week 6 `spellname.csv` (copied here as `spellname_source.csv`); students do not need to run it. The extract is supplied for practice; choose and justify a suitable behavioural dataset for your portfolio. Students using their own data must document the original source, definitions and access conditions.

Associations are not evidence of causation. Spoken and written production also involve different tasks; group differences need careful interpretation.
