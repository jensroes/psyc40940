# Run from the repository root. Students receive the prepared CSV.
library(tidyverse)

d_rt <- read_csv(
  "2026/week-07-reactivity-layouts/data/participant_reaction_times.csv",
  show_col_types = FALSE
)
d_trials <- read_csv(
  "2026/week-06-shiny-basics-reactivity/data/spellname.csv",
  show_col_types = FALSE
)
d_scores <- summarise(
  group_by(d_trials, ppt_id, modality),
  score_count = n_distinct(ppt_vocab),
  vocabulary_score = round(first(ppt_vocab), 4),
  .groups = "drop"
)
stopifnot(all(d_scores$score_count == 1))
d_scores <- select(d_scores, ppt_id, modality, vocabulary_score)
d_participants <- left_join(d_rt, d_scores, by = c("ppt_id", "modality"))
stopifnot(nrow(d_participants) == 72, !anyNA(d_participants$vocabulary_score))

write_csv(d_participants,
          "2026/week-08-tabs-controls/data/participant_reaction_times.csv")
write_csv(d_participants,
          "2026/week-09-dashboard-workshop/data/participant_reaction_times.csv")
